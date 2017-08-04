# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanami/shrine/version'

Gem::Specification.new do |spec|
  spec.name          = "hanami-shrine"
  spec.version       = Hanami::Shrine::VERSION
  spec.authors       = ["Paweł Świątkowski"]
  spec.email         = ["inquebrantable@gmail.com"]

  spec.summary       = %q{Support for Shrine gem in Hanami framework}
  spec.description   = %q{Support for Shrine gem in Hanami framework}
  spec.homepage      = "http://github.com/katafrakt/hanami-shrine"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'shrine'
  spec.add_dependency 'hanami-model', '>= 1.0'
  spec.add_dependency "hanami-utils", '>= 1.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "json"
end
