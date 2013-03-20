module Erlang
  module ETF
    module Extensions

      module Symbol

        def __erlang_type__
          if to_s.bytesize < 256
            if to_s.ascii_only?
              :small_atom
            else
              :small_atom_utf8
            end
          else
            if to_s.ascii_only?
              :atom
            else
              :atom_utf8
            end
          end
        end

        def __erlang_evolve__
          case __erlang_type__
          when :atom
            ETF::Atom.new(to_s)
          when :atom_utf8
            ETF::AtomUTF8.new(to_s)
          when :small_atom
            ETF::SmallAtom.new(to_s)
          when :small_atom_utf8
            ETF::SmallAtomUTF8.new(to_s)
          end
        end

        def to_utf8_binary
          to_s.to_utf8_binary
        end

      end
    end
  end
end
