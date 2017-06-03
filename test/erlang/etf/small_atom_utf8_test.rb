# encoding: utf-8

require 'test_helper'

class Erlang::ETF::SmallAtomUTF8Test < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::SmallAtomUTF8.erlang_load(StringIO.new([4,116,101,115,116].pack('C*')))
    assert_equal Erlang.from(Erlang::Atom[:test, utf8: true]), etf.term
    etf = Erlang::ETF::SmallAtomUTF8.erlang_load(StringIO.new([2,206,169].pack('C*')))
    assert_equal Erlang.from(Erlang::Atom[:Ω, utf8: true]), etf.term
  end

  def test_new
    etf = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['test', utf8: true]]
    assert_equal Erlang.from(Erlang::Atom[:test, utf8: true]), etf.term
    etf = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['Ω', utf8: true]]
    assert_equal Erlang.from(Erlang::Atom[:Ω, utf8: true]), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['test', utf8: true]].erlang_dump
    assert_equal [119,4,116,101,115,116].pack('C*'), binary
    binary = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['Ω', utf8: true]].erlang_dump
    assert_equal [119,2,206,169].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['test', utf8: true]]
    assert_equal :small_atom_utf8, etf.erlang_external_type
  end

  def test_to_erlang
    term = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['test', utf8: true]]
    assert_equal Erlang.from(Erlang::Atom[:test, utf8: true]), term.to_erlang
    term = Erlang::ETF::SmallAtomUTF8[Erlang::Atom['Ω', utf8: true]]
    assert_equal Erlang.from(Erlang::Atom[:Ω, utf8: true]), term.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(0, 255)
      sized(len) {
        Erlang::ETF::SmallAtomUTF8[Erlang::Atom[utf8_string(len), utf8: true]]
      }
    }.check { |term|
      assert_equal term, eval(term.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      len = range(0, 255)
      sized(len) {
        Erlang::ETF::SmallAtomUTF8[Erlang::Atom[utf8_string(len), utf8: true]]
      }
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::SmallAtomUTF8.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
