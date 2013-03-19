require 'erlang/list'

module Erlang
  module ETF
    module Extensions

      module ErlangList

        def __erlang_type__
          if empty? and not improper?
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
            ETF::List.new(map(&:__erlang_evolve__), tail.__erlang_evolve__)
          end
        end

        module ClassMethods
        end
      end
    end
  end
end
