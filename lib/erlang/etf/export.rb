module Erlang
  module ETF

    #
    # 1   | N1     | N2       | N3
    # --- | ------ | -------- | -----
    # 113 | Module | Function | Arity
    #
    # This term is the encoding for external funs: fun M:F/A.
    #
    # Module and Function are atoms (encoded using ATOM_EXT,
    # SMALL_ATOM_EXT or ATOM_CACHE_REF).
    #
    # Arity is an integer encoded using SMALL_INTEGER_EXT.
    #
    class Export
      include Term

      uint8 :tag, always: Terms::EXPORT_EXT

      term :mod # atom, small_atom

      term :function # atom, small_atom

      term :arity # small_integer

      finalize

      def initialize(mod, function, arity)
        self.mod      = mod
        self.function = function
        self.arity    = arity
      end

      def __ruby_evolve__
        ::Erlang::Export.new(
          mod.__ruby_evolve__,
          function.__ruby_evolve__,
          arity.__ruby_evolve__
        )
      end
    end
  end
end