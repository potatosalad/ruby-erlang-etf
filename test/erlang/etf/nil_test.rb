# encoding: utf-8

require 'test_helper'

class Erlang::ETF::NilTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::Nil.erlang_load(StringIO.new([].pack('C*')))
    assert_equal Erlang.from(Erlang::Nil), etf.term
  end

  def test_new
    etf = Erlang::ETF::Nil[Erlang::Nil]
    assert_equal Erlang.from(Erlang::Nil), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::Nil[Erlang::Nil].erlang_dump
    assert_equal [106].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Nil[Erlang::Nil]
    assert_equal :nil, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Nil[Erlang::Nil]
    assert_equal Erlang.from(Erlang::Nil), etf.to_erlang
  end

  def test_inspect
    etf = Erlang::ETF::Nil[Erlang::Nil]
    assert_equal etf, eval(etf.inspect)
  end

  def test_etf
    etf = Erlang::ETF::Nil[Erlang::Nil]
    term = Erlang.from(etf)
    binary = etf.erlang_dump
    assert_equal etf, Erlang::ETF::Nil.erlang_load(StringIO.new(binary[1..-1]))
    assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
  end

end
