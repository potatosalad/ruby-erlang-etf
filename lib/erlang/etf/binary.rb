module Erlang
  module ETF

    #
    # 1   | 4   | Len
    # --- | --- | ----
    # 109 | Len | Data
    #
    # Binaries are generated with bit syntax expression or with
    # [`list_to_binary/1`], [`term_to_binary/1`], or as input from
    # binary ports.
    #
    # The `Len` length field is an unsigned 4 byte integer (big endian).
    #
    # (see [`BINARY_EXT`])
    #
    # [`list_to_binary/1`]: http://erlang.org/doc/man/erlang.html#list_to_binary-1
    # [`term_to_binary/1`]: http://erlang.org/doc/man/erlang.html#term_to_binary-1
    # [`BINARY_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#BINARY_EXT
    #
    class Binary
      include Term

      uint8 :tag, always: Terms::BINARY_EXT

      uint32be :len, default: 0 do
        string :data
      end

      undef deserialize_data
      def deserialize_data(buffer)
        self.data = buffer.read(len).from_utf8_binary
      end

      undef serialize_data
      def serialize_data(buffer)
        buffer << data.to_utf8_binary
      end

      finalize

      def initialize(data)
        @data = data
      end

      def __ruby_evolve__
        data
      end
    end
  end
end