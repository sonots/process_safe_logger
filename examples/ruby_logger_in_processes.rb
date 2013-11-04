require 'logger'
require 'parallel'

logger = Logger.new("/tmp/test.log", 3, 1024 * 10)
Parallel.map(['a', 'b'], :in_processes => 2) do |letter|
  300000.times do
    logger.info letter * 5000
  end
end
