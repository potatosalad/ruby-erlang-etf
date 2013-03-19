require "binary/protocol"
require "erlang/terms"

require "erlang/etf/version"
require "erlang/etf/extensions"
require "erlang/etf/terms"

module Erlang
  module ETF

    extend self

    ERLANG_MAGIC_BYTE = 131.chr.freeze

    def encode(term, buffer = "")
      buffer << ERLANG_MAGIC_BYTE
      term.__erlang_dump__(buffer)
    end

    def decode(buffer)
      magic = buffer.read(1)
      if magic == ERLANG_MAGIC_BYTE
        Terms.evolve(buffer)
      else
        raise NotImplementedError, "unknown Erlang magic byte #{magic.inspect} (should be #{ERLANG_MAGIC_BYTE.inspect})"
      end
    end

  end

  def self.binary_to_term(binary)
    buffer = binary.respond_to?(:read) ? binary : StringIO.new(binary)
    ETF.decode(buffer)
  end

  def self.term_to_binary(term, buffer = "")
    ETF.encode(term, buffer)
  end

end