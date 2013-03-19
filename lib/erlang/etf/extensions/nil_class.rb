module Erlang
  module ETF
    module Extensions

      #
      # nil {bert, nil}
      #
      # Erlang equates nil with the empty array [] while other languages do not.
      # Even though NIL appears as a primitive in the serialization specification, BERT only uses it to represent the empty array.
      # In order to be language agnostic, nil is encoded as a separate complex type to allow for disambiguation.
      #
      # See: http://bert-rpc.org/
      #
      module NilClass

        def __erlang_type__
          :bert_nil
        end

        def __erlang_evolve__
          ::Erlang::Tuple[:bert, :nil].__erlang_evolve__
        end

        module ClassMethods
        end
      end
    end
  end
end
