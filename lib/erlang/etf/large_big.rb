module Erlang
  module ETF

    #
    # | 1   | 4   | 1    | n               |
    # | --- | --- | ---- | --------------- |
    # | 111 | n   | Sign | d(0) ... d(n-1) |
    #
    # Same as [`SMALL_BIG_EXT`] with the difference that the length
    # field is an unsigned 4 byte integer.
    #
    # (see [`LARGE_BIG_EXT`])
    #
    # [`SMALL_BIG_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_BIG_EXT
    # [`LARGE_BIG_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#LARGE_BIG_EXT
    #
    class LargeBig
      include Erlang::ETF::Term

      UINT8    = Erlang::ETF::Term::UINT8
      UINT32BE = Erlang::ETF::Term::UINT32BE
      HEAD     = (UINT32BE + UINT8).freeze

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term)
        end

        def erlang_load(buffer)
          n, sign, = buffer.read(5).unpack(HEAD)
          integer = Erlang::Binary.decode_unsigned(buffer.read(n), :little)
          integer = -integer if sign == 1
          return new(integer)
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Integer" if not Erlang.is_integer(term)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << LARGE_BIG_EXT
        buffer << [Erlang::ETF.intlog2div8(@term), (@term < 0) ? 1 : 0].pack(HEAD)
        buffer << Erlang::Binary.encode_unsigned(@term.abs, :little)
        return buffer
      end
    end
  end
end
