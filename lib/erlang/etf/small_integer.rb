module Erlang
  module ETF

    #
    # 1   | 1
    # --- | ---
    # 97  | Int
    #
    # Unsigned 8 bit integer.
    #
    # (see [`SMALL_INTEGER_EXT`])
    #
    # [`SMALL_INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_INTEGER_EXT
    #
    class SmallInteger
      include Term

      uint8 :tag, always: Terms::SMALL_INTEGER_EXT

      uint8 :int

      finalize

      def initialize(int)
        @int = int
      end

      def __ruby_evolve__
        int
      end
    end
  end
end