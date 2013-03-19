module Erlang
  module ETF
    module Extensions

      module Object

        def __erlang_type__
          raise NotImplementedError, "#__erlang_type__ undefined for #{inspect} of class #{self.class}"
        end

        def __erlang_evolve__
          raise NotImplementedError, "#__erlang_evolve__ undefined for #{inspect} of class #{self.class}"
        end

        def __erlang_dump__(buffer)
          __erlang_evolve__.serialize(buffer)
        end

        module ClassMethods
        end
      end
    end
  end
end
