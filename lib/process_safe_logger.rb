require 'logger'

if ::Logger::LogDevice.private_method_defined?(:lock_shift_log)
  class ProcessSafeLogger < ::Logger
  end
else
  class ProcessSafeLogger < ::Logger
    # Override to use ::ProcessSafeLogger::LogDevice
    def initialize(logdev, shift_age = 0, shift_size = 1048576)
      super(nil, shift_age, shift_size)
      if logdev
        @logdev = ::ProcessSafeLogger::LogDevice.new(logdev, :shift_age => shift_age,
                                :shift_size => shift_size)
      end
    end

    class LogDevice < ::Logger::LogDevice
      # Override as my patch
      def open_logfile(filename)
        begin
          open(filename, (File::WRONLY | File::APPEND))
        rescue Errno::ENOENT
          create_logfile(filename)
        end
      end

      # Override as my patch
      def create_logfile(filename)
        begin
          logdev = open(filename, (File::WRONLY | File::APPEND | File::CREAT | File::EXCL))
          logdev.flock(File::LOCK_EX)
          logdev.sync = true
          add_log_header(logdev)
          logdev.flock(File::LOCK_UN)
        rescue Errno::EEXIST
          # file is created by another process
          logdev = open_logfile(filename)
          logdev.sync = true
        end
        logdev
      end

      # Override as my patch
      def add_log_header(file)
        file.write(
          "# Logfile created on %s by %s\n" % [Time.now.to_s, Logger::ProgName]
        ) if file.size == 0
      end

      # Override as my patch
      def check_shift_log
        if @shift_age.is_a?(Integer)
          # Note: always returns false if '0'.
          if @filename && (@shift_age > 0) && (@dev.stat.size > @shift_size)
            lock_shift_log { shift_log_age }
          end
        else
          now = Time.now
          period_end = previous_period_end(now)
          if @dev.stat.mtime <= period_end
            lock_shift_log { shift_log_period(period_end) }
          end
        end
      end

      # Defien as my patch
      if /mswin|mingw/ =~ RUBY_PLATFORM
        def lock_shift_log
          yield
        end
      else
        def lock_shift_log
          retry_limit = 8
          retry_sleep = 0.1
          begin
            File.open(@filename, File::WRONLY | File::APPEND) do |lock|
              lock.flock(File::LOCK_EX) # inter-process locking. will be unlocked at closing file
              ino = lock.stat.ino
              if ino == File.stat(@filename).ino
                yield # log shifting
              else
                # log shifted by another process (i-node before locking and i-node after locking are different)
                @dev.close rescue nil
                @dev = open_logfile(@filename)
                @dev.sync = true
              end
            end
          rescue Errno::ENOENT
            # @filename file would not exist right after #rename and before #create_logfile
            if retry_limit <= 0
              warn("log rotation inter-process lock failed. #{$!}")
            else
              sleep retry_sleep
              retry_limit -= 1
              retry_sleep *= 2
              retry
            end
          end
        rescue
          warn("log rotation inter-process lock failed. #{$!}")
        end
      end
    end
  end
end
