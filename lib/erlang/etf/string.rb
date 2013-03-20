module Erlang
  module ETF

    #
    # 1   | 2   | Len
    # --- | --- | ----------
    # 107 | Len | Characters
    #
    # String does NOT have a corresponding Erlang representation, but
    # is an optimization for sending lists of bytes (integer in the
    # range 0-255) more efficiently over the distribution. Since the
    # Length field is an unsigned 2 byte integer (big endian),
    # implementations must make sure that lists longer than 65535
    # elements are encoded as [`LIST_EXT`].
    #
    # (see [`STRING_EXT`])
    #
    # [`LIST_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#LIST_EXT
    # [`STRING_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#STRING_EXT
    #
    class String
      include Term

      uint8 :tag, always: Terms::STRING_EXT

      uint16be :len, default: 0 do
        string :characters
      end

      undef deserialize_characters
      def deserialize_characters(buffer)
        self.characters = buffer.read(len).from_utf8_binary
      end

      undef serialize_characters
      def serialize_characters(buffer)
        buffer << characters.to_utf8_binary
      end

      finalize

      def initialize(characters)
        @characters = characters
      end

      def __ruby_evolve__
        ::Erlang::String.new(characters)
      end
    end
  end
end