module Erlang
  module ETF
    module Extensions

      module Integer

        UINT8_MIN = 0.freeze
        UINT8_MAX = (+(1 << 8) - 1).freeze

        INT32_MIN = (-(1 << 31) + 1).freeze
        INT32_MAX = (+(1 << 31) - 1).freeze

        SMALL_BIG_N_MAX = 255.freeze

        def __erlang_type__
          if self >= UINT8_MIN and self <= UINT8_MAX
            :small_integer
          elsif self >= INT32_MIN and self <= INT32_MAX
            :integer
          else
            n = (abs.to_s(2).bytesize / 8.0).ceil
            if n <= SMALL_BIG_N_MAX
              :small_big
            else
              :large_big
            end
          end
        end

        def __erlang_evolve__
          case __erlang_type__
          when :small_integer
            ETF::SmallInteger.new(self)
          when :integer
            ETF::Integer.new(self)
          when :small_big
            ETF::SmallBig.new(self)
          when :large_big
            ETF::LargeBig.new(self)
          end
        end

        module ClassMethods
        end
      end
    end
  end
end
