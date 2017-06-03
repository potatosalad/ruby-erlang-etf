module Erlang
  module ETF

    #
    # | 1   | 4     | N     |
    # | --- | ----- | ----- |
    # | 116 | Arity | Pairs |
    #
    # `MAP_EXT` encodes a map. The `Arity` field is an unsigned 4 byte integer
    # in big endian format that determines the number of key-value pairs in the
    # map. Key and value pairs (`Ki => Vi`) are encoded in the `Pairs` section
    # in the following order: `K1, V1, K2, V2,..., Kn, Vn`. Duplicate keys are
    # **not allowed** within the same map.
    #
    # (see [`MAP_EXT`])
    #
    # [`MAP_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#MAP_EXT
    #
    class Map
      include Erlang::ETF::Term

      UINT32BE = Erlang::ETF::Term::UINT32BE

      class << self
        def [](term, pairs = nil)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term, pairs)
        end

        def erlang_load(buffer)
          arity, = buffer.read(4).unpack(UINT32BE)
          pairs = Array.new(arity * 2)
          (arity * 2).times { |i| pairs[i] = Erlang::ETF.read_term(buffer) }
          map = Erlang::Map[*pairs]
          return new(map, pairs)
        end
      end

      def initialize(term, pairs = nil)
        raise ArgumentError, "term must be of type Map" if not Erlang.is_map(term)
        @term = term
        @pairs = pairs.freeze
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << MAP_EXT
        if @pairs
          arity = @pairs.length.div(2)
          buffer << [arity].pack(UINT32BE)
          (arity * 2).times { |i| Erlang::ETF.write_term(@pairs[i], buffer) }
        else
          arity = @term.size
          buffer << [arity].pack(UINT32BE)
          @term.sort.each { |key, val|
            Erlang::ETF.write_term(key, buffer)
            Erlang::ETF.write_term(val, buffer)
          }
        end
        return buffer
      end

      def inspect
        if @pairs.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@pairs.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@pairs) if not @pairs.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
