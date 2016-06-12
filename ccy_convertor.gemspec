# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ccy_convertor/version'

Gem::Specification.new do |spec|
  spec.name          = "ccy_convertor"
  spec.version       = CcyConvertor::VERSION
  spec.authors       = ["Rohan Pujari"]
  spec.email         = ["rohanpujaris@gmail.com"]
  spec.summary       = %q{CcyConvertor provides live currency rate for various currencies and allows to convert money from one currency to other}
  spec.description   = %q{CcyConvertor provides live currency rate for various currencies and allows to convert money from one currency to other. Currently it supports 3 rate provider. New rate provider can be easily plugged in}
  spec.homepage      = "https://github.com/rohanpujaris/ccy_convertor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "activesupport", ">= 3.0"
end
