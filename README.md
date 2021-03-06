# Erlang::ETF

[![Travis](https://img.shields.io/travis/potatosalad/ruby-erlang-etf.svg?maxAge=86400)](https://travis-ci.org/potatosalad/ruby-erlang-etf) [![Coverage Status](https://coveralls.io/repos/github/potatosalad/ruby-erlang-etf/badge.svg?branch=master)](https://coveralls.io/github/potatosalad/ruby-erlang-etf?branch=master) [![Gem](https://img.shields.io/gem/v/erlang-etf.svg?maxAge=86400)](https://rubygems.org/gems/erlang-etf) [![Docs](https://img.shields.io/badge/yard-docs-blue.svg?maxAge=86400)](http://www.rubydoc.info/gems/erlang-etf) [![Inline docs](http://inch-ci.org/github/potatosalad/ruby-erlang-etf.svg?branch=master&style=shields)](http://inch-ci.org/github/potatosalad/ruby-erlang-etf)

Erlang [External Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html) (ETF) for Ruby.

*Note:* Please see the [erlang-terms](https://github.com/potatosalad/ruby-erlang-terms) gem for more information about the Erlang-to-Ruby type mappings (for example, `Erlang::Pid`).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'erlang-etf', '~> 2.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install erlang-etf

## Usage

### `Erlang.term_to_binary(term)`

```ruby
Erlang.term_to_binary(:atom)
# => "\x83s\x04atom"
```

Compression is optional and valid arguments are `false`, `true`, and integers `0-9`.

```ruby
Erlang.term_to_binary([1] * 100, compressed: true)
# => "\x83P\x00\x00\x00\xCEx\x9C\xCBa``HId\x1C\x1E0\v\x00\xE85'\x83"
```

### `Erlang.binary_to_term(binary)`

```ruby
Erlang.binary_to_term("\x83s\x04atom")
# => :atom
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/potatosalad/ruby-erlang-etf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
