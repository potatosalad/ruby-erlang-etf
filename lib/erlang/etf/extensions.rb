require "erlang/etf/extensions/object"

module Erlang
  module ETF
    module Extensions

      # @private
      class ::Object
        extend  Erlang::ETF::Extensions::Object::ClassMethods
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
        extend  Erlang::ETF::Extensions::ErlangExport::ClassMethods
        include Erlang::ETF::Extensions::ErlangExport
      end

      # @private
      class ::Erlang::List
        extend  Erlang::ETF::Extensions::ErlangList::ClassMethods
        include Erlang::ETF::Extensions::ErlangList
      end

      # @private
      class ::Erlang::Nil
        extend  Erlang::ETF::Extensions::ErlangNil::ClassMethods
        include Erlang::ETF::Extensions::ErlangNil
      end

      # @private
      class ::Erlang::Pid
        extend  Erlang::ETF::Extensions::ErlangPid::ClassMethods
        include Erlang::ETF::Extensions::ErlangPid
      end

      # @private
      class ::Erlang::String
        extend  Erlang::ETF::Extensions::ErlangString::ClassMethods
        include Erlang::ETF::Extensions::ErlangString
      end

      # @private
      class ::Erlang::Tuple
        extend  Erlang::ETF::Extensions::ErlangTuple::ClassMethods
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
        extend  Erlang::ETF::Extensions::Array::ClassMethods
        include Erlang::ETF::Extensions::Array
      end

      # @private
      class ::BigDecimal
        extend  Erlang::ETF::Extensions::BigDecimal::ClassMethods
        include Erlang::ETF::Extensions::BigDecimal
      end

      # @private
      class ::FalseClass
        extend  Erlang::ETF::Extensions::FalseClass::ClassMethods
        include Erlang::ETF::Extensions::FalseClass
      end

      # @private
      class ::Float
        extend  Erlang::ETF::Extensions::Float::ClassMethods
        include Erlang::ETF::Extensions::Float
      end

      # @private
      class ::Hash
        extend  Erlang::ETF::Extensions::Hash::ClassMethods
        include Erlang::ETF::Extensions::Hash
      end

      # @private
      class ::Integer
        extend  Erlang::ETF::Extensions::Integer::ClassMethods
        include Erlang::ETF::Extensions::Integer
      end

      # @private
      class ::NilClass
        extend  Erlang::ETF::Extensions::NilClass::ClassMethods
        include Erlang::ETF::Extensions::NilClass
      end

      # @private
      class ::Regexp
        extend  Erlang::ETF::Extensions::Regexp::ClassMethods
        include Erlang::ETF::Extensions::Regexp
      end

      # @private
      class ::String
        extend  Erlang::ETF::Extensions::String::ClassMethods
        include Erlang::ETF::Extensions::String
      end

      # @private
      class ::Symbol
        extend  Erlang::ETF::Extensions::Symbol::ClassMethods
        include Erlang::ETF::Extensions::Symbol
      end

      # @private
      class ::Time
        extend  Erlang::ETF::Extensions::Time::ClassMethods
        include Erlang::ETF::Extensions::Time
      end

      # @private
      class ::TrueClass
        extend  Erlang::ETF::Extensions::TrueClass::ClassMethods
        include Erlang::ETF::Extensions::TrueClass
      end

    end
  end
end
