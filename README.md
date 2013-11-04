# Process Safe Logger [![Build Status](https://secure.travis-ci.org/sonots/process_safe_logger.png?branch=master)](http://travis-ci.org/sonots/process_safe_logger) [![Dependency Status](https://gemnasium.com/sonots/process_safe_logger.png)](https://gemnasium.com/sonots/process_safe_logger)

testing ruby: 1.9.2, 1.9.3, 2.0.0;

## About Process Safe Logger

Process Safe Logger supports log rotations in multi-processes *safely*.

## Objective

Ruby's standard Logger class originally have had a problem that it's log rotation function does not work safely in multi process environment. This gem fixes the problem. 

The patch is already pull requested to the [githb.com:ruby/ruby](https://github.com/ruby/ruby/pull/428) and will be released with ruby 2.1.0. 

## Installation

    gem install process_safe_logger

## Usage

```ruby
require 'process_safe_logger'
logger = ProcessSafeLogger.new('logfile.log', 3, 1024)
```

Option parameters are same with Ruby's Logger. See [docs.ruby-lang.org:Logger](http://docs.ruby-lang.org/en/2.0.0/Logger.html).

## Further Reading

1. [sonots:blog : RubyのLoggerはスレッドセーフ(＆プロセスセーフ)かどうか調べてみた](http://blog.livedoor.jp/sonots/archives/32645828.html) (Japanese)
2. [Inter-process locking for log rotation by sonots · Pull Request #428 · ruby/ruby](https://github.com/ruby/ruby/pull/428)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## License

Same with ruby.
