require 'erlang/string'

module Erlang
  module ETF
    module Extensions

      module ErlangString

        STRING_MAX = (+1 << 16) - 1

        def __erlang_type__
          if bytesize > STRING_MAX
            :list
          else
            :string
          end
        end

        def __erlang_evolve__
          case __erlang_type__
          when :list
            ETF::List.new(unpack('C*'))
          when :string
            ETF::String.new(self)
          end
        end

      end
    end
  end
end
