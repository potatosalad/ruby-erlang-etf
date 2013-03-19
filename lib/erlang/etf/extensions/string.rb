module Erlang
  module ETF
    module Extensions

      BINARY_ENCODING = Encoding.find("binary")
      UTF8_ENCODING   = Encoding.find("utf-8")

      module String

        def __erlang_type__
          :binary
        end

        def __erlang_evolve__
          ETF::Binary.new(self)
        end

        def to_utf8_binary
          encode(UTF8_ENCODING).force_encoding(BINARY_ENCODING)
        rescue EncodingError
          data = dup.force_encoding(UTF8_ENCODING)
          raise unless data.valid_encoding?
          data.force_encoding(BINARY_ENCODING)
        end

        def from_utf8_binary
          force_encoding(UTF8_ENCODING).encode!
        end

        module ClassMethods
        end
      end
    end
  end
end
