# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plivo/version'

Gem::Specification.new do |spec|
  spec.name          = 'plivo'
  spec.version       = Plivo::VERSION
  spec.authors       = ['The Plivo SDKs Team']
  spec.email         = ['sdks@plivo.com']

  spec.summary       = 'A Ruby SDK to make voice calls & send SMS using Plivo '\
                       'and to generate Plivo XML'
  spec.description   = 'The Plivo Ruby SDK makes it simpler to integrate '\
                       'communications into your Ruby applications using the '\
                       'Plivo REST API. Using the SDK, you will be able to '\
                       'make voice calls, send SMS and generate Plivo XML to '\
                       'control your call flows.'\
                       ''\
                       'See https://github.com/plivo/plivo-ruby for more information.'
  spec.homepage      = 'https://github.com/plivo/plivo-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '~> 0.12.2'
  spec.add_dependency 'htmlentities'

  spec.add_development_dependency 'bundler', '>= 1.14', '<3.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'json'
  spec.add_development_dependency 'simplecov'
end
