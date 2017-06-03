module Erlang
  module ETF

    #
    # | 1   | 1   | Len      |
    # | --- | --- | -------- |
    # | 115 | Len | AtomName |
    #
    # An atom is stored with a 1 byte unsigned length, followed by `Len`
    # numbers of 8 bit Latin1 characters that forms the `AtomName`.
    # Longer atoms can be represented by [`ATOM_EXT`].
    #
    # **Note** the [`SMALL_ATOM_EXT`] was introduced in erts version 5.7.2 and
    # require an exchange of the [`DFLAG_SMALL_ATOM_TAGS`] distribution
    # flag in the [distribution handshake].
    #
    # (see [`SMALL_ATOM_EXT`])
    #
    # [`ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_EXT
    # [`DFLAG_SMALL_ATOM_TAGS`]: http://erlang.org/doc/apps/erts/erl_dist_protocol.html#dflags
    # [distribution handshake]: http://erlang.org/doc/apps/erts/erl_dist_protocol.html#distribution_handshake
    # [`SMALL_ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_ATOM_EXT
    #
    class SmallAtom
      include Erlang::ETF::Term

      UINT8 = Erlang::ETF::Term::UINT8

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Atom)
          return term if term.kind_of?(Erlang::ETF::AtomUTF8)
          return term if term.kind_of?(Erlang::ETF::SmallAtom)
          return term if term.kind_of?(Erlang::ETF::SmallAtomUTF8)
          term = Erlang.from(term) if not term.kind_of?(Erlang::Atom)
          return new(term)
        end

        def erlang_load(buffer)
          size, = buffer.read(1).unpack(UINT8)
          data = buffer.read(size)
          return new(Erlang::Atom[data])
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Atom" if not term.kind_of?(Erlang::Atom)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << SMALL_ATOM_EXT
        buffer << [@term.size].pack(UINT8)
        buffer << Erlang::Terms.binary_encoding(@term.data)
        return buffer
      end
    end
  end
end
