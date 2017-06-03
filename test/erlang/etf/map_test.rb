# encoding: utf-8

require 'test_helper'

class Erlang::ETF::MapTest < Minitest::Test

  def test_erlang_load
    # Empty map
    etf = Erlang::ETF::Map.erlang_load(StringIO.new([0,0,0,0].pack('C*')))
    assert_equal Erlang.from({}), etf.term
    # 1-keypair map
    etf = Erlang::ETF::Map.erlang_load(StringIO.new([0,0,0,1,106,106].pack('C*')))
    assert_equal Erlang.from({[] => []}), etf.term
    # 3-keypair map
    etf = Erlang::ETF::Map.erlang_load(StringIO.new([0,0,0,3,115,4,116,101,115,116,97,13,109,0,0,0,4,116,101,115,116,106,70,63,241,153,153,153,153,153,154,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106].pack('C*')))
    assert_equal Erlang.from({:test => 13, "test" => [], 1.1 => [:test, "test", 1.1, 13]}), etf.term
  end

  def test_new
    # Empty map
    etf = Erlang::ETF::Map[Erlang::Map[]]
    assert_equal Erlang.from({}), etf.term
    # 1-keypair map
    etf = Erlang::ETF::Map[Erlang::Map[Erlang::Nil, Erlang::Nil]]
    assert_equal Erlang.from({[] => []}), etf.term
    # 3-keypair map
    etf = Erlang::ETF::Map[Erlang::Map[:test, 13, "test", Erlang::Nil, 1.1, Erlang::List[:test, "test", 1.1, 13]]]
    assert_equal Erlang.from({:test => 13, "test" => [], 1.1 => [:test, "test", 1.1, 13]}), etf.term
  end

  def test_erlang_dump
    # Empty map
    binary = Erlang::ETF::Map[Erlang::Map[]].erlang_dump
    assert_equal [116,0,0,0,0].pack('C*'), binary
    # 1-keypair map
    binary = Erlang::ETF::Map[Erlang::Map[Erlang::Nil, Erlang::Nil]].erlang_dump
    assert_equal [116,0,0,0,1,106,106].pack('C*'), binary
    # 3-keypair map
    binary = Erlang::ETF::Map[Erlang::Map[:test, 13, "test", Erlang::Nil, 1.1, Erlang::List[:test, "test", 1.1, 13]]].erlang_dump
    assert_equal [116,0,0,0,3,70,63,241,153,153,153,153,153,154,108,0,0,0,4,115,4,116,101,115,116,109,0,0,0,4,116,101,115,116,70,63,241,153,153,153,153,153,154,97,13,106,115,4,116,101,115,116,97,13,109,0,0,0,4,116,101,115,116,106].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Map[Erlang::Map[]]
    assert_equal :map, etf.erlang_external_type
  end

  def test_to_erlang
    # Empty map
    etf = Erlang::ETF::Map[Erlang::Map[]]
    assert_equal Erlang.from({}), etf.to_erlang
    # 1-keypair map
    etf = Erlang::ETF::Map[Erlang::Map[Erlang::Nil, Erlang::Nil]]
    assert_equal Erlang.from({[] => []}), etf.to_erlang
    # 3-keypair map
    etf = Erlang::ETF::Map[Erlang::Map[:test, 13, "test", Erlang::Nil, 1.1, Erlang::List[:test, "test", 1.1, 13]]]
    assert_equal Erlang.from({:test => 13, "test" => [], 1.1 => [:test, "test", 1.1, 13]}), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      etf0 = erlang_etf_map(strict: true)
      etf1 = Erlang::ETF::Map[etf0.term]
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
      etf0 = erlang_etf_map(strict: true)
      etf1 = Erlang::ETF::Map[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      term = Erlang.from(etf0)
      binary = etf0.erlang_dump
      assert_equal etf0, Erlang::ETF::Map.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
      term = Erlang.from(etf1)
      binary = etf1.erlang_dump
      assert_equal etf1, Erlang::ETF::Map.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
    }
  end

end
