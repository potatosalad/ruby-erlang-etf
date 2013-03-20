module Erlang
  module ETF

    #
    # 1   | N    | 4   | 1
    # --- | ---- | --- | --------
    # 102 | Node | ID  | Creation
    #
    # Encode a port object (obtained form [`open_port/2`]). The `ID` is a
    # node specific identifier for a local port. Port operations are
    # not allowed across node boundaries. The `Creation` works just like
    # in [`REFERENCE_EXT`].
    #
    # (see [`PORT_EXT`])
    #
    # [`open_port/2`]: http://erlang.org/doc/man/erlang.html#open_port-2
    # [`REFERENCE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#REFERENCE_EXT
    # [`PORT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#PORT_EXT
    #
    class Port
      include Term

      uint8 :tag, always: Terms::PORT_EXT

      term :node

      uint32be :id, maximum: (1 << 28) - 1

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