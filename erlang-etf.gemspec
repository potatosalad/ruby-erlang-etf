# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'erlang/etf/version'

Gem::Specification.new do |spec|
  spec.name          = "erlang-etf"
  spec.version       = Erlang::ETF::VERSION
  spec.authors       = ["Andrew Bennett"]
  spec.email         = ["andrew@pixid.com"]

  spec.description   = %q{Erlang External Term Format (ETF) for Ruby}
  spec.summary       = %q{Erlang External Term Format (ETF) for Ruby}
  spec.homepage      = "https://github.com/potatosalad/ruby-erlang-etf"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "erlang-terms", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest"
end
