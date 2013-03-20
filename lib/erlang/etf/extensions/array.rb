module Erlang
  module ETF
    module Extensions

      module Array

        def __erlang_type__
          if empty?
            :nil
          else
            :list
          end
        end

        def __erlang_evolve__
          case __erlang_type__
          when :nil
            ETF::Nil.new
          when :list
            ETF::List.new(map(&:__erlang_evolve__))
          end
        end

      end
    end
  end
end
