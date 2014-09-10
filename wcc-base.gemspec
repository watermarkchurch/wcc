# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcc/version'

Gem::Specification.new do |spec|
  spec.name          = "wcc-base"
  spec.version       = WCC::VERSION
  spec.authors       = ["Watermark Community Church"]
  spec.email         = ["dev@watermark.org"]
  spec.description   = %q{Repository for generic common code in Watermark Community Church applications}
  spec.summary       = File.readlines("README.md").join
  spec.homepage      = "https://github.com/watermarkchurch/wcc"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
