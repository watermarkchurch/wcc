# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcc/version'

Gem::Specification.new do |spec|
  spec.name          = "wcc"
  spec.version       = WCC::VERSION
  spec.authors       = ["Travis Petticrew"]
  spec.email         = ["tpetticrew@watermark.org"]
  spec.description   = %q{Repository for common WCC code}
  spec.summary       = File.readlines("README.md").join
  spec.homepage      = ""
  spec.license       = "Proprietary"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
