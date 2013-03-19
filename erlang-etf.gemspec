# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'erlang/etf/version'

Gem::Specification.new do |spec|
  spec.name          = "erlang-etf"
  spec.version       = Erlang::ETF::VERSION
  spec.authors       = ["Andrew Bennett"]
  spec.email         = ["andrew@delorum.com"]
  spec.description   = %q{Erlang External Term Format (ETF) for Ruby}
  spec.summary       = %q{Erlang External Term Format (ETF) for Ruby}
  spec.homepage      = "https://github.com/potatosalad/erlang-etf"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "binary-protocol"
  spec.add_dependency "erlang-terms"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
