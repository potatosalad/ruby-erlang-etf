module Erlang
  module ETF

    #
    # 1   | 4     | N
    # --- | ----- | -----
    # 116 | Arity | Pairs
    #
    # The Size specifies the number of key-values Pairs that
    # follows the size descriptor.
    #
    # (see [`MAP_EXT`])
    #
    # [`MAP_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#MAP_EXT
    #
    class Map
      include Term

      uint8 :tag, always: Terms::MAP_EXT

      uint32be :size, always: -> { keys.size }

      term :keys,   type: :array
      term :values, type: :array

      deserialize do |buffer|
        size, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
        self.keys, self.values = [], []
        size.times do
          self.keys   << Terms.deserialize(buffer)
          self.values << Terms.deserialize(buffer)
        end
        self
      end

      finalize

      def initialize(keys, values)
        @keys   = keys
        @values = values
      end

      def __ruby_evolve__
        ::Erlang::Map[keys.map(&:__ruby_evolve__).zip(values.map(&:__ruby_evolve__))]
      end
    end
  end
end