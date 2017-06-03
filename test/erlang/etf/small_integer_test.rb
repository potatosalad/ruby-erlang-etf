# encoding: utf-8

require 'test_helper'

class Erlang::ETF::SmallIntegerTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::SmallInteger.erlang_load(StringIO.new([0].pack('C*')))
    assert_equal Erlang.from(0), etf.term
    etf = Erlang::ETF::SmallInteger.erlang_load(StringIO.new([255].pack('C*')))
    assert_equal Erlang.from(255), etf.term
  end

  def test_new
    etf = Erlang::ETF::SmallInteger[0]
    assert_equal Erlang.from(0), etf.term
    etf = Erlang::ETF::SmallInteger[255]
    assert_equal Erlang.from(255), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::SmallInteger[0].erlang_dump
    assert_equal [97,0].pack('C*'), binary
    binary = Erlang::ETF::SmallInteger[255].erlang_dump
    assert_equal [97,255].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::SmallInteger[0]
    assert_equal :small_integer, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::SmallInteger[0]
    assert_equal Erlang.from(0), etf.to_erlang
    etf = Erlang::ETF::SmallInteger[255]
    assert_equal Erlang.from(255), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      Erlang::ETF::SmallInteger[range(0, 255)]
    }.check { |etf|
      assert_equal etf, eval(etf.inspect)
    }
  end

  def test_property_of_etf
    property_of {
      Erlang::ETF::SmallInteger[range(0, 255)]
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::SmallInteger.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
