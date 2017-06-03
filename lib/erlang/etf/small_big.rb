module Erlang
  module ETF

    #
    # | 1   | 1   | 1    | n               |
    # | --- | --- | ---- | --------------- |
    # | 110 | n   | Sign | d(0) ... d(n-1) |
    #
    # Bignums are stored in unary form with a `Sign` byte that is 0 if
    # the binum is positive and 1 if is negative. The digits are
    # stored with the LSB byte stored first.
    #
    # To calculate the integer the following formula can be used:
    #
    # ```
    # B = 256
    # (d0*B^0 + d1*B^1 + d2*B^2 + ... d(N-1)*B^(n-1))
    # ```
    #
    # (see [`SMALL_BIG_EXT`])
    #
    # [`SMALL_BIG_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_BIG_EXT
    #
    class SmallBig
      include Erlang::ETF::Term

      UINT8 = Erlang::ETF::Term::UINT8
      HEAD  = (UINT8 + UINT8).freeze

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term)
        end

        def erlang_load(buffer)
          n, sign, = buffer.read(2).unpack(HEAD)
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
        buffer << SMALL_BIG_EXT
        buffer << [Erlang::ETF.intlog2div8(@term), (@term < 0) ? 1 : 0].pack(HEAD)
        buffer << Erlang::Binary.encode_unsigned(@term.abs, :little)
        return buffer
      end
    end
  end
end
