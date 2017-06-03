module Erlang
  module ETF

    #
    # | 1   | N1     | N2       | N3    |
    # | --- | ------ | -------- | ----- |
    # | 113 | Module | Function | Arity |
    #
    # This term is the encoding for external funs: `fun M:F/A`.
    #
    # `Module` and `Function` are atoms (encoded using [`ATOM_EXT`],
    # [`SMALL_ATOM_EXT`] or [`ATOM_CACHE_REF`]).
    #
    # `Arity` is an integer encoded using [`SMALL_INTEGER_EXT`].
    #
    # (see [`EXPORT_EXT`])
    #
    # [`ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_EXT
    # [`SMALL_ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_ATOM_EXT
    # [`ATOM_CACHE_REF`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_CACHE_REF
    # [`SMALL_INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_INTEGER_EXT
    # [`EXPORT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#EXPORT_EXT
    #
    class Export
      include Erlang::ETF::Term

      class << self
        def [](term, mod = nil, function = nil, arity = nil)
          return new(term, mod, function, arity)
        end

        def erlang_load(buffer)
          mod      = Erlang::ETF.read_term(buffer)
          function = Erlang::ETF.read_term(buffer)
          arity    = Erlang::ETF.read_term(buffer)
          term     = Erlang::Export[Erlang.from(mod), Erlang.from(function), Erlang.from(arity)]
          return new(term, mod, function, arity)
        end
      end

      def initialize(term, mod = nil, function = nil, arity = nil)
        raise ArgumentError, "term must be of type Erlang::Export" if not term.kind_of?(Erlang::Export)
        @term     = term
        @mod      = mod
        @function = function
        @arity    = arity
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << EXPORT_EXT
        Erlang::ETF.write_term(@mod      || @term.mod,      buffer)
        Erlang::ETF.write_term(@function || @term.function, buffer)
        Erlang::ETF.write_term(@arity    || @term.arity,    buffer)
        return buffer
      end

      def inspect
        if @mod.nil? and @function.nil? and @arity.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@mod.inspect}, #{@function.inspect}, #{@arity.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@mod, @function, @arity) if not @mod.nil? or not @function.nil? or not @arity.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
