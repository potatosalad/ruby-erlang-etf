module Erlang
  module ETF

    #
    # | 1   | 4      |          |      |
    # | --- | ------ | -------- | ---- |
    # | 108 | Length | Elements | Tail |
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
      include Erlang::ETF::Term

      UINT32BE = Erlang::ETF::Term::UINT32BE

      class << self
        def [](term, elements = nil, tail = nil)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term, elements, tail)
        end

        def erlang_load(buffer)
          length, = buffer.read(4).unpack(UINT32BE)
          elements = Array.new(length)
          length.times { |i| elements[i] = Erlang::ETF.read_term(buffer) }
          tail = Erlang::ETF.read_term(buffer)
          return tail if length == 0
          list = Erlang::List.from_enum(elements) + tail
          return new(list, elements, tail)
        end
      end

      def initialize(term, elements = nil, tail = nil)
        raise ArgumentError, "term must be of any type" if not Erlang.is_any(term)
        @term = term
        @elements = elements.freeze
        @tail = tail.freeze
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << LIST_EXT
        elements = nil
        tail = nil
        if not Erlang.is_list(term)
          elements = @elements || []
          tail = @tail || @term
        else
          elements = @elements || (@term.improper? ? @term.to_proper_list : @term)
          tail = @tail || (@term.improper? ? @term.last(true) : Erlang::Nil)
        end
        length = elements.size
        buffer << [length].pack(UINT32BE)
        elements.each { |element| Erlang::ETF.write_term(element, buffer) }
        Erlang::ETF.write_term(tail, buffer)
        return buffer
      end

      def inspect
        if @elements.nil? and @tail.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@elements.inspect}, #{@tail.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@elements, @tail) if not @elements.nil? or not @tail.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
