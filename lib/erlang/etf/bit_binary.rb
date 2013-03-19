module Erlang
  module ETF

    #
    # 1  | 4   | 1    | Len
    # -- | --- | ---- | ----
    # 77 | Len | Bits | Data
    #
    # This term represents a bitstring whose length in bits is not a
    # multiple of 8 (created using the bit syntax in R12B and later).
    # The Len field is an unsigned 4 byte integer (big endian).
    # The Bits field is the number of bits that are used in the last
    # byte in the data field, counting from the most significant bit
    # towards the least significant.
    #
    class BitBinary
      include Term

      uint8 :tag, always: Terms::BIT_BINARY_EXT

      uint32be :len, always: -> { data.bytesize }

      uint8 :bits

      string :data, default: ""

      undef serialize_data
      def serialize_data(buffer)
        buffer << data.to_utf8_binary
      end

      deserialize do |buffer|
        len, = buffer.read(BYTES_32).unpack(UINT32BE_PACK)
        deserialize_bits(buffer)
        self.data = buffer.read(len).from_utf8_binary
        self
      end

      finalize

      def initialize(bits, data = "")
        self.bits = bits
        self.data = data
      end
    end
  end
end