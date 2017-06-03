# encoding: utf-8

require 'test_helper'

class Erlang::ETF::ExportTest < Minitest::Test

  def test_erlang_load
    term     = Erlang::Export[:erlang, :now, 0]
    mod      = Erlang::ETF::Atom[Erlang::Atom[:erlang]]
    function = Erlang::ETF::Atom[Erlang::Atom[:now]]
    arity    = Erlang::ETF::SmallInteger[0]
    export   = Erlang::ETF::Export[term, mod, function, arity]
    etf = Erlang::ETF::Export.erlang_load(StringIO.new([100,0,6,101,114,108,97,110,103,100,0,3,110,111,119,97,0].pack('C*')))
    assert_equal export, etf
    assert_equal Erlang.from(export), etf.term
  end

  def test_new
    etf = Erlang::ETF::Export[Erlang::Export[:erlang, :now, 0]]
    assert_equal Erlang.from(Erlang::Export[:erlang, :now, 0]), etf.term
  end

  def test_erlang_dump
    term     = Erlang::Export[:erlang, :now, 0]
    mod      = Erlang::ETF::Atom[Erlang::Atom[:erlang]]
    function = Erlang::ETF::Atom[Erlang::Atom[:now]]
    arity    = Erlang::ETF::SmallInteger[0]
    export   = Erlang::ETF::Export[term, mod, function, arity]
    binary   = export.erlang_dump
    assert_equal [113,100,0,6,101,114,108,97,110,103,100,0,3,110,111,119,97,0].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Export[Erlang::Export[:erlang, :now, 0]]
    assert_equal :export, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Export[Erlang::Export[:erlang, :now, 0]]
    assert_equal Erlang.from(Erlang::Export[:erlang, :now, 0]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      etf0 = erlang_etf_export(strict: true)
      etf1 = Erlang::ETF::Export[etf0.term]
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
      etf0 = erlang_etf_export(strict: true)
      etf1 = Erlang::ETF::Export[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      term = Erlang.from(etf0)
      binary = etf0.erlang_dump
      assert_equal etf0, Erlang::ETF::Export.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
      term = Erlang.from(etf1)
      binary = etf1.erlang_dump
      assert_equal etf1, Erlang::ETF::Export.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
    }
  end

end
