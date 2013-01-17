# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smux/version'

Gem::Specification.new do |gem|
  gem.name          = "smux"
  gem.version       = Smux::VERSION
  gem.authors       = ["Andrew De Ponte"]
  gem.email         = ["cyphactor@gmail.com"]
  gem.description   = %q{smux is a session based tmux launcher and dsl. It is primarily used for creating per project tmux sessions and managing them.}
  gem.summary       = %q{The session based tmux launcher}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('trollop')

  gem.add_development_dependency('rspec')
end
