require 'erlang/export'

module Erlang
  module ETF
    module Extensions

      module ErlangExport

        def __erlang_type__
          :export
        end

        def __erlang_evolve__
          ETF::Export.new(
            mod.to_s.intern.__erlang_evolve__,
            function.to_s.intern.__erlang_evolve__,
            arity.__erlang_evolve__
          )
        end

      end
    end
  end
end
