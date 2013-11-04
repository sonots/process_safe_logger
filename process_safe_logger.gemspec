#! /usr/bin/env gem build
# encoding: utf-8

Gem::Specification.new do |gem|
  gem.name          = 'process_safe_logger'
  gem.version       = File.read(File.expand_path('VERSION', File.dirname(__FILE__))).chomp
  gem.authors       = ["Naotoshi Seo"]
  gem.email         = ["sonots@gmail.com"]
  gem.homepage      = "https://github.com/sonots/process_safe_logger"
  gem.summary       = "Process-safe Logger supports log rotations in multi-processes safely"
  gem.description   = gem.summary

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # for testing
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11"

  # for debug
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-nav"
end
