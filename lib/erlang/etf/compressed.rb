require 'zlib'

module Erlang
  module ETF

    #
    # | 1   | 4                | N                   |
    # | --- | ---------------- | ------------------- |
    # | 80  | UncompressedSize | Zlib-compressedData |
    #
    # Uncompressed Size (unsigned 32 bit integer in big-endian
    # byte order) is the size of the data before it was compressed.
    # The compressed data has the following format when it has been expanded:
    #
    # | 1    | Uncompressed Size |
    # | ---- | ----------------- |
    # | Tag  | Data              |
    #
    # (see [`External Term Format`] and [`term_to_binary/2`])
    #
    # [`External Term Format`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#overall_format
    # [`term_to_binary/2`]: http://www.erlang.org/doc/man/erlang.html#term_to_binary-2
    #
    class Compressed
      include Erlang::ETF::Term

      LEVEL_RANGE   = (0..9).freeze
      LEVEL_DEFAULT = 6.freeze

      UINT32BE = Erlang::ETF::Term::UINT32BE

      class << self
        def [](term, uncompressed_size = nil, compressed_data = nil, level: LEVEL_DEFAULT)
          term = Erlang.from(term)
          return new(term, uncompressed_size, compressed_data, level)
        end

        def erlang_load(buffer)
          uncompressed_size, = buffer.read(4).unpack(UINT32BE)
          compressed_data = buffer.read()
          uncompressed_data = ::Zlib::Inflate.inflate(compressed_data)
          if uncompressed_size == uncompressed_data.bytesize
            term = Erlang.from(Erlang::ETF.read_term(StringIO.new(uncompressed_data)))
            return new(term, uncompressed_size, compressed_data)
          else
            raise ::Zlib::DataError, "UncompressedSize value did not match the size of the uncompressed data"
          end
        end
      end

      def initialize(term, uncompressed_size = nil, compressed_data = nil, level = LEVEL_DEFAULT)
        raise ArgumentError, "term must be of any type" if not Erlang.is_any(term)
        @term = term
        @uncompressed_size = uncompressed_size
        @compressed_data = compressed_data
        @level = LEVEL_RANGE.include?(level) ? level : LEVEL_DEFAULT
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << COMPRESSED
        if @uncompressed_size.nil? and @compressed_data.nil?
          uncompressed_data = Erlang::ETF.write_term(@term, ::String.new.force_encoding(BINARY_ENCODING))
          uncompressed_size = uncompressed_data.bytesize
          compressed_data = ::Zlib::Deflate.deflate(uncompressed_data, @level)
          buffer << [uncompressed_size].pack(UINT32BE)
          buffer << Erlang::ETF::Term.binary_encoding(compressed_data)
        else
          buffer << [@uncompressed_size].pack(UINT32BE)
          buffer << Erlang::ETF::Term.binary_encoding(@compressed_data)
        end
        return buffer
      end

      def inspect
        if @uncompressed_size.nil? and @compressed_data.nil?
          return "#{self.class}[#{@term.inspect}, level: #{@level.inspect}]"
        else
          return "#{self.class}[#{@term.inspect}, #{@uncompressed_size.inspect}, #{@compressed_data.inspect}, level: #{@level.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@uncompressed_size, @compressed_data) if not @uncompressed_size.nil? or not @compressed_data.nil?
        return pp.group(1, "#{self.class}[", ", level: #{@level.inspect}]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
