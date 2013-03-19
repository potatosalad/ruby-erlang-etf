module Erlang
  module ETF
    module Term

      class << self

        # Extends the including class with +ClassMethods+.
        #
        # @param [Class] subclass the inheriting class
        def included(base)
          super

          base.send(:include, ::Binary::Protocol)
          base.extend ClassMethods
        end

        private :included
      end

      BERT_PREFIX = "bert".freeze

      BIN_LSB_PACK = 'b*'.freeze
      BIN_MSB_PACK = 'B*'.freeze

      module ClassMethods

        def term(name, options = {})
          if options.key?(:always)
            __define_always__(name, options[:always])
          else
            if options.key?(:default)
              __define_default__(name, options[:default])
            else
              attr_accessor name
            end

            if options[:type] == :array
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def deserialize_#{name}(buffer)
                  raise NotImplementedError
                end
              RUBY
            else
              class_eval <<-RUBY, __FILE__, __LINE__ + 1
                def deserialize_#{name}(buffer)
                  self.#{name} = Terms.deserialize(buffer)
                end
              RUBY
            end
          end

          if options[:type] == :array
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def serialize_#{name}(buffer)
                #{name}.each do |term|
                  term.serialize(buffer)
                end
              end
            RUBY
          else
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def serialize_#{name}(buffer)
                #{name}.serialize(buffer)
              end
            RUBY
          end

          serialization << :"serialize_#{name}"
          fields << name
        end

      end

      def ==(other)
        self.class === other &&
        self.class.fields.all? do |field|
          __send__(field) == other.__send__(field)
        end
      end

      def __erlang_type__
        word = self.class.name.split('::').last.dup
        word.gsub!('::', '/')
        word.gsub!(/(?:([A-Za-z\d])|^)(UTF8)(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word.intern
      end

      def __erlang_evolve__
        self
      end

      def __ruby_evolve__
        self
      end
    end
  end
end