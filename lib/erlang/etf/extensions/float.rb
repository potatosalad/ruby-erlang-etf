module Erlang
  module ETF
    module Extensions

      module Float

        def __erlang_type__
          :new_float
        end

        def __erlang_evolve__
          ETF::NewFloat.new(self)
        end

        module ClassMethods
        end
      end
    end
  end
end
