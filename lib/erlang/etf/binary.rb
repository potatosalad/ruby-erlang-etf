module Erlang
  module ETF

    #
    # | 1   | 4   | Len  |
    # | --- | --- | ---- |
    # | 109 | Len | Data |
    #
    # Binaries are generated with bit syntax expression or with
    # [`list_to_binary/1`], [`term_to_binary/1`], or as input from
    # binary ports.
    #
    # The `Len` length field is an unsigned 4 byte integer (big endian).
    #
    # (see [`BINARY_EXT`])
    #
    # [`list_to_binary/1`]: http://erlang.org/doc/man/erlang.html#list_to_binary-1
    # [`term_to_binary/1`]: http://erlang.org/doc/man/erlang.html#term_to_binary-1
    # [`BINARY_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#BINARY_EXT
    #
    class Binary
      include Erlang::ETF::Term

      UINT32BE = Erlang::ETF::Term::UINT32BE

      class << self
        def [](term)
          term = Erlang.from(term) if not term.kind_of?(Erlang::Binary)
          return new(term)
        end

        def erlang_load(buffer)
          size, = buffer.read(4).unpack(UINT32BE)
          data = buffer.read(size)
          return new(Erlang::Binary[data])
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Binary" if not term.kind_of?(Erlang::Binary)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << BINARY_EXT
        buffer << [@term.bytesize].pack(UINT32BE)
        buffer << Erlang::ETF::Term.binary_encoding(@term.data)
        return buffer
      end
    end
  end
end
