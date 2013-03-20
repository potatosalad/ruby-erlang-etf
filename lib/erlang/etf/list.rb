module Erlang
  module ETF

    #
    # 1   | 4   | Len      | N1
    # --- | --- | -------- | ----
    # 108 | Len | Elements | Tail
    #
    # `Length` is the number of elements that follows in the `Elements`
    # section. `Tail` is the final tail of the list; it is [`NIL_EXT`] for a
    # proper list, but may be anything type if the list is improper
    # (for instance `[a|b]`).
    #
    # (see [`LIST_EXT`])
    #
    # [`NIL_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NIL_EXT
    # [`LIST_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#LIST_EXT
    #
    class List
      include Term

      uint8 :tag, always: Terms::LIST_EXT

      uint32be :len, always: -> { elements.size }

      term :elements, type: :array, allow_char: true
      term :tail

      deserialize do |buffer|
        len, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
        self.elements = []
        len.times do
          self.elements << Terms.deserialize(buffer)
        end
        deserialize_tail(buffer)
        self
      end

      finalize

      def initialize(elements, tail = Nil.new)
        @elements = elements
        @tail     = tail
      end

      def improper?
        tail.class != ETF::Nil
      end

      def __ruby_evolve__
        ::Erlang::List[*elements.map(&:__ruby_evolve__)].tail(tail.__ruby_evolve__)
      end
    end
  end
end