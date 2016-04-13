# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pay2go/version'

Gem::Specification.new do |spec|
  spec.name          = "pay2go_client"
  spec.version       = Pay2go::VERSION
  spec.authors       = ["Calvert"]
  spec.email         = [""]

  spec.summary       = %q{API client for pay2go}
  spec.description   = %q{API client for pay2go}
  spec.homepage      = "https://github.com/CalvertYang/pay2go"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "sinatra"
end
