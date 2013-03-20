require "erlang/etf/extensions/object"

module Erlang
  module ETF
    module Extensions

      # @private
      class ::Object
        include Erlang::ETF::Extensions::Object
      end
    end
  end
end

require "erlang/etf/extensions/erlang-export"
require "erlang/etf/extensions/erlang-list"
require "erlang/etf/extensions/erlang-nil"
require "erlang/etf/extensions/erlang-pid"
require "erlang/etf/extensions/erlang-string"
require "erlang/etf/extensions/erlang-tuple"

module Erlang
  module ETF
    module Extensions

      # @private
      class ::Erlang::Export
        include Erlang::ETF::Extensions::ErlangExport
      end

      # @private
      class ::Erlang::List
        include Erlang::ETF::Extensions::ErlangList
      end

      # @private
      class ::Erlang::Nil
        include Erlang::ETF::Extensions::ErlangNil
      end

      # @private
      class ::Erlang::Pid
        include Erlang::ETF::Extensions::ErlangPid
      end

      # @private
      class ::Erlang::String
        include Erlang::ETF::Extensions::ErlangString
      end

      # @private
      class ::Erlang::Tuple
        include Erlang::ETF::Extensions::ErlangTuple
      end
    end
  end
end

require "erlang/etf/extensions/array"
require "erlang/etf/extensions/big_decimal"
require "erlang/etf/extensions/false_class"
require "erlang/etf/extensions/float"
require "erlang/etf/extensions/hash"
require "erlang/etf/extensions/integer"
require "erlang/etf/extensions/nil_class"
require "erlang/etf/extensions/regexp"
require "erlang/etf/extensions/string"
require "erlang/etf/extensions/symbol"
require "erlang/etf/extensions/time"
require "erlang/etf/extensions/true_class"

module Erlang
  module ETF
    module Extensions

      # @private
      class ::Array
        include Erlang::ETF::Extensions::Array
      end

      # @private
      class ::BigDecimal
        include Erlang::ETF::Extensions::BigDecimal
      end

      # @private
      class ::FalseClass
        include Erlang::ETF::Extensions::FalseClass
      end

      # @private
      class ::Float
        include Erlang::ETF::Extensions::Float
      end

      # @private
      class ::Hash
        include Erlang::ETF::Extensions::Hash
      end

      # @private
      class ::Integer
        include Erlang::ETF::Extensions::Integer
      end

      # @private
      class ::NilClass
        include Erlang::ETF::Extensions::NilClass
      end

      # @private
      class ::Regexp
        include Erlang::ETF::Extensions::Regexp
      end

      # @private
      class ::String
        include Erlang::ETF::Extensions::String
      end

      # @private
      class ::Symbol
        include Erlang::ETF::Extensions::Symbol
      end

      # @private
      class ::Time
        include Erlang::ETF::Extensions::Time
      end

      # @private
      class ::TrueClass
        include Erlang::ETF::Extensions::TrueClass
      end

    end
  end
end
