# encoding: utf-8

require 'test_helper'

class Erlang::ETF::TermsTest < Minitest::Test

  # def test_deserialize_with_unknown_tag
  #   assert_raises(NotImplementedError) { Erlang::ETF::Terms.deserialize(StringIO.new([82].pack('C*'))) }
  # end

  # def test_evolve_with_unknown_tag
  #   assert_raises(NotImplementedError) { Erlang::ETF::Terms.evolve(StringIO.new([82].pack('C*'))) }
  # end

  def test_roundtrip
    terms = Rantly {
      [
        erlang_etf_atom,
        erlang_etf_atom_utf8,
        erlang_etf_binary,
        erlang_etf_bit_binary,
        erlang_etf_export,
        erlang_etf_export { [random_erlang_etf_atom, random_erlang_etf_atom, erlang_etf_small_integer] },
        erlang_etf_float,
        erlang_etf_integer,
        erlang_etf_large_big,
        erlang_etf_large_tuple,
        erlang_etf_large_tuple { erlang_etf_nil },
        erlang_etf_list,
        erlang_etf_list { erlang_etf_nil },
        erlang_etf_list_improper,
        erlang_etf_list_improper { erlang_etf_nil },
        erlang_etf_list_improper(size, 0, -> { erlang_etf_nil }) { erlang_etf_nil },
        erlang_etf_map,
        erlang_etf_map { [erlang_etf_nil, erlang_etf_nil] },
        erlang_etf_new_float,
        erlang_etf_new_reference,
        erlang_etf_new_reference { [random_erlang_etf_atom, 1, [1]] },
        erlang_etf_nil,
        erlang_etf_pid,
        erlang_etf_pid { [random_erlang_etf_atom, 1, 1, 1] },
        erlang_etf_port,
        erlang_etf_port { [random_erlang_etf_atom, 1, 1] },
        erlang_etf_reference,
        erlang_etf_reference { [random_erlang_etf_atom, 1, 1] },
        erlang_etf_small_atom,
        erlang_etf_small_atom_utf8,
        erlang_etf_small_big,
        erlang_etf_small_integer,
        erlang_etf_small_tuple,
        erlang_etf_small_tuple { erlang_etf_nil },
        erlang_etf_string,
        random_erlang_etf_atom,
        random_erlang_etf_bitstring,
        random_erlang_etf_integer,
        random_erlang_etf_list,
        random_erlang_etf_tuple,
        random_erlang_etf_term
      ]
    }
    terms.each do |term|
      binary = term.erlang_dump
      assert_equal term, Erlang::ETF.read_term(StringIO.new(binary))
    end
    # Force certain parts of Rantly extensions to run for 100% test coverage
    Rantly { random_little_endian_string(2, "\x00".force_encoding('BINARY')) }
    Rantly { random_string(2) }
    Rantly { utf8_string(10, "\xCD".force_encoding('UTF-8')) }
  end

end
