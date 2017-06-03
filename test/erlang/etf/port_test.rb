# encoding: utf-8

require 'test_helper'

class Erlang::ETF::PortTest < Minitest::Test

  def test_erlang_load
    term     = Erlang::Port[Erlang::Atom['node@host'], 1234, 1]
    node     = Erlang::ETF::Atom[Erlang::Atom['node@host']]
    id       = 1234
    creation = 1
    port     = Erlang::ETF::Port[term, node, id, creation]
    etf = Erlang::ETF::Port.erlang_load(StringIO.new([100,0,9,110,111,100,101,64,104,111,115,116,0,0,4,210,1].pack('C*')))
    assert_equal port, etf
    assert_equal Erlang.from(port), etf.term
  end

  def test_new
    etf = Erlang::ETF::Port[Erlang::Port[Erlang::Atom['node@host'], 1234, 1]]
    assert_equal Erlang.from(Erlang::Port[Erlang::Atom['node@host'], 1234, 1]), etf.term
  end

  def test_erlang_dump
    term     = Erlang::Port[Erlang::Atom['node@host'], 1234, 1]
    node     = Erlang::ETF::Atom[Erlang::Atom['node@host']]
    id       = 1234
    creation = 1
    port     = Erlang::ETF::Port[term, node, id, creation]
    binary   = port.erlang_dump
    assert_equal [102,100,0,9,110,111,100,101,64,104,111,115,116,0,0,4,210,1].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Port[Erlang::Port[Erlang::Atom['node@host'], 1234, 1]]
    assert_equal :port, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Port[Erlang::Port[Erlang::Atom['node@host'], 1234, 1]]
    assert_equal Erlang.from(Erlang::Port[Erlang::Atom['node@host'], 1234, 1]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      etf0 = erlang_etf_port(strict: true)
      etf1 = Erlang::ETF::Port[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      assert_equal etf0, eval(etf0.inspect)
      assert_equal etf0, eval(etf0.pretty_inspect)
      assert_equal etf1, eval(etf1.inspect)
      assert_equal etf1, eval(etf1.pretty_inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      etf0 = erlang_etf_port(strict: true)
      etf1 = Erlang::ETF::Port[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      term = Erlang.from(etf0)
      binary = etf0.erlang_dump
      assert_equal etf0, Erlang::ETF::Port.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
      term = Erlang.from(etf1)
      binary = etf1.erlang_dump
      assert_equal etf1, Erlang::ETF::Port.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
    }
  end

end
