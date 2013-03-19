module Erlang
  module ETF

    #
    # 1   | 4       | N1  | N2     | N3    | N4   | N5
    # --- | ------- | --- | ------ | ----- | ---- | -------------
    # 117 | NumFree | Pid | Module | Index | Uniq | Free vars ...
    #
    # Pid
    #   is a process identifier as in PID_EXT. It represents the
    #   process in which the fun was created.
    # Module
    #   is an encoded as an atom, using ATOM_EXT, SMALL_ATOM_EXT or
    #   ATOM_CACHE_REF. This is the module that the fun is
    #   implemented in.
    # Index
    #   is an integer encoded using SMALL_INTEGER_EXT or INTEGER_EXT.
    #   It is typically a small index into the module's fun table.
    # Uniq
    #   is an integer encoded using SMALL_INTEGER_EXT or INTEGER_EXT.
    #   Uniq is the hash value of the parse for the fun.
    # Free vars
    #   is NumFree number of terms, each one encoded according to its
    #   type.
    #
    class Fun
      include Term

      uint8 :tag, always: Terms::FUN_EXT

      uint16be :num_free, always: -> { free_vars.size }

      term :pid # pid

      term :mod # atom, small_atom

      term :index # small_integer, integer

      term :uniq # small_integer, integer

      term :free_vars, type: :array

      deserialize do |buffer|
        num_free, = buffer.read(BYTES_16).unpack(UINT16BE_PACK)
        deserialize_pid(buffer)
        deserialize_mod(buffer)
        deserialize_index(buffer)
        deserialize_uniq(buffer)
        self.free_vars = []
        num_free.times do
          self.free_vars << Terms.deserialize(buffer)
        end
        self
      end

      finalize

      def initialize(pid, mod, index, uniq, free_vars = [])
        self.pid       = pid
        self.mod       = mod
        self.index     = index
        self.uniq      = uniq
        self.free_vars = free_vars
      end
    end
  end
end