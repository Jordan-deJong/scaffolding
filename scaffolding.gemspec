# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scaffolding/version'

Gem::Specification.new do |spec|
  spec.name          = "scaffolding"
  spec.version       = Scaffolding::VERSION
  spec.authors       = ["Jordan-deJong"]
  spec.email         = ["jordan.dejong@me.com"]

  spec.summary       = %q{Generate a rails scaffold based on a .CSV, .dat or .txt file.}
  spec.homepage      = "https://github.com/Jordan-deJong/scaffolding"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec"
end
