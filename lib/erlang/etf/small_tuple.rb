module Erlang
  module ETF

    #
    # | 1   | 1     | N        |
    # | --- | ----- | -------- |
    # | 104 | Arity | Elements |
    #
    # [`SMALL_TUPLE_EXT`] encodes a tuple. The `Arity` field is an unsigned
    # byte that determines how many element that follows in the
    # `Elements` section.
    #
    # (see [`SMALL_TUPLE_EXT`])
    #
    # [`SMALL_TUPLE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_TUPLE_EXT
    #
    class SmallTuple
      include Erlang::ETF::Term

      UINT8 = Erlang::ETF::Term::UINT8

      class << self
        def [](term, elements = nil)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term, elements)
        end

        def erlang_load(buffer)
          arity, = buffer.read(1).unpack(UINT8)
          elements = Array.new(arity)
          arity.times { |i| elements[i] = Erlang::ETF.read_term(buffer) }
          tuple = Erlang::Tuple[*elements]
          return new(tuple, elements)
        end
      end

      def initialize(term, elements = nil)
        raise ArgumentError, "term must be of type Tuple" if not Erlang.is_tuple(term)
        @term = term
        @elements = elements.freeze
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << SMALL_TUPLE_EXT
        elements = @elements || @term
        arity = elements.size
        buffer << [arity].pack(UINT8)
        elements.each { |element| Erlang::ETF.write_term(element, buffer) }
        return buffer
      end

      def inspect
        if @elements.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@elements.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@elements) if not @elements.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
