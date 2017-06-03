require 'test_helper'

class Erlang::ETFTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Erlang::ETF::VERSION
  end

  def test_binary_to_term_with_unknown_tag
    assert_raises(NotImplementedError) { Erlang::ETF.binary_to_term(StringIO.new([131,82].pack('C*')), false) }
  end

  def test_binary_to_term
    assert_equal 0, Erlang::ETF.binary_to_term(StringIO.new([131,97,0].pack('C*')), false)
    assert_equal Erlang::ETF::SmallInteger[0], Erlang::ETF.binary_to_term(StringIO.new([131,97,0].pack('C*')), true)
    assert_raises(NotImplementedError) { Erlang::ETF.binary_to_term(StringIO.new(""), false) }
  end

  # def test_term_to_binary_with_unknown_term
  #   assert_raises(NotImplementedError) { Erlang::ETF.term_to_binary(Object.new, String.new, false) }
  # end

  def test_read_term_with_unknown_tag
    assert_raises(NotImplementedError) { Erlang::ETF.read_term(StringIO.new([82].pack('C*'))) }
  end

  def test_read_term
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
