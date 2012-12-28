# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tvrage/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Erik van der Wal"]
  gem.email         = ["erikvdwal@gmail.com"]
  gem.homepage      = "http://www.erikvdwal.nl/"
  gem.description   = %q{Simple library to access the TVRage XML feeds}
  gem.summary       = %q{Simple library to access the TVRage XML feeds}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tvrage"
  gem.require_paths = ["lib"]
  gem.version       = Tvrage::VERSION

  gem.add_runtime_dependency "nokogiri"
  gem.add_development_dependency "rspec"
end
