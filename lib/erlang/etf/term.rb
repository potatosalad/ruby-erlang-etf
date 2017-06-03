module Erlang
  module ETF
    #
    # See [`erts/emulator/beam/external.h`]
    #
    # [`erts/emulator/beam/external.h`]: https://github.com/erlang/otp/blob/master/erts/emulator/beam/external.h
    #
    module Term

      BINARY_ENCODING = Encoding.find('binary')

      ERLANG_MAGIC_BYTE       = 131.chr.force_encoding(BINARY_ENCODING).freeze
      SMALL_INTEGER_EXT       =  97.freeze
      INTEGER_EXT             =  98.freeze
      FLOAT_EXT               =  99.freeze
      ATOM_EXT                = 100.freeze
      REFERENCE_EXT           = 101.freeze
      PORT_EXT                = 102.freeze
      PID_EXT                 = 103.freeze
      SMALL_TUPLE_EXT         = 104.freeze
      LARGE_TUPLE_EXT         = 105.freeze
      NIL_EXT                 = 106.freeze
      STRING_EXT              = 107.freeze
      LIST_EXT                = 108.freeze
      BINARY_EXT              = 109.freeze
      SMALL_BIG_EXT           = 110.freeze
      LARGE_BIG_EXT           = 111.freeze
      NEW_REFERENCE_EXT       = 114.freeze
      SMALL_ATOM_EXT          = 115.freeze
      FUN_EXT                 = 117.freeze
      NEW_FUN_EXT             = 112.freeze
      EXPORT_EXT              = 113.freeze
      BIT_BINARY_EXT          =  77.freeze
      NEW_FLOAT_EXT           =  70.freeze
      ATOM_UTF8_EXT           = 118.freeze
      SMALL_ATOM_UTF8_EXT     = 119.freeze
      MAP_EXT                 = 116.freeze
      DIST_HEADER             =  68.freeze # not implemented
      ATOM_CACHE_REF          =  82.freeze # not implemented
      ATOM_INTERNAL_REF2      =  73.freeze # not implemented
      ATOM_INTERNAL_REF3      =  75.freeze # not implemented
      BINARY_INTERNAL_REF     =  74.freeze # not implemented
      BIT_BINARY_INTERNAL_REF =  76.freeze # not implemented
      COMPRESSED              =  80.freeze

      INT8      = 'c'.freeze    # 8-bit signed (signed char)
      INT16     = 's'.freeze    # 16-bit signed, native endian (int16_t)
      INT32     = 'l'.freeze    # 32-bit signed, native endian (int32_t)
      INT64     = 'q'.freeze    # 64-bit signed, native endian (int64_t)
      INT128    = 'qq'.freeze   # 128-bit signed, native endian (int128_t)
      INT16BE   = 's>'.freeze   # 16-bit signed, big-endian
      INT32BE   = 'l>'.freeze   # 32-bit signed, big-endian
      INT64BE   = 'q>'.freeze   # 64-bit signed, big-endian
      INT128BE  = 'q>q>'.freeze # 128-bit signed, big-endian
      INT16LE   = 's<'.freeze   # 16-bit signed, little-endian
      INT32LE   = 'l<'.freeze   # 32-bit signed, little-endian
      INT64LE   = 'q<'.freeze   # 64-bit signed, little-endian
      INT128LE  = 'q<q<'.freeze # 128-bit signed, little-endian
      UINT8     = 'C'.freeze    # 8-bit unsigned (unsigned char)
      UINT16    = 'S'.freeze    # 16-bit unsigned, native endian (uint16_t)
      UINT32    = 'L'.freeze    # 32-bit unsigned, native endian (uint32_t)
      UINT64    = 'Q'.freeze    # 64-bit unsigned, native endian (uint64_t)
      UINT128   = 'QQ'.freeze   # 128-bit unsigned, native endian (uint128_t)
      UINT16BE  = 'n'.freeze    # 16-bit unsigned, network (big-endian) byte order
      UINT32BE  = 'N'.freeze    # 32-bit unsigned, network (big-endian) byte order
      UINT64BE  = 'Q>'.freeze   # 64-bit unsigned, network (big-endian) byte order
      UINT128BE = 'Q>Q>'.freeze # 128-bit unsigned, network (big-endian) byte order
      UINT16LE  = 'v'.freeze    # 16-bit unsigned, VAX (little-endian) byte order
      UINT32LE  = 'V'.freeze    # 32-bit unsigned, VAX (little-endian) byte order
      UINT64LE  = 'Q<'.freeze   # 64-bit unsigned, VAX (little-endian) byte order
      UINT128LE = 'Q<Q<'.freeze # 128-bit unsigned, VAX (little-endian) byte order
      SINGLE    = 'F'.freeze    # 32-bit single-precision, native format
      DOUBLE    = 'D'.freeze    # 64-bit double-precision, native format
      SINGLEBE  = 'g'.freeze    # 32-bit sinlge-precision, network (big-endian) byte order
      DOUBLEBE  = 'G'.freeze    # 64-bit double-precision, network (big-endian) byte order
      SINGLELE  = 'e'.freeze    # 32-bit sinlge-precision, little-endian byte order
      DOUBLELE  = 'E'.freeze    # 64-bit double-precision, little-endian byte order

      class << self

        # Extends the including class with +ClassMethods+.
        #
        # @param [Class] subclass the inheriting class
        def included(base)
          super
          # base.send(:include, ::Binary::Protocol)
          base.send(:include, Erlang::Immutable)
          base.extend ClassMethods
          base.send(:include, ::Comparable)
          base.class_eval do
            attr_reader :term
            alias :to_erlang :term
            memoize :erlang_external_type
          end
        end
        private :included
      end

      module ClassMethods
      end

      def self.binary_encoding(string)
        string = string.dup if string.frozen?
        string = string.force_encoding(BINARY_ENCODING)
        return string
      end

      def erlang_external_type
        type = self.class.name.split('::').last.dup
        type.gsub!('::', '/')
        type.gsub!(/(?:([A-Za-z\d])|^)(UTF8)(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
        type.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        type.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        type.tr!("-", "_")
        type.downcase!
        return type.intern
      end

      def inspect
        return "#{self.class.name}[#{term.inspect}]"
      end

      def hash
        return @term.hash
      end

      def eql?(other)
        return @term.eql?(other)
      end

      def <=>(other)
        return Erlang.compare(self, other)
      end

      def to_erlang_etf
        return self
      end
    end
  end
end
