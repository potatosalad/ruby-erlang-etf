module Erlang
  module ETF

    #
    # | 1   | 4       | N1  | N2     | N3    | N4   | N5            |
    # | --- | ------- | --- | ------ | ----- | ---- | ------------- |
    # | 117 | NumFree | Pid | Module | Index | Uniq | Free vars ... |
    #
    # `Pid`
    # > is a process identifier as in [`PID_EXT`]. It represents the
    #   process in which the fun was created.
    #
    # `Module`
    # > is an encoded as an atom, using [`ATOM_EXT`], [`SMALL_ATOM_EXT`] or
    #   [`ATOM_CACHE_REF`]. This is the module that the fun is
    #   implemented in.
    #
    # `Index`
    # > is an integer encoded using [`SMALL_INTEGER_EXT`] or [`INTEGER_EXT`].
    #   It is typically a small index into the module's fun table.
    #
    # `Uniq`
    # > is an integer encoded using [`SMALL_INTEGER_EXT`] or [`INTEGER_EXT`].
    #   `Uniq` is the hash value of the parse for the fun.
    #
    # `Free vars`
    # > is `NumFree` number of terms, each one encoded according to its
    #   type.
    #
    # (see [`FUN_EXT`])
    #
    # [`PID_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#PID_EXT
    # [`ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_EXT
    # [`SMALL_ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_ATOM_EXT
    # [`ATOM_CACHE_REF`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_CACHE_REF
    # [`SMALL_INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_INTEGER_EXT
    # [`INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#INTEGER_EXT
    # [`FUN_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#FUN_EXT
    #
    class Fun
      include Erlang::ETF::Term

      UINT32BE = Erlang::ETF::Term::UINT32BE

      class << self
        def [](term, pid = nil, mod = nil, index = nil, uniq = nil, free_vars = nil)
          return new(term, pid, mod, index, uniq, free_vars)
        end

        def erlang_load(buffer)
          num_free, = buffer.read(4).unpack(UINT32BE)
          pid       = Erlang::ETF.read_term(buffer)
          mod       = Erlang::ETF.read_term(buffer)
          index     = Erlang::ETF.read_term(buffer)
          uniq      = Erlang::ETF.read_term(buffer)
          free_vars = Array.new(num_free); num_free.times { |i| free_vars[i] = Erlang::ETF.read_term(buffer) }
          term      = Erlang::Function[pid: Erlang.from(pid), mod: Erlang.from(mod), index: Erlang.from(index), uniq: Erlang.from(uniq), free_vars: Erlang.from(free_vars)]
          return new(term, pid, mod, index, uniq, free_vars)
        end
      end

      def initialize(term, pid = nil, mod = nil, index = nil, uniq = nil, free_vars = nil)
        raise ArgumentError, "term must be of type Erlang::Function" if not term.kind_of?(Erlang::Function) or term.new_function?
        @term      = term
        @pid       = pid
        @mod       = mod
        @index     = index
        @uniq      = uniq
        @free_vars = free_vars
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << FUN_EXT
        free_vars = @free_vars || @term.free_vars
        num_free = free_vars.length
        buffer << [num_free].pack(UINT32BE)
        Erlang::ETF.write_term(@pid   || @term.pid,       buffer)
        Erlang::ETF.write_term(@mod   || @term.mod,       buffer)
        Erlang::ETF.write_term(@index || @term.index,     buffer)
        Erlang::ETF.write_term(@uniq  || @term.uniq,      buffer)
        num_free.times { |i| Erlang::ETF.write_term(free_vars[i], buffer) }
        return buffer
      end

      def inspect
        if @pid.nil? and @mod.nil? and @index.nil? and @uniq.nil? and @free_vars.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@pid.inspect}, #{@mod.inspect}, #{@index.inspect}, #{@uniq.inspect}, #{@free_vars.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@pid, @mod, @index, @uniq, @free_vars) if not @pid.nil? or not @mod.nil? or not @index.nil? or not @uniq.nil? or not @free_vars.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
