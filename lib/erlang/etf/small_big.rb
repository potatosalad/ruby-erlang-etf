module Erlang
  module ETF

    #
    # 1   | 1 | 1    | n
    # --- | - | ---- | ---------------
    # 110 | n | Sign | d(0) ... d(n-1)
    #
    # Bignums are stored in unary form with a Sign byte that is 0 if
    # the binum is positive and 1 if is negative. The digits are
    # stored with the LSB byte stored first. To calculate the integer
    # the following formula can be used:
    # B = 256
    # (d0*B^0 + d1*B^1 + d2*B^2 + ... d(N-1)*B^(n-1))
    #
    class SmallBig
      include Term

      uint8 :tag, always: Terms::SMALL_BIG_EXT

      uint8 :n, default: 0 do
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
        buffer[@n_start, BYTES_8] = serialize_n ""
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