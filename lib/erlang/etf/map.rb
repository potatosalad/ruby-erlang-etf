module Erlang
  module ETF

    #
    # 1   | 4    | N    | N
    # --- | ---- | ---- | ------
    # 116 | Size | Keys | Values
    #
    # The Size specifies the number of keys and values that
    # follows the size descriptor.
    #
    # (see [`MAP_EXT`])
    #
    # [`MAP_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#MAP_EXT
    #
    class Map
      include Term

      uint8 :tag, always: Terms::MAP_EXT 

      uint32be :size, always: -> { elements.size/2 }

      term :elements, type: :array

      deserialize do |buffer|
        size, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
        self.elements = []

        (size*2).times do
          self.elements << Terms.deserialize(buffer)
        end
      end

      finalize

      def initialize(elements)
        @elements = elements
      end

      
      def __ruby_evolve__
        ::Erlang::Map[*elements.map(&:__ruby_evolve__)]
      end
    end
  end
end