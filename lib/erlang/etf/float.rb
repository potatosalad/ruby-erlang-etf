require 'bigdecimal'

module Erlang
  module ETF

    #
    # 1   | 31
    # --- | ------------
    # 99  | Float String
    #
    # A float is stored in string format. the format used in sprintf
    # to format the float is "%.20e" (there are more bytes allocated
    # than necessary). To unpack the float use sscanf with format
    # "%lf".
    #
    # This term is used in minor version 0 of the external format; it
    # has been superseded by [`NEW_FLOAT_EXT`].
    #
    # (see [`FLOAT_EXT`])
    #
    # [`NEW_FLOAT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NEW_FLOAT_EXT
    # [`FLOAT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#FLOAT_EXT
    #
    class Float
      include Term

      FLOAT_STRING_FORMAT = "%.20e".freeze

      uint8 :tag, always: Terms::FLOAT_EXT

      string :float_string

      undef serialize_float_string
      def serialize_float_string(buffer)
        if float_string.is_a?(::BigDecimal)
          buffer << (FLOAT_STRING_FORMAT % float_string).ljust(31, "\000")
        else
          buffer << float_string
        end
      end

      undef deserialize_float_string
      def deserialize_float_string(buffer)
        self.float_string = buffer.read(31)
      end

      finalize

      def initialize(float_string)
        @float_string = float_string
      end

      def __ruby_evolve__
        if float_string.is_a?(::BigDecimal)
          float_string
        else
          ::BigDecimal.new(float_string.gsub("\000", ""))
        end
      end
    end
  end
end