module Erlang
  module ETF

    #
    # | 1   | 31           |
    # | --- | ------------ |
    # | 99  | Float String |
    #
    # A float is stored in string format. the format used in sprintf
    # to format the float is "%.20e" (there are more bytes allocated
    # than necessary). To unpack the float use sscanf with format
    # "%lf".
    #
    # This term is used in minor version 0 of the external format; it
    # has been superseded by [`NEW_FLOAT_EXT`].
    #
    # (see [`FLOAT_EXT`])
    #
    # [`NEW_FLOAT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#NEW_FLOAT_EXT
    # [`FLOAT_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#FLOAT_EXT
    #
    class Float
      include Erlang::ETF::Term

      class << self
        def [](term, float_string = nil)
          return term if term.kind_of?(Erlang::ETF::Term)
          term = Erlang.from(term)
          return new(term, float_string)
        end

        def erlang_load(buffer)
          float_string = buffer.read(31)
          term = Erlang::Float[float_string.byteslice(0, float_string.index("\0")), old: true]
          return new(term, float_string)
        end
      end

      def initialize(term, float_string = nil)
        raise ArgumentError, "term must be of type Erlang::Float" if not Erlang.is_float(term) or not term.old
        @term         = term
        @float_string = float_string
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << FLOAT_EXT
        buffer << (@float_string || to_float_string)
        return buffer
      end

      def inspect
        if @float_string.nil?
          return "#{self.class}[#{@term.inspect}]"
        else
          return "#{self.class}[#{@term.inspect}, #{@float_string.inspect}]"
        end
      end

    private
      def to_float_string
        return @term.to_float_string.ljust(31, "\0")
      end

    end
  end
end
