require 'zlib'

module Erlang
  module ETF

    #
    # 1   | 4                | N
    # --- | ---------------- | -------------------
    # 80  | UncompressedSize | Zlib-compressedData
    #
    # Uncompressed Size (unsigned 32 bit integer in big-endian 
    # byte order) is the size of the data before it was compressed. 
    # The compressed data has the following format when it has been expanded:
    #
    # 1    | Uncompressed Size
    # ---- | -----------------
    # Tag  | Data
    #
    # (see [`External Term Format`] and [`term_to_binary/2`])
    #
    # [`External Term Format`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#overall_format
    # [`term_to_binary/2`]: http://www.erlang.org/doc/man/erlang.html#term_to_binary-2
    #
    class Compressed
      include Term

      uint8 :tag, always: Terms::COMPRESSED

      uint32be :uncompressed_size, always: -> { data.serialize.bytesize }

      term :data

      deserialize do |buffer|
        uncompressed_size, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
        compressed_data = buffer.read()
        uncompressed_data = ::Zlib::Inflate.inflate(compressed_data)
        if uncompressed_size == uncompressed_data.bytesize
          deserialize_data(::StringIO.new(uncompressed_data))
        else
          raise ::Zlib::DataError, "UncompressedSize value did not match the size of the uncompressed data"
        end
      end

      undef serialize_data
      def serialize_data(buffer)
        uncompressed_data = data.serialize
        compressed_data = ::Zlib::Deflate.deflate(uncompressed_data, @level)
        buffer << compressed_data
      end

      finalize

      LEVEL_RANGE = (0..9).freeze
      LEVEL_DEFAULT = 6.freeze

      def initialize(data, level = LEVEL_DEFAULT)
        @data = data
        @level = LEVEL_RANGE.include?(level) ? level : LEVEL_DEFAULT
      end

      def __ruby_evolve__
        data.__ruby_evolve__
      end
    end
  end
end