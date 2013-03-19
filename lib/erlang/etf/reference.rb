module Erlang
  module ETF

    #
    # 1   | N    | 4  | 1
    # --- | ---- | -- | --------
    # 101 | Node | ID | Creation
    #
    # Encode a reference object (an object generated with make_ref/0).
    # The Node term is an encoded atom, i.e. ATOM_EXT, SMALL_ATOM_EXT
    # or ATOM_CACHE_REF. The ID field contains a big-endian unsigned
    # integer, but should be regarded as uninterpreted data since this
    # field is node specific. Creation is a byte containing a node
    # serial number that makes it possible to separate old (crashed)
    # nodes from a new one.
    #
    # In ID, only 18 bits are significant; the rest should be 0.
    # In Creation, only 2 bits are significant; the rest should be 0.
    # See NEW_REFERENCE_EXT.
    #
    class Reference
      include Term

      uint8 :tag, always: Terms::REFERENCE_EXT

      term :node

      uint32be :id, maximum: (1 << 18) - 1

      int8 :creation, maximum: (1 << 2) - 1

      finalize

      def initialize(node, id, creation)
        @node     = node
        @id       = id
        @creation = creation
      end
    end
  end
end