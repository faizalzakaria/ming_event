# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ming_event/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Faizal Zakaria"]
  gem.email         = ["phaibusiness@gmail.com"]
  gem.description   = %q{ "Ming event, this will broadcast signal to all the observers when timeout is reached" }
  gem.summary       = %q{ "Ming event" }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ming_event"
  gem.require_paths = ["lib"]
  gem.version       = MingEvent::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
