module Erlang
  module ETF

    #
    # | 1   | 4   | 1    | Len  |
    # | --- | --- | ---- | ---- |
    # | 77  | Len | Bits | Data |
    #
    # This term represents a bitstring whose length in bits is not a
    # multiple of 8 (created using the bit syntax in R12B and later).
    # The `Len` field is an unsigned 4 byte integer (big endian).
    # The `Bits` field is the number of bits that are used in the last
    # byte in the data field, counting from the most significant bit
    # towards the least significant.
    #
    # (see [`BIT_BINARY_EXT`])
    #
    # [`BIT_BINARY_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#BIT_BINARY_EXT
    #
    class BitBinary
      include Erlang::ETF::Term

      UINT8    = Erlang::ETF::Term::UINT8
      UINT32BE = Erlang::ETF::Term::UINT32BE
      HEAD     = (UINT32BE + UINT8).freeze

      class << self
        def [](term)
          term = Erlang.from(term) if not term.kind_of?(Erlang::Bitstring)
          return new(term)
        end

        def erlang_load(buffer)
          size, bits, = buffer.read(5).unpack(HEAD)
          data = buffer.read(size)
          if size > 0
            data.setbyte(-1, data.getbyte(-1) >> (8 - bits))
          end
          return new(Erlang::Bitstring[data, bits: bits])
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::Bitstring" if not term.kind_of?(Erlang::Bitstring) and not term.kind_of?(Erlang::Binary)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << BIT_BINARY_EXT
        buffer << [@term.bytesize, @term.bits].pack(HEAD)
        buffer << Erlang::ETF::Term.binary_encoding(@term.data)
        if @term.bytesize > 0
          buffer.setbyte(-1, buffer.getbyte(-1) << (8 - @term.bits))
        end
        return buffer
      end
    end
  end
end
