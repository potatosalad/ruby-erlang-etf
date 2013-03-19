require 'erlang/tuple'

module Erlang
  module ETF
    module Extensions

      module ErlangTuple

        def __erlang_type__
          if length < 256
            :small_tuple
          else
            :large_tuple
          end
        end

        def __erlang_evolve__
          case __erlang_type__
          when :small_tuple
            ETF::SmallTuple.new(map(&:__erlang_evolve__))
          when :large_tuple
            ETF::LargeTuple.new(map(&:__erlang_evolve__))
          end
        end

        module ClassMethods
        end
      end
    end
  end
end
