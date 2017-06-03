# encoding: utf-8

require 'test_helper'

class Erlang::ETF::LargeTupleTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::LargeTuple.erlang_load(StringIO.new([0,0,0,0].pack('C*')))
    assert_equal Erlang.from(Erlang::Tuple[]), etf.term
    etf = Erlang::ETF::LargeTuple.erlang_load(StringIO.new([0,0,0,1,100,0,1,97].pack('C*')))
    assert_equal Erlang.from(Erlang::Tuple[:a]), etf.term
    etf = Erlang::ETF::LargeTuple.erlang_load(StringIO.new([0,0,0,6,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,104,5,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106].pack('C*')))
    assert_equal Erlang.from(fairly_complex_tuple), etf.term
    etf = Erlang::ETF::LargeTuple.erlang_load(StringIO.new([0,0,1,0,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106].pack('C*')))
    assert_equal Erlang.from(Erlang::Tuple[*([Erlang::Nil] * 256)]), etf.term
  end

  def test_new
    etf = Erlang::ETF::LargeTuple[Erlang::Tuple[]]
    assert_equal Erlang.from(Erlang::Tuple[]), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::LargeTuple[Erlang::Tuple[]].erlang_dump
    assert_equal [105,0,0,0,0].pack('C*'), binary
    binary = Erlang::ETF::LargeTuple[Erlang::Tuple[:a], [Erlang::ETF::Atom[Erlang::Atom[:a]]]].erlang_dump
    assert_equal [105,0,0,0,1,100,0,1,97].pack('C*'), binary
    binary = fairly_complex_tuple(strict: true).erlang_dump
    assert_equal [105,0,0,0,6,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,104,5,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106].pack('C*'), binary
    binary = Erlang::ETF::LargeTuple[Erlang::Tuple[*([Erlang::Nil] * 256)]].erlang_dump
    assert_equal [105,0,0,1,0,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::LargeTuple[Erlang::Tuple[]]
    assert_equal :large_tuple, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::LargeTuple[Erlang::Tuple[]]
    assert_equal Erlang.from(Erlang::Tuple[]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      etf0 = erlang_etf_large_tuple(arity: size, strict: true)
      etf1 = Erlang::ETF::LargeTuple[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      assert_equal etf0, eval(etf0.inspect)
      assert_equal etf0, eval(etf0.pretty_inspect)
      assert_equal etf1, eval(etf1.inspect)
      assert_equal etf1, eval(etf1.pretty_inspect)
    }
  end

  def test_property_of_etf
    property_of {
      etf0 = erlang_etf_large_tuple(arity: size, strict: true)
      etf1 = Erlang::ETF::LargeTuple[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      term = Erlang.from(etf0)
      binary = etf0.erlang_dump
      assert_equal etf0, Erlang::ETF::LargeTuple.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
      term = Erlang.from(etf1)
      binary = etf1.erlang_dump
      assert_equal etf1, Erlang::ETF::LargeTuple.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
    }
  end

private
  def fairly_complex_tuple(strict: false)
    small_list = Erlang::List[:test, "test", 1.1, 13]
    small_tuple = Erlang::Tuple[:test, "test", 1.1, 13, small_list]
    tuple = Erlang::Tuple[:test, "test", 1.1, 13, small_tuple, small_list]
    return Erlang::ETF::LargeTuple[tuple] if strict == false
    strict_small_list = Erlang::ETF::List[small_list, [
      Erlang::ETF::SmallAtom[Erlang::Atom[:test]],
      Erlang::ETF::Binary[Erlang::Binary["test"]],
      Erlang::ETF::NewFloat[1.1],
      Erlang::ETF::SmallInteger[13]
    ]]
    strict_small_tuple = Erlang::ETF::SmallTuple[small_tuple, [
      Erlang::ETF::SmallAtom[Erlang::Atom[:test]],
      Erlang::ETF::Binary[Erlang::Binary["test"]],
      Erlang::ETF::NewFloat[1.1],
      Erlang::ETF::SmallInteger[13],
      strict_small_list
    ]]
    strict_tuple = Erlang::ETF::LargeTuple[tuple, [
      Erlang::ETF::SmallAtom[Erlang::Atom[:test]],
      Erlang::ETF::Binary[Erlang::Binary["test"]],
      Erlang::ETF::NewFloat[1.1],
      Erlang::ETF::SmallInteger[13],
      strict_small_tuple,
      strict_small_list
    ]]
    return strict_tuple
  end
end
