module Erlang
  module ETF

    #
    # | 1   | 4   |
    # | --- | --- |
    # | 98  | Int |
    #
    # Signed 32 bit integer in big-endian format (i.e. MSB first)
    #
    # (see [`INTEGER_EXT`])
    #
    # [`INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#INTEGER_EXT
    #
    class Integer
      include Erlang::ETF::Term

      INT32BE = Erlang::ETF::Term::INT32BE

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term)
        end

        def erlang_load(buffer)
          integer, = buffer.read(4).unpack(INT32BE)
          return new(integer)
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Integer" if not Erlang.is_integer(term)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << INTEGER_EXT
        buffer << [@term].pack(INT32BE)
        return buffer
      end
    end
  end
end
