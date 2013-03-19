# Erlang::Etf

[![Build Status](https://travis-ci.org/potatosalad/erlang-etf.png)](https://travis-ci.org/potatosalad/erlang-etf)

Erlang [External Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html) (ETF) for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'erlang-etf', require: 'erlang/etf'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install erlang-etf
```

## Usage

### Erlang.term_to_binary(term)

```ruby
Erlang.term_to_binary(:atom)
# => "\x83s\x04atom"
```

### Erlang.binary_to_term(binary)

```ruby
Erlang.binary_to_term("\x83s\x04atom")
# => :atom
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
