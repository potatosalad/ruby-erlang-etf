module Erlang
  module ETF

    #
    # | 1   | 2   | Len      |
    # | --- | --- | -------- |
    # | 100 | Len | AtomName |
    #
    # An atom is stored with a 2 byte unsigned length in big-endian
    # order, followed by `Len` numbers of 8 bit Latin1 characters that
    # forms the `AtomName`.
    #
    # **Note:** The maximum allowed value for `Len` is 255.
    #
    # (see [`ATOM_EXT`])
    #
    # [`ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_EXT
    #
    class Atom
      include Erlang::ETF::Term

      UINT16BE = Erlang::ETF::Term::UINT16BE

      class << self
        def [](term)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term) if not term.kind_of?(Erlang::Atom)
          return new(term)
        end

        def erlang_load(buffer)
          size, = buffer.read(2).unpack(UINT16BE)
          data = buffer.read(size)
          return new(Erlang::Atom[data])
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Atom" if not term.kind_of?(Erlang::Atom)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << ATOM_EXT
        buffer << [@term.size].pack(UINT16BE)
        buffer << Erlang::ETF::Term.binary_encoding(@term.data)
        return buffer
      end
    end
  end
end
