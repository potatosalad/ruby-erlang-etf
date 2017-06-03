module Erlang
  module ETF

    #
    # | 1   | N    | 4   | 4      | 1        |
    # | --- | ---- | --- | ------ | -------- |
    # | 103 | Node | ID  | Serial | Creation |
    #
    # Encode a process identifier object (obtained from [`spawn/3`] or
    # friends). The `ID` and `Creation` fields works just like in
    # [`REFERENCE_EXT`], while the `Serial` field is used to improve safety.
    # In `ID`, only 15 bits are significant; the rest should be 0.
    #
    # (see [`PID_EXT`])
    #
    # [`spawn/3`]: http://erlang.org/doc/man/erlang.html#spawn-3
    # [`REFERENCE_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#REFERENCE_EXT
    # [`PID_EXT`]: http://erlang.org/doc/apps/erts/erl_ext_dist.html#PID_EXT
    #
    class Pid
      include Erlang::ETF::Term

      UINT8    = Erlang::ETF::Term::UINT8
      UINT32BE = Erlang::ETF::Term::UINT32BE
      HEAD     = (UINT32BE + UINT32BE + UINT8).freeze

      class << self
        def [](term, node = nil, id = nil, serial = nil, creation = nil)
          return new(term, node, id, serial, creation)
        end

        def erlang_load(buffer)
          node = Erlang::ETF.read_term(buffer)
          id, serial, creation = buffer.read(9).unpack(HEAD)
          term = Erlang::Pid[Erlang.from(node), Erlang.from(id), Erlang.from(serial), Erlang.from(creation)]
          return new(term, node, id, serial, creation)
        end
      end

      def initialize(term, node = nil, id = nil, serial = nil, creation = nil)
        raise ArgumentError, "term must be of type Erlang::Pid" if not term.kind_of?(Erlang::Pid)
        @term     = term
        @node     = node
        @id       = id
        @serial   = serial
        @creation = creation
      end

      def erlang_dump(buffer = ::String.new.force_encoding(BINARY_ENCODING))
        buffer << PID_EXT
        Erlang::ETF.write_term(@node || @term.node, buffer)
        buffer << [
          @id       || @term.id,
          @serial   || @term.serial,
          @creation || @term.creation
        ].pack(HEAD)
        return buffer
      end

      def inspect
        if @node.nil? and @id.nil? and @serial.nil? and @creation.nil?
          return super
        else
          return "#{self.class}[#{@term.inspect}, #{@node.inspect}, #{@id.inspect}, #{@serial.inspect}, #{@creation.inspect}]"
        end
      end

      def pretty_print(pp)
        state = [@term]
        state.push(@node, @id, @serial, @creation) if not @node.nil? or not @id.nil? or not @serial.nil? or not @creation.nil?
        return pp.group(1, "#{self.class}[", "]") do
          pp.breakable ''
          pp.seplist(state) { |obj| obj.pretty_print(pp) }
        end
      end
    end
  end
end
