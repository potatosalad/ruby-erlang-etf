module Erlang
  module ETF

    #
    # | 1   |
    # | --- |
    # | 106 |
    #
    # The representation for an empty list, i.e. the Erlang syntax `[]`.
    #
    # (see [`NIL_EXT`])
    #
    # [`NIL_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NIL_EXT
    #
    class Nil
      include Erlang::ETF::Term

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term)
        end

        def erlang_load(buffer)
          term = Erlang::Nil
          return new(term)
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Nil" if not Erlang::Nil.equal?(term)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << NIL_EXT
        return buffer
      end
    end
  end
end
