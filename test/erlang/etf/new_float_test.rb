# encoding: utf-8

require 'test_helper'

class Erlang::ETF::NewFloatTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::NewFloat.erlang_load(StringIO.new([63,241,153,153,153,153,153,154].pack('C*')))
    assert_equal Erlang.from(1.1), etf.term
    etf = Erlang::ETF::NewFloat.erlang_load(StringIO.new([191,241,153,153,153,153,153,154].pack('C*')))
    assert_equal Erlang.from(-1.1), etf.term
    etf = Erlang::ETF::NewFloat.erlang_load(StringIO.new([63,82,99,105,114,16,170,24].pack('C*')))
    assert_equal Erlang.from(0.001122334455667789), etf.term
  end

  def test_new
    etf = Erlang::ETF::NewFloat[-1.1]
    assert_equal Erlang.from(-1.1), etf.term
    etf = Erlang::ETF::NewFloat[BigDecimal.new("1.12233445566778899001e-03")]
    assert_equal Erlang.from(BigDecimal.new("1.12233445566778899001e-03")), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::NewFloat[1.1].erlang_dump
    assert_equal [70,63,241,153,153,153,153,153,154].pack('C*'), binary
    binary = Erlang::ETF::NewFloat[-1.1].erlang_dump
    assert_equal [70,191,241,153,153,153,153,153,154].pack('C*'), binary
    binary = Erlang::ETF::NewFloat[BigDecimal.new("1.12233445566778899001e-03")].erlang_dump
    assert_equal [70,63,82,99,105,114,16,170,24].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::NewFloat[1.1]
    assert_equal :new_float, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::NewFloat[-1.1]
    assert_equal Erlang.from(-1.1), etf.to_erlang
    etf = Erlang::ETF::NewFloat[BigDecimal.new("1.12233445566778899001e-03")]
    assert_equal Erlang.from(BigDecimal.new("1.12233445566778899001e-03")), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      erlang_etf_new_float
    }.check { |etf|
      assert_equal etf, eval(etf.inspect)
    }
  end

  def test_property_of_etf
    property_of {
      erlang_etf_new_float
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::NewFloat.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
