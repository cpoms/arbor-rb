# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arbor/version'

Gem::Specification.new do |spec|
  spec.name          = "arbor"
  spec.version       = Arbor::VERSION
  spec.authors       = ["Mike Campbell"]
  spec.email         = ["mike.campbell@meritec.co.uk"]
  spec.description   = %q{Interface for the Arbor Education REST API.}
  spec.summary       = %q{Interface for the Arbor Education REST API.}
  spec.homepage      = "http://github.com/meritec/arbor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 3.0.0"
  spec.add_dependency "httpi", "~> 2.0.5"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
