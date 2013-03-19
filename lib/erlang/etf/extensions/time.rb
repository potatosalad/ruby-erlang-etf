module Erlang
  module ETF
    module Extensions

      #
      # time {bert, time, Megaseconds, Seconds, Microseconds}
      #
      # The given time is the number of Megaseconds + Seconds + Microseconds elapsed since 00:00 GMT, January 1, 1970 (zero hour).
      # For example, 2009-10-11 at 14:12:01 and 446,228 microseconds would be expressed as {bert, time, 1255, 295581, 446228}.
      # In english, this is 1255 megaseconds (millions of seconds) + 295,581 seconds + 446,228 microseconds (millionths of a second) since zero hour.
      #
      # See: http://bert-rpc.org/
      #
      module Time

        def __erlang_type__
          :bert_time
        end

        def __erlang_evolve__
          ::Erlang::Tuple[:bert, :time, to_i / 1_000_000, to_i % 1_000_000, usec].__erlang_evolve__
        end

        module ClassMethods
        end
      end
    end
  end
end
