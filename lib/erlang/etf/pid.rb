module Erlang
  module ETF

    #
    # 1   | N    | 4  | 4      | 1
    # --- | ---- | -- | ------ | --------
    # 103 | Node | ID | Serial | Creation
    #
    # Encode a process identifier object (obtained from spawn/3 or
    # friends). The ID and Creation fields works just like in
    # REFERENCE_EXT, while the Serial field is used to improve safety.
    # In ID, only 15 bits are significant; the rest should be 0.
    #
    class Pid
      include Term

      uint8 :tag, always: Terms::PID_EXT

      term :node

      uint32be :id,     maximum: (1 << 15) - 1
      uint32be :serial, maximum: (1 << 13) - 1

      int8 :creation, maximum: (1 << 2) - 1

      finalize

      def initialize(node, id, serial, creation)
        @node     = node
        @id       = id
        @serial   = serial
        @creation = creation
      end

      def __ruby_evolve__
        ::Erlang::Pid.new(
          node.__ruby_evolve__,
          id,
          serial,
          creation
        )
      end
    end
  end
end