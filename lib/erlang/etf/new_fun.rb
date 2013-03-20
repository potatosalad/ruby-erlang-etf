module Erlang
  module ETF

    #
    # 1   | 4    | 1     | 16   | 4     | 4       | N1     | N2       | N3      | N4  | N5
    # --- | ---- | ----- | ---- | ----- | ------- | ------ | -------- | ------- | --- | ---------
    # 112 | Size | Arity | Uniq | Index | NumFree | Module | Oldindex | OldUniq | Pid | Free Vars
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
      include Term

      uint8 :tag, always: Terms::NEW_FUN_EXT

      uint32be :size, default: 0, inclusive: true do
        uint8 :arity
        string :uniq
        uint32be :index
        uint32be :num_free, always: -> { free_vars.size }
        term :mod
        term :old_index
        term :old_uniq
        term :pid
        term :free_vars, type: :array
      end

      undef deserialize_uniq
      def deserialize_uniq(buffer)
        self.uniq = buffer.read(16).unpack(UINT8_PACK + '*')
      end

      undef serialize_uniq
      def serialize_uniq(buffer)
        buffer << uniq.pack(UINT8_PACK + '*')
      end

      deserialize do |buffer|
        deserialize_size(buffer)
        deserialize_arity(buffer)
        deserialize_uniq(buffer)
        deserialize_index(buffer)
        num_free, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
        deserialize_mod(buffer)
        deserialize_old_index(buffer)
        deserialize_old_uniq(buffer)
        deserialize_pid(buffer)
        self.free_vars = []
        num_free.times do
          self.free_vars << Terms.deserialize(buffer)
        end
        self
      end

      finalize

      def initialize(arity, uniq, index, mod, old_index, old_uniq, pid, free_vars = [])
        self.arity     = arity
        self.uniq      = uniq
        self.index     = index
        self.mod       = mod
        self.old_index = old_index
        self.old_uniq  = old_uniq
        self.pid       = pid
        self.free_vars = free_vars
      end
    end
  end
end