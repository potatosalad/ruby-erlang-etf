module Erlang
  module ETF

    #
    # | 1   | N    | 4   | 1        |
    # | --- | ---- | --- | -------- |
    # | 102 | Node | ID  | Creation |
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
      include Erlang::ETF::Term

      UINT8    = Erlang::ETF::Term::UINT8
      UINT32BE = Erlang::ETF::Term::UINT32BE
      HEAD     = (UINT32BE + UINT8).freeze

      class << self
        def [](term, node = nil, id = nil, creation = nil)
          return new(term, node, id, creation)
        end

        def erlang_load(buffer)
          node = Erlang::ETF.read_term(buffer)
          id, creation = buffer.read(5).unpack(HEAD)
          term = Erlang::Port[Erlang.from(node), Erlang.from(id), Erlang.from(creation)]
          return new(term, node, id, creation)
        end
      end

      def initialize(term, node = nil, id = nil, creation = nil)
        raise ArgumentError, "term must be of type Erlang::Port" if not term.kind_of?(Erlang::Port)
        @term     = term
        @node     = node
        @id       = id
        @creation = creation
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << PORT_EXT
        Erlang::ETF.write_term(@node || @term.node, buffer)
        buffer << [
          @id       || @term.id,
          @creation || @term.creation
        ].pack(HEAD)
        return buffer
      end

      def inspect
        if @node.nil? and @id.nil? and @creation.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@node.inspect}, #{@id.inspect}, #{@creation.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@node, @id, @creation) if not @node.nil? or not @id.nil? or not @creation.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
