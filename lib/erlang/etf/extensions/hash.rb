module Erlang
  module ETF
    module Extensions

      #
      # dictionary {bert, dict, KeysAndValues}
      #
      # Dictionaries (hash tables) are expressed via an array of 2-tuples representing the key/value pairs.
      # The KeysAndValues array is mandatory, such that an empty dict is expressed as {bert, dict, []}.
      # Keys and values may be any term.
      # For example, {bert, dict, [{name, <<"Tom">>}, {age, 30}]}.
      #
      # See: http://bert-rpc.org/
      #
      module Hash

        def __erlang_type__
          :bert_dict
        end

        def __erlang_evolve__
          ::Erlang::Tuple[:bert, :dict, map do |(key, value)|
            ::Erlang::Tuple[key, value]
          end].__erlang_evolve__
        end

        module ClassMethods
        end
      end
    end
  end
end
