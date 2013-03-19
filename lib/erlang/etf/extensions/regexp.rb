module Erlang
  module ETF
    module Extensions

      #
      # regex {bert, regex, Source, Options}
      #
      # Regular expressions are expressed by their source binary and PCRE options.
      # Options is a list of atoms representing the PCRE options.
      # For example, {bert, regex, <<"^c(a*)t$">>, [caseless]} would represent a case insensitive regular epxression that would match "cat".
      # See re:compile/2 for valid options.
      #
      # See: http://bert-rpc.org/
      #
      module Regexp

        def __erlang_type__
          :bert_regex
        end

        def __erlang_evolve__
          opts = []
          opts << :caseless  if (options & ::Regexp::IGNORECASE) != 0
          opts << :extended  if (options & ::Regexp::EXTENDED)   != 0
          opts << :multiline if (options & ::Regexp::MULTILINE)  != 0
          ::Erlang::Tuple[:bert, :regex, source, opts].__erlang_evolve__
        end

        module ClassMethods
        end
      end
    end
  end
end
