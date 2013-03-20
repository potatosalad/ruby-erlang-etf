require 'erlang/pid'

module Erlang
  module ETF
    module Extensions

      module ErlangPid

        def __erlang_type__
          :pid
        end

        def __erlang_evolve__
          ETF::Pid.new(node.to_s.intern.__erlang_evolve__, id, serial, creation)
        end

      end
    end
  end
end
