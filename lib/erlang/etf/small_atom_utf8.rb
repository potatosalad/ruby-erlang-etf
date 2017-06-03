module Erlang
  module ETF

    #
    # | 1   | 1   | Len      |
    # | --- | --- | -------- |
    # | 119 | Len | AtomName |
    #
    # An atom is stored with a 1 byte unsigned length, followed by `Len`
    # bytes containing the `AtomName` encoded in UTF-8. Longer atoms
    # encoded in UTF-8 can be represented using [`ATOM_UTF8_EXT`].
    #
    # (see [`SMALL_ATOM_UTF8_EXT`])
    #
    # [`ATOM_UTF8_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_UTF8_EXT
    # [`SMALL_ATOM_UTF8_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_ATOM_UTF8_EXT
    #
    class SmallAtomUTF8
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
          return new(Erlang::Atom[data, utf8: true])
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Atom" if not term.kind_of?(Erlang::Atom)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << SMALL_ATOM_UTF8_EXT
        buffer << [@term.size].pack(UINT8)
        buffer << Erlang::Terms.binary_encoding(@term.data)
        return buffer
      end
    end
  end
end
