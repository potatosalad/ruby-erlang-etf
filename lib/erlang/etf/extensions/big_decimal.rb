require 'bigdecimal'

module Erlang
  module ETF
    module Extensions

      module BigDecimal

        def __erlang_type__
          :float
        end

        def __erlang_evolve__
          ETF::Float.new(self)
        end

      end
    end
  end
end
