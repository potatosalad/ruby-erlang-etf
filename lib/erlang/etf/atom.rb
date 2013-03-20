module Erlang
  module ETF

    #
    # 1   | 2   | Len
    # --- | --- | --------
    # 100 | Len | AtomName
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
      include Term

      uint8 :tag, always: Terms::ATOM_EXT

      uint16be :len, default: 0 do
        string :atom_name
      end

      undef deserialize_atom_name
      # @private
      def deserialize_atom_name(buffer)
        self.atom_name = buffer.read(len).from_utf8_binary
      end

      undef serialize_atom_name
      # @private
      def serialize_atom_name(buffer)
        buffer << atom_name.to_utf8_binary
      end

      finalize

      # Instantiate the new atom.
      #
      # @example Instantiate the atom.
      #   Erlang::ETF::Atom.new("test")
      #   # => #<Erlang::ETF::Atom @tag=100 @len=4 @atom_name="test">
      #
      # @param [ ::String ] atom_name The `AtomName` as a string.
      #
      # @since 1.0.0
      def initialize(atom_name)
        @atom_name = atom_name
        @len = atom_name.to_s.bytesize
      end

      # Evolve to native ruby.
      #
      # @example Evolve to native ruby.
      #   atom = Erlang::ETF::Atom.new("test")
      #   atom.__ruby_evolve__
      #   # => :test
      #
      # @return [ ::Symbol ] The `AtomName` as a symbol.
      #
      # @since 1.0.0
      def __ruby_evolve__
        atom_name.intern
      end
    end
  end
end