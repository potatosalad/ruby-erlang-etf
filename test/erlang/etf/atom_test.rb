# encoding: utf-8

require 'test_helper'

class Erlang::ETF::AtomTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::Atom.erlang_load(StringIO.new([0,4,116,101,115,116].pack('C*')))
    assert_equal Erlang.from(:test), etf.term
    etf = Erlang::ETF::Atom.erlang_load(StringIO.new([0,2,206,169].pack('C*')))
    assert_equal Erlang.from(:Ω), etf.term
  end

  def test_new
    etf = Erlang::ETF::Atom[Erlang::Atom['test']]
    assert_equal Erlang.from(:test), etf.term
    etf = Erlang::ETF::Atom[Erlang::Atom['Ω']]
    assert_equal Erlang.from(:Ω), etf.term
    assert_equal Erlang.from(:Ω).hash, etf.hash
    assert etf.eql?(Erlang.from(:Ω))
  end

  def test_erlang_dump
    binary = Erlang::ETF::Atom[Erlang::Atom['test']].erlang_dump
    assert_equal [100,0,4,116,101,115,116].pack('C*'), binary
    binary = Erlang::ETF::Atom[Erlang::Atom['Ω']].erlang_dump
    assert_equal [100,0,2,206,169].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Atom[Erlang::Atom['test']]
    assert_equal :atom, etf.erlang_external_type
  end

  def test_to_erlang
    term = Erlang::ETF::Atom[Erlang::Atom['test']]
    assert_equal Erlang.from(:test), term.to_erlang
    term = Erlang::ETF::Atom[Erlang::Atom['Ω']]
    assert_equal Erlang.from(:Ω), term.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(0, 255)
      sized(len) {
        Erlang::ETF::Atom[Erlang::Atom[random_string(len)]]
      }
    }.check { |term|
      assert_equal term, eval(term.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      len = range(0, 255)
      sized(len) {
        Erlang::ETF::Atom[Erlang::Atom[random_string(len)]]
      }
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::Atom.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
