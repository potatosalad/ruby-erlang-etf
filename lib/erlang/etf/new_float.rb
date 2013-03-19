require 'bigdecimal'

module Erlang
  module ETF

    #
    # 1  | 8
    # -- | ----------
    # 70 | IEEE Float
    #
    # A float is stored as 8 bytes in big-endian IEEE format.
    #
    # This term is used in minor version 1 of the external format.
    #
    class NewFloat
      include Term

      uint8 :tag, always: Terms::NEW_FLOAT_EXT

      doublebe :float

      finalize

      def initialize(float)
        @float = float
      end

      def __ruby_evolve__
        float
      end
    end
  end
end