module Erlang
  module ETF

    #
    # 1   | 1   | Len
    # --- | --- | --------
    # 115 | Len | AtomName
    #
    # An atom is stored with a 1 byte unsigned length, followed by Len
    # numbers of 8 bit Latin1 characters that forms the AtomName.
    # Longer atoms can be represented by ATOM_EXT.
    #
    # Note the SMALL_ATOM_EXT was introduced in erts version 5.7.2 and
    # require an exchange of the DFLAG_SMALL_ATOM_TAGS distribution
    # flag in the distribution handshake.
    #
    class SmallAtom
      include Term

      uint8 :tag, always: Terms::SMALL_ATOM_EXT

      uint8 :len, default: 0 do
        string :atom_name
      end

      undef deserialize_atom_name
      def deserialize_atom_name(buffer)
        self.atom_name = buffer.read(len).from_utf8_binary
      end

      undef serialize_atom_name
      def serialize_atom_name(buffer)
        buffer << atom_name.to_utf8_binary
      end

      finalize

      def initialize(atom_name)
        @atom_name = atom_name
        @len = atom_name.to_s.bytesize
      end

      def __ruby_evolve__
        atom_name.intern
      end
    end
  end
end