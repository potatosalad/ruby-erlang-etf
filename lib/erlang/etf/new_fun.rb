module Erlang
  module ETF

    #
    # | 1   | 4    | 1     | 16   | 4     | 4       | N1     | N2       | N3      | N4  | N5        |
    # | --- | ---- | ----- | ---- | ----- | ------- | ------ | -------- | ------- | --- | --------- |
    # | 112 | Size | Arity | Uniq | Index | NumFree | Module | Oldindex | OldUniq | Pid | Free Vars |
    #
    # This is the new encoding of internal funs:
    #
    # ```erlang
    # fun F/A and fun(Arg1,..) -> ... end.
    # ```
    #
    # `Size`
    # > is the total number of bytes, including the `Size` field.
    #
    # `Arity`
    # > is the arity of the function implementing the fun.
    #
    # `Uniq`
    # > is the 16 bytes MD5 of the significant parts of the Beam file.
    #
    # `Index`
    # > is an index number. Each fun within a module has an unique
    #   index. `Index` is stored in big-endian byte order.
    #
    # `NumFree`
    # > is the number of free variables.
    #
    # `Module`
    # > is an encoded as an atom, using [`ATOM_EXT`], [`SMALL_ATOM_EXT`] or
    #   [`ATOM_CACHE_REF`]. This is the module that the fun is implemented
    #   in.
    #
    # `OldIndex`
    # > is an integer encoded using [`SMALL_INTEGER_EXT`] or [`INTEGER_EXT`].
    #   It is typically a small index into the module's fun table.
    #
    # `OldUniq`
    # > is an integer encoded using [`SMALL_INTEGER_EXT`] or [`INTEGER_EXT`].
    #   `Uniq` is the hash value of the parse tree for the fun.
    #
    # `Pid`
    # > is a process identifier as in [`PID_EXT`]. It represents the
    #   process in which the fun was created.
    #
    # `Free vars`
    # > is `NumFree` number of terms, each one encoded according to its
    #   type.
    #
    # (see [`NEW_FUN_EXT`])
    #
    # [`ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_EXT
    # [`SMALL_ATOM_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_ATOM_EXT
    # [`ATOM_CACHE_REF`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#ATOM_CACHE_REF
    # [`SMALL_INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#SMALL_INTEGER_EXT
    # [`INTEGER_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#INTEGER_EXT
    # [`PID_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#PID_EXT
    # [`NEW_FUN_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NEW_FUN_EXT
    #
    class NewFun
      include Erlang::ETF::Term

      UINT8     = Erlang::ETF::Term::UINT8
      UINT32BE  = Erlang::ETF::Term::UINT32BE
      UINT128BE = Erlang::ETF::Term::UINT128BE
      HEAD      = (UINT32BE + UINT8 + UINT128BE + UINT32BE + UINT32BE).freeze

      class << self
        def [](term, arity = nil, uniq = nil, index = nil, mod = nil, old_index = nil, old_uniq = nil, pid = nil, free_vars = nil)
          return new(term, arity, uniq, index, mod, old_index, old_uniq, pid, free_vars)
        end

        def erlang_load(buffer)
          _, arity, uniq_hi, uniq_lo, index, num_free = buffer.read(29).unpack(HEAD)
          uniq = (uniq_hi << 64) + uniq_lo
          mod       = Erlang::ETF.read_term(buffer)
          old_index = Erlang::ETF.read_term(buffer)
          old_uniq  = Erlang::ETF.read_term(buffer)
          pid       = Erlang::ETF.read_term(buffer)
          free_vars = Array.new(num_free); num_free.times { |i| free_vars[i] = Erlang::ETF.read_term(buffer) }
          term      = Erlang::Function[arity: Erlang.from(arity), uniq: Erlang.from(uniq), index: Erlang.from(index), mod: Erlang.from(mod), old_index: Erlang.from(old_index), old_uniq: Erlang.from(old_uniq), pid: Erlang.from(pid), free_vars: Erlang.from(free_vars)]
          return new(term, arity, uniq, index, mod, old_index, old_uniq, pid, free_vars)
        end
      end

      def initialize(term, arity = nil, uniq = nil, index = nil, mod = nil, old_index = nil, old_uniq = nil, pid = nil, free_vars = nil)
        raise ArgumentError, "term must be of type Erlang::Function" if not term.kind_of?(Erlang::Function) or not term.new_function?
        @term      = term
        @arity     = arity
        @uniq      = uniq
        @index     = index
        @mod       = mod
        @old_index = old_index
        @old_uniq  = old_uniq
        @pid       = pid
        @free_vars = free_vars
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << NEW_FUN_EXT
        size      = 0
        arity     = @arity     || @term.arity
        uniq      = @uniq      || @term.uniq
        index     = @index     || @term.index
        free_vars = @free_vars || @term.free_vars
        num_free  = free_vars.length
        sizestart = buffer.bytesize
        buffer << [size, arity, uniq >> 64, uniq, index, num_free].pack(HEAD)
        Erlang::ETF.write_term(@mod       || @term.mod,       buffer)
        Erlang::ETF.write_term(@old_index || @term.old_index, buffer)
        Erlang::ETF.write_term(@old_uniq  || @term.old_uniq,  buffer)
        Erlang::ETF.write_term(@pid       || @term.pid,       buffer)
        num_free.times { |i| Erlang::ETF.write_term(free_vars[i], buffer) }
        sizeend   = buffer.bytesize
        size      = sizeend - sizestart
        buffer.setbyte(sizestart + 0, size >> 24)
        buffer.setbyte(sizestart + 1, size >> 16)
        buffer.setbyte(sizestart + 2, size >> 8)
        buffer.setbyte(sizestart + 3, size)
        return buffer
      end

      def inspect
        if @arity.nil? and @uniq.nil? and @index.nil? and @mod.nil? and @old_index.nil? and @old_uniq.nil? and @pid.nil? and @free_vars.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@arity.inspect}, #{@uniq.inspect}, #{@index.inspect}, #{@mod.inspect}, #{@old_index.inspect}, #{@old_uniq.inspect}, #{@pid.inspect}, #{@free_vars.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@arity, @uniq, @index, @mod, @old_index, @old_uniq, @pid, @free_vars) if not @arity.nil? or not @uniq.nil? or not @index.nil? or not @mod.nil? or not @old_index.nil? or not @old_uniq.nil? or not @pid.nil? or not @free_vars.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
