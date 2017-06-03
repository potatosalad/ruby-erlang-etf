# encoding: utf-8

require 'test_helper'

class Erlang::ETF::IntegerTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::Integer.erlang_load(StringIO.new([127,255,255,255].pack('C*')))
    assert_equal Erlang.from(2147483647), etf.term
    etf = Erlang::ETF::Integer.erlang_load(StringIO.new([128,0,0,1].pack('C*')))
    assert_equal Erlang.from(-2147483647), etf.term
  end

  def test_new
    etf = Erlang::ETF::Integer[2147483647]
    assert_equal Erlang.from(2147483647), etf.term
    etf = Erlang::ETF::Integer[-2147483647]
    assert_equal Erlang.from(-2147483647), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::Integer[2147483647].erlang_dump
    assert_equal [98,127,255,255,255].pack('C*'), binary
    binary = Erlang::ETF::Integer[-2147483647].erlang_dump
    assert_equal [98,128,0,0,1].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Integer[2147483647]
    assert_equal :integer, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Integer[2147483647]
    assert_equal Erlang.from(2147483647), etf.to_erlang
    etf = Erlang::ETF::Integer[-2147483647]
    assert_equal Erlang.from(-2147483647), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      Erlang::ETF::Integer[range(-2147483647, 2147483647)]
    }.check { |etf|
      assert_equal etf, eval(etf.inspect)
    }
  end

  def test_property_of_etf
    property_of {
      Erlang::ETF::Integer[range(-2147483647, 2147483647)]
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::Integer.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
