module Erlang
  module ETF
    module Terms
      ATOM_CACHE_REF      =  82.freeze # not implemented
      SMALL_INTEGER_EXT   =  97.freeze
      INTEGER_EXT         =  98.freeze
      FLOAT_EXT           =  99.freeze
      ATOM_EXT            = 100.freeze
      REFERENCE_EXT       = 101.freeze
      PORT_EXT            = 102.freeze
      PID_EXT             = 103.freeze
      SMALL_TUPLE_EXT     = 104.freeze
      LARGE_TUPLE_EXT     = 105.freeze
      NIL_EXT             = 106.freeze
      STRING_EXT          = 107.freeze
      LIST_EXT            = 108.freeze
      BINARY_EXT          = 109.freeze
      SMALL_BIG_EXT       = 110.freeze
      LARGE_BIG_EXT       = 111.freeze
      NEW_REFERENCE_EXT   = 114.freeze
      SMALL_ATOM_EXT      = 115.freeze
      FUN_EXT             = 117.freeze
      NEW_FUN_EXT         = 112.freeze
      EXPORT_EXT          = 113.freeze
      BIT_BINARY_EXT      =  77.freeze
      NEW_FLOAT_EXT       =  70.freeze
      ATOM_UTF8_EXT       = 118.freeze
      SMALL_ATOM_UTF8_EXT = 119.freeze
    end
  end
end

require "erlang/etf/term"
require "erlang/etf/bert"

require "erlang/etf/atom"
require "erlang/etf/atom_utf8"
require "erlang/etf/binary"
require "erlang/etf/bit_binary"
require "erlang/etf/export"
require "erlang/etf/float"
require "erlang/etf/fun"
require "erlang/etf/integer"
require "erlang/etf/large_big"
require "erlang/etf/large_tuple"
require "erlang/etf/list"
require "erlang/etf/new_float"
require "erlang/etf/new_fun"
require "erlang/etf/new_reference"
require "erlang/etf/nil"
require "erlang/etf/pid"
require "erlang/etf/port"
require "erlang/etf/reference"
require "erlang/etf/small_atom"
require "erlang/etf/small_atom_utf8"
require "erlang/etf/small_big"
require "erlang/etf/small_integer"
require "erlang/etf/small_tuple"
require "erlang/etf/string"

module Erlang
  module ETF
    module Terms
      MAP = {}
      # MAP[ATOM_CACHE_REF]    = undefined
      MAP[SMALL_INTEGER_EXT]   = ETF::SmallInteger
      MAP[INTEGER_EXT]         = ETF::Integer
      MAP[FLOAT_EXT]           = ETF::Float
      MAP[ATOM_EXT]            = ETF::Atom
      MAP[REFERENCE_EXT]       = ETF::Reference
      MAP[PORT_EXT]            = ETF::Port
      MAP[PID_EXT]             = ETF::Pid
      MAP[SMALL_TUPLE_EXT]     = ETF::SmallTuple
      MAP[LARGE_TUPLE_EXT]     = ETF::LargeTuple
      MAP[NIL_EXT]             = ETF::Nil
      MAP[STRING_EXT]          = ETF::String
      MAP[LIST_EXT]            = ETF::List
      MAP[BINARY_EXT]          = ETF::Binary
      MAP[SMALL_BIG_EXT]       = ETF::SmallBig
      MAP[LARGE_BIG_EXT]       = ETF::LargeBig
      MAP[NEW_REFERENCE_EXT]   = ETF::NewReference
      MAP[SMALL_ATOM_EXT]      = ETF::SmallAtom
      MAP[FUN_EXT]             = ETF::Fun
      MAP[NEW_FUN_EXT]         = ETF::NewFun
      MAP[EXPORT_EXT]          = ETF::Export
      MAP[BIT_BINARY_EXT]      = ETF::BitBinary
      MAP[NEW_FLOAT_EXT]       = ETF::NewFloat
      MAP[ATOM_UTF8_EXT]       = ETF::AtomUTF8
      MAP[SMALL_ATOM_UTF8_EXT] = ETF::SmallAtomUTF8

      def self.deserialize(buffer)
        key, = buffer.read(1).unpack(::Binary::Protocol::UINT8_PACK)
        if MAP.key?(key)
          MAP[key].deserialize(buffer)
        else
          raise NotImplementedError, "unknown Erlang External Format tag #{key.inspect} (see http://erlang.org/doc/apps/erts/erl_ext_dist.html)"
        end
      end

      def self.evolve(buffer)
        deserialize(buffer).__ruby_evolve__
      end
    end
  end
end
