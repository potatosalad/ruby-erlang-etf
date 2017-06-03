module Erlang
  module ETF

    #
    # | 1   | 1   |
    # | --- | --- |
    # | 97  | Int |
    #
    # Unsigned 8 bit integer.
    #
    # (see [`SMALL_INTEGER_EXT`])
    #
    # [`SMALL_INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_INTEGER_EXT
    #
    class SmallInteger
      include Erlang::ETF::Term

      UINT8 = Erlang::ETF::Term::UINT8

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Integer)
          return term if term.kind_of?(Erlang::ETF::LargeBig)
          return term if term.kind_of?(Erlang::ETF::SmallBig)
          return term if term.kind_of?(Erlang::ETF::SmallInteger)
          term = Erlang.from(term)
          return new(term)
        end

        def erlang_load(buffer)
          term, = buffer.read(1).unpack(UINT8)
          return new(Erlang.from(term))
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Integer" if not Erlang.is_integer(term)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << SMALL_INTEGER_EXT
        buffer << [@term].pack(UINT8)
        return buffer
      end
    end
  end
end
