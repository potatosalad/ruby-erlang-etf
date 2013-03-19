module Erlang
  module ETF

    #
    # 1   | 1     | N
    # --- | ----- | --------
    # 104 | Arity | Elements
    #
    # SMALL_TUPLE_EXT encodes a tuple. The Arity field is an unsigned
    # byte that determines how many element that follows in the
    # Elements section.
    #
    class SmallTuple
      include Term

      uint8 :tag, always: Terms::SMALL_TUPLE_EXT

      uint8 :arity, always: -> { elements.size }

      term :elements, type: :array

      deserialize do |buffer|
        arity, = buffer.read(BYTES_8).unpack(UINT8_PACK)
        self.elements = []
        arity.times do
          self.elements << Terms.deserialize(buffer)
        end
        self
      end

      finalize

      def initialize(elements)
        @elements = elements
      end

      def serialize_header(buffer)
        serialize_tag(buffer)
        serialize_arity(buffer)
      end

      def bert?
        elements[0].respond_to?(:atom_name) &&
        elements[0].atom_name == BERT_PREFIX
      end

      def __ruby_evolve__
        if bert?
          ::Erlang::ETF::BERT.evolve(self)
        else
          ::Erlang::Tuple[*elements.map(&:__ruby_evolve__)]
        end
      end
    end
  end
end