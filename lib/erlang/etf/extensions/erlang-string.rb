require 'erlang/string'

module Erlang
  module ETF
    module Extensions

      module ErlangString

        def __erlang_type__
          :string
        end

        def __erlang_evolve__
          ETF::String.new(self)
        end

        module ClassMethods
        end
      end
    end
  end
end
