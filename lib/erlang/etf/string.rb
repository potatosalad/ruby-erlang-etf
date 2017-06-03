module Erlang
  module ETF

    #
    # | 1   | 2   | Len        |
    # | --- | --- | ---------- |
    # | 107 | Len | Characters |
    #
    # String does NOT have a corresponding Erlang representation, but
    # is an optimization for sending lists of bytes (integer in the
    # range 0-255) more efficiently over the distribution. Since the
    # Length field is an unsigned 2 byte integer (big endian),
    # implementations must make sure that lists longer than 65535
    # elements are encoded as [`LIST_EXT`].
    #
    # (see [`STRING_EXT`])
    #
    # [`LIST_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#LIST_EXT
    # [`STRING_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#STRING_EXT
    #
    class String
      include Erlang::ETF::Term

      UINT16BE = Erlang::ETF::Term::UINT16BE

      class << self
        def [](term)
          return new(term)
        end

        def erlang_load(buffer)
          size, = buffer.read(2).unpack(UINT16BE)
          data = buffer.read(size)
          return new(Erlang::String[data])
        end
      end

      def initialize(term)
        raise ArgumentError, "term must be of type Erlang::String" if not term.kind_of?(Erlang::String)
        @term = term
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << STRING_EXT
        buffer << [@term.size].pack(UINT16BE)
        buffer << Erlang::ETF::Term.binary_encoding(@term.data)
        return buffer
      end
    end
  end
end
