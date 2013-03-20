require 'erlang/nil'

module Erlang
  module ETF
    module Extensions

      module ErlangNil

        def __erlang_type__
          :nil
        end

        def __erlang_evolve__
          ETF::Nil.new
        end

      end
    end
  end
end
