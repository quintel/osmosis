# coding: utf-8
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'osmosis/version'

Gem::Specification.new do |s|
  s.name          = 'osmosis'
  s.version       = Osmosis::VERSION
  s.platform      = Gem::Platform::RUBY

  s.authors       = [ 'Anthony Williams' ]
  s.email         = [ 'hi@antw.me' ]

  s.homepage      = 'http://github.com/quintel/osmosis'
  s.summary       = 'Balanced groups of numeric values.'
  s.description   = 'Balanced groups of numeric values.'
  s.license       = 'BSD'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(spec|features)/})
  s.require_paths = [ 'lib' ]

  s.add_development_dependency 'bundler', '>= 1.2.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
