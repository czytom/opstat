# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opstat-client/version'

Gem::Specification.new do |spec|
  spec.name          = "opstat-client"
  spec.version       = Opstat::VERSION
  spec.authors       = ["Krzysztof Tomczyk"]
  spec.email         = ["office@optilabs.eu"]
  spec.description   = %q{Systems monitoring tool}
  spec.summary       = %q{Systems monitoring tool that works}
  spec.homepage      = "http://www.optilabs.eu/opstat"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 12'
  spec.add_dependency "eventmachine", '~> 1'
  spec.add_dependency "opstat-plugins", Opstat::VERSION
  spec.add_dependency "json", '~> 2'
  spec.add_dependency "log4r", '~> 1'
  spec.add_dependency "amqp", '~> 1'
  spec.add_dependency "xml-simple", '~> 1'
  spec.add_dependency "daemons", '~> 1'
end
