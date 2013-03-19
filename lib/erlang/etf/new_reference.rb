module Erlang
  module ETF

    #
    # 1   | 2   | N    | 1        | N'
    # --- | --- | ---- | -------- | ------
    # 114 | Len | Node | Creation | ID ...
    #
    # Node and Creation are as in REFERENCE_EXT.
    #
    # ID contains a sequence of big-endian unsigned integers (4 bytes
    # each, so N' is a multiple of 4), but should be regarded as
    # uninterpreted data.
    #
    # N' = 4 * Len.
    #
    # In the first word (four bytes) of ID, only 18 bits are
    # significant, the rest should be 0. In Creation, only 2 bits are
    # significant, the rest should be 0.
    #
    # NEW_REFERENCE_EXT was introduced with distribution version 4. In
    # version 4, N' should be at most 12.
    #
    # See REFERENCE_EXT).
    #
    class NewReference
      include Term

      uint8 :tag, always: Terms::NEW_REFERENCE_EXT

      uint16be :len, always: -> { ids.size }

      term :node

      int8 :creation, maximum: (1 << 2) - 1

      uint32be :ids, type: :array, default: []

      deserialize do |buffer|
        len, = buffer.read(BYTES_16).unpack(UINT16BE_PACK)
        deserialize_node(buffer)
        deserialize_creation(buffer)
        self.ids = []
        len.times do
          self.ids << buffer.read(BYTES_32).unpack(UINT32BE_PACK).at(0)
        end
        self
      end

      finalize

      def initialize(node, creation, ids = [])
        @node     = node
        @creation = creation
        @ids      = ids
      end
    end
  end
end