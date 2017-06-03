# encoding: utf-8

require 'test_helper'

class Erlang::ETF::ReferenceTest < Minitest::Test

  def test_erlang_load
    term      = Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]
    node      = Erlang::ETF::Atom[Erlang::Atom['node@host']]
    id        = 1234
    creation  = 1
    reference = Erlang::ETF::Reference[term, node, id, creation]
    etf = Erlang::ETF::Reference.erlang_load(StringIO.new([100,0,9,110,111,100,101,64,104,111,115,116,0,0,4,210,1].pack('C*')))
    assert_equal reference, etf
    assert_equal Erlang.from(reference), etf.term
  end

  def test_new
    etf = Erlang::ETF::Reference[Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]]
    assert_equal Erlang.from(Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]), etf.term
  end

  def test_erlang_dump
    term      = Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]
    node      = Erlang::ETF::Atom[Erlang::Atom['node@host']]
    id        = 1234
    creation  = 1
    reference = Erlang::ETF::Reference[term, node, id, creation]
    binary    = reference.erlang_dump
    assert_equal [101,100,0,9,110,111,100,101,64,104,111,115,116,0,0,4,210,1].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Reference[Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]]
    assert_equal :reference, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Reference[Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]]
    assert_equal Erlang.from(Erlang::Reference[Erlang::Atom['node@host'], 1, 1234]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      Erlang::ETF::Reference[Erlang::Reference[
        Erlang::Atom[random_string(range(0, 255))],
        range(0, (1 << 2) - 1),
        range(0, (1 << 18) - 1)
      ]]
    }.check { |term|
      assert_equal term, eval(term.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      Erlang::ETF::Reference[Erlang::Reference[
        Erlang::Atom[random_string(range(0, 255))],
        range(0, (1 << 2) - 1),
        range(0, (1 << 18) - 1)
      ]]
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::Reference.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
