# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rasp/version'

Gem::Specification.new do |spec|
  spec.name          = "rasp"
  spec.version       = Rasp::VERSION
  spec.authors       = ["Robert Schäfer"]
  spec.email         = ["robert.schaefer@student.hpi.de"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Logic programming in ruby with ASP}
  spec.description   = %q{Provides an API to describe problems in ruby. Generates ASP encodings. Uses the potassco suite to solve them.}
  spec.homepage      = "https://github.com/roschaefer/rasp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rspec-collection_matchers"
end
