# encoding: utf-8

require 'test_helper'

class Erlang::ETF::ListTest < Minitest::Test

  def test_erlang_load
    # Empty proper list
    etf = Erlang::ETF::List.erlang_load(StringIO.new([0,0,0,0,106].pack('C*')))
    assert_equal Erlang.from(Erlang::List[]), etf.term
    # Empty improper list
    etf = Erlang::ETF::List.erlang_load(StringIO.new([0,0,0,0,100,0,1,97].pack('C*')))
    assert_equal Erlang.from(:a), etf.term
    # 1-element proper list
    etf = Erlang::ETF::List.erlang_load(StringIO.new([0,0,0,1,100,0,1,97,106].pack('C*')))
    assert_equal Erlang.from([:a]), etf.term
    # 1-element improper list
    etf = Erlang::ETF::List.erlang_load(StringIO.new([0,0,0,1,100,0,1,97,97,1].pack('C*')))
    assert_equal Erlang.from(Erlang::List[:a] + 1), etf.term
    # 6-element proper list
    etf = Erlang::ETF::List.erlang_load(StringIO.new([0,0,0,6,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,104,5,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,106].pack('C*')))
    small_list = Erlang::List[:test, "test", 1.1, 13]
    small_tuple = Erlang::Tuple[:test, "test", 1.1, 13, small_list]
    list = Erlang::List[:test, "test", 1.1, 13, small_tuple, small_list]
    assert_equal Erlang.from(list), etf.term
  end

  def test_new
    # Empty proper list
    etf = Erlang::ETF::List[Erlang::List[]]
    assert_equal Erlang.from(Erlang::List[]), etf.term
    # Empty improper list
    etf = Erlang::ETF::List[Erlang::List[] + :a]
    assert_equal Erlang.from(:a), etf.term
    # 1-element proper list
    etf = Erlang::ETF::List[Erlang::List[:a]]
    assert_equal Erlang.from([:a]), etf.term
    # 1-element improper list
    etf = Erlang::ETF::List[Erlang::List[:a] + 1]
    assert_equal Erlang.from(Erlang::List[:a] + 1), etf.term
    # 6-element proper list
    small_list = Erlang::List[:test, "test", 1.1, 13]
    small_tuple = Erlang::Tuple[:test, "test", 1.1, 13, small_list]
    list = Erlang::List[:test, "test", 1.1, 13, small_tuple, small_list]
    etf = Erlang::ETF::List[list]
    assert_equal Erlang.from(list), etf.term
  end

  def test_erlang_dump
    # Empty proper list
    binary = Erlang::ETF::List[Erlang::List[]].erlang_dump
    assert_equal [108,0,0,0,0,106].pack('C*'), binary
    # Empty improper list
    binary = Erlang::ETF::List[Erlang::Atom[:a], [], Erlang::ETF::Atom[Erlang::Atom[:a]]].erlang_dump
    assert_equal [108,0,0,0,0,100,0,1,97].pack('C*'), binary
    # 1-element proper list
    binary = Erlang::ETF::List[Erlang::List[:a], [Erlang::ETF::Atom[Erlang::Atom[:a]]], Erlang::ETF::Nil[Erlang::Nil]].erlang_dump
    assert_equal [108,0,0,0,1,100,0,1,97,106].pack('C*'), binary
    # 1-element improper list
    binary = Erlang::ETF::List[Erlang::List[:a] + 1, [Erlang::ETF::Atom[Erlang::Atom[:a]]], Erlang::ETF::SmallInteger[1]].erlang_dump
    assert_equal [108,0,0,0,1,100,0,1,97,97,1].pack('C*'), binary
    # 6-element proper list
    small_list = Erlang::List[:test, "test", 1.1, 13]
    small_tuple = Erlang::Tuple[:test, "test", 1.1, 13, small_list]
    list = Erlang::List[:test, "test", 1.1, 13, small_tuple, small_list]
    binary = Erlang::ETF::List[list].erlang_dump
    assert_equal [108,0,0,0,6,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,104,5,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,106].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::List[Erlang::List[]]
    assert_equal :list, etf.erlang_external_type
  end

  def test_to_erlang
    # Empty proper list
    etf = Erlang::ETF::List[Erlang::List[]]
    assert_equal Erlang.from(Erlang::List[]), etf.to_erlang
    # Empty improper list
    etf = Erlang::ETF::List[Erlang::List[] + :a]
    assert_equal Erlang.from(:a), etf.to_erlang
    # 1-element proper list
    etf = Erlang::ETF::List[Erlang::List[:a]]
    assert_equal Erlang.from([:a]), etf.to_erlang
    # 1-element improper list
    etf = Erlang::ETF::List[Erlang::List[:a] + 1]
    assert_equal Erlang.from(Erlang::List[:a] + 1), etf.to_erlang
    # 6-element proper list
    small_list = Erlang::List[:test, "test", 1.1, 13]
    small_tuple = Erlang::Tuple[:test, "test", 1.1, 13, small_list]
    list = Erlang::List[:test, "test", 1.1, 13, small_tuple, small_list]
    etf = Erlang::ETF::List[list]
    assert_equal Erlang.from(list), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      etf0 = random_erlang_etf_list(strict: true)
      etf1 = Erlang::ETF::List[etf0.term]
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
      etf0 = random_erlang_etf_list(strict: true)
      etf1 = Erlang::ETF::List[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      term = Erlang.from(etf0)
      binary = etf0.erlang_dump
      assert_equal etf0, Erlang::ETF::List.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
      term = Erlang.from(etf1)
      binary = etf1.erlang_dump
      assert_equal etf1, Erlang::ETF::List.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
    }
  end

end
