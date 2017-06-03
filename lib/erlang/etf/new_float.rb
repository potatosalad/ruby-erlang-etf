module Erlang
  module ETF

    #
    # | 1   | 8          |
    # | --- | ---------- |
    # | 70  | IEEE Float |
    #
    # A float is stored as 8 bytes in big-endian IEEE format.
    #
    # This term is used in minor version 1 of the external format.
    #
    # (see [`NEW_FLOAT_EXT`])
    #
    # [`NEW_FLOAT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NEW_FLOAT_EXT
    #
    class NewFloat
      include Erlang::ETF::Term

      DOUBLEBE = Erlang::ETF::Term::DOUBLEBE

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term)
        end

        def erlang_load(buffer)
          float, = buffer.read(8).unpack(DOUBLEBE)
          term = Erlang::Float[float]
          return new(term)
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Float" if not Erlang.is_float(term) or term.old
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << NEW_FLOAT_EXT
        buffer << [@term.data].pack(DOUBLEBE)
        return buffer
      end
    end
  end
end
