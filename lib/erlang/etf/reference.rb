module Erlang
  module ETF

    #
    # | 1   | N    | 4   | 1        |
    # | --- | ---- | --- | -------- |
    # | 101 | Node | ID  | Creation |
    #
    # Encode a reference object (an object generated with [`make_ref/0`]).
    # The `Node` term is an encoded atom, i.e. [`ATOM_EXT`], [`SMALL_ATOM_EXT`]
    # or [`ATOM_CACHE_REF`]. The `ID` field contains a big-endian unsigned
    # integer, but should be regarded as uninterpreted data since this
    # field is node specific. `Creation` is a byte containing a node
    # serial number that makes it possible to separate old (crashed)
    # nodes from a new one.
    #
    # In `ID`, only 18 bits are significant; the rest should be 0.
    # In `Creation`, only 2 bits are significant; the rest should be 0.
    # See [`NEW_REFERENCE_EXT`].
    #
    # (see [`REFERENCE_EXT`])
    #
    # [`make_ref/0`]: http://erlang.org/doc/man/erlang.html#make_ref-0
    # [`ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_EXT
    # [`SMALL_ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_ATOM_EXT
    # [`ATOM_CACHE_REF`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_CACHE_REF
    # [`NEW_REFERENCE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NEW_REFERENCE_EXT
    # [`REFERENCE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#REFERENCE_EXT
    #
    class Reference
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
          term = Erlang::Reference[Erlang.from(node), Erlang.from(creation), Erlang.from(id)]
          return new(term, node, id, creation)
        end
      end

      def initialize(term, node = nil, id = nil, creation = nil)
        raise ArgumentError, "term must be of type Erlang::Reference" if not term.kind_of?(Erlang::Reference) or term.new_reference?
        @term     = term
        @node     = node
        @id       = id
        @creation = creation
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << REFERENCE_EXT
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
