module Erlang
  module ETF

    #
    # 1   | 4 | 1    | n
    # --- | - | ---- | ---------------
    # 111 | n | Sign | d(0) ... d(n-1)
    #
    # Same as SMALL_BIG_EXT with the difference that the length field
    # is an unsigned 4 byte integer.
    #
    class LargeBig
      include Term

      uint8 :tag, always: Terms::LARGE_BIG_EXT

      uint32be :n, default: 0 do
        uint8 :sign, always: -> { (integer >= 0) ? 0 : 1 }
        string :integer
      end

      undef serialize_integer
      def serialize_integer(buffer)
        start = buffer.bytesize
        buffer << [integer.abs.to_s(2).reverse!].pack(BIN_LSB_PACK)
        self.n = buffer.bytesize - start
        buffer
      end

      undef after_serialize_n
      def after_serialize_n(buffer)
        buffer[@n_start, BYTES_32] = serialize_n ""
      end

      deserialize do |buffer|
        deserialize_n(buffer)
        sign, = buffer.read(BYTES_8).unpack(UINT8_PACK)
        self.integer = buffer.read(n).unpack(BIN_LSB_PACK).at(0).reverse!.to_i(2) * ((sign == 0) ? 1 : -1)
        self
      end

      finalize

      def initialize(integer)
        @integer = integer
      end

      def __ruby_evolve__
        integer
      end
    end
  end
end