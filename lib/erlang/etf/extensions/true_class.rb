module Erlang
  module ETF
    module Extensions

      #
      # boolean {bert, true} or {bert, false}
      #
      # Erlang equates the true and false atoms with booleans while other languages do not have this behavior.
      # To disambiguate these cases, booleans are expressed as their own complex type.
      #
      # See: http://bert-rpc.org/
      #
      module TrueClass

        def __erlang_type__
          :bert_boolean
        end

        def __erlang_evolve__
          ::Erlang::Tuple[:bert, :true].__erlang_evolve__
        end

      end
    end
  end
end
