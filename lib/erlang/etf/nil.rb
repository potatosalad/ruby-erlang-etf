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
      include Term

      uint8 :tag, always: Terms::NIL_EXT

      finalize

      def __ruby_evolve__
        []
      end
    end
  end
end