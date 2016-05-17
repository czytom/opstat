# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opstat-master/version'

Gem::Specification.new do |spec|
  spec.name          = "opstat-master"
  spec.version       = Opstat::VERSION
  spec.authors       = ["Krzysztof Tomczyk"]
  spec.email         = ["office@optilabs.eu"]
  spec.description   = %q{Systems monitoring tool}
  spec.summary       = %q{Systems monitoring tool that works}
  spec.homepage      = "http://www.optilabs.eu/opstat"
  spec.license       = "GPL-3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "opstat-plugins", Opstat::VERSION
  spec.add_dependency "eventmachine"
  spec.add_dependency "json"
  spec.add_dependency "amqp"
  spec.add_dependency "daemons"
  spec.add_dependency "mongo_mapper"
  spec.add_dependency "bson_ext"
  spec.add_dependency "xml-simple"
  spec.add_dependency "log4r"
  spec.add_dependency "influxdb"
end
