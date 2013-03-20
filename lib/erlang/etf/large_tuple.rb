module Erlang
  module ETF

    #
    # 1   | 4     | N
    # --- | ----- | --------
    # 105 | Arity | Elements
    #
    # Same as [`SMALL_TUPLE_EXT`] with the exception that `Arity` is an
    # unsigned 4 byte integer in big endian format.
    #
    # (see [`LARGE_TUPLE_EXT`])
    #
    # [`SMALL_TUPLE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_TUPLE_EXT
    # [`LARGE_TUPLE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#LARGE_TUPLE_EXT
    #
    class LargeTuple
      include Term

      uint8 :tag, always: Terms::LARGE_TUPLE_EXT

      uint32be :arity, always: -> { elements.size }

      term :elements, type: :array

      deserialize do |buffer|
        arity, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
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