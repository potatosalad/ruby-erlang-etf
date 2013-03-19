module Erlang
  module ETF
    module BERT
      extend self

      def evolve(tuple)
        if tuple.elements[1].respond_to?(:atom_name)
          case tuple.elements[1].atom_name.to_s.intern
          ## boolean ##
          when :false
            false
          when :true
            true

          ## dict ##
          when :dict
            if tuple.elements[2].respond_to?(:__ruby_evolve__) and
              ((list = tuple.elements[2].__ruby_evolve__).is_a?(::Erlang::List) or (list.respond_to?(:empty?) and list.empty?))
              list.inject({}) do |hash, (key, value)|
                hash[key] = value
                hash
              end
            else
              unknown(tuple)
            end

          ## nil ##
          when :nil
            nil

          ## regex ##
          when :regex
            if tuple.elements[2].is_a?(Erlang::ETF::Binary) and
              (tuple.elements[3].is_a?(Erlang::ETF::List) or tuple.elements[3].is_a?(Erlang::ETF::Nil))
              
              source = tuple.elements[2].__ruby_evolve__
              opts   = tuple.elements[3].__ruby_evolve__

              options = 0
              options |= ::Regexp::EXTENDED   if opts.include?(:extended)
              options |= ::Regexp::IGNORECASE if opts.include?(:caseless)
              options |= ::Regexp::MULTILINE  if opts.include?(:multiline)
              ::Regexp.new(source, options)
            else
              unknown(tuple)
            end

          ## time ##
          when :time
            if tuple.arity == 5
              megaseconds  = tuple.elements[2].__ruby_evolve__
              seconds      = tuple.elements[3].__ruby_evolve__
              microseconds = tuple.elements[4].__ruby_evolve__

              Time.at(megaseconds * 1_000_000 + seconds, microseconds)
            else
              unknown(tuple)
            end

          else
            unknown(tuple)
          end
        else
          unknown(tuple)
        end
      end

      def unknown(tuple)
        ::Erlang::Tuple[*tuple.elements.map(&:__ruby_evolve__)]
      end

    end
  end
end
