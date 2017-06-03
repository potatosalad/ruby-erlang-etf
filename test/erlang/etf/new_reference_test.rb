# encoding: utf-8

require 'test_helper'

class Erlang::ETF::NewReferenceTest < Minitest::Test

  def test_erlang_load
    term          = Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]
    node          = Erlang::ETF::Atom[Erlang::Atom['node@host']]
    creation      = 1
    ids           = [1234, 5678]
    new_reference = Erlang::ETF::NewReference[term, node, creation, ids]
    etf = Erlang::ETF::NewReference.erlang_load(StringIO.new([0,2,100,0,9,110,111,100,101,64,104,111,115,116,1,0,0,4,210,0,0,22,46].pack('C*')))
    assert_equal new_reference, etf
    assert_equal Erlang.from(new_reference), etf.term
  end

  def test_new
    etf = Erlang::ETF::NewReference[Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]]
    assert_equal Erlang.from(Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]), etf.term
  end

  def test_erlang_dump
    term          = Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]
    node          = Erlang::ETF::Atom[Erlang::Atom['node@host']]
    creation      = 1
    ids           = [1234, 5678]
    new_reference = Erlang::ETF::NewReference[term, node, creation, ids]
    binary        = new_reference.erlang_dump
    assert_equal [114,0,2,100,0,9,110,111,100,101,64,104,111,115,116,1,0,0,4,210,0,0,22,46].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::NewReference[Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]]
    assert_equal :new_reference, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::NewReference[Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]]
    assert_equal Erlang.from(Erlang::Reference[Erlang::Atom['node@host'], 1, [1234, 5678]]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(1, 3)
      Erlang::ETF::NewReference[Erlang::Reference[
        Erlang::Atom[random_string(range(0, 255))],
        range(0, (1 << 2) - 1),
        len.times.map { range(0, (1 << 18) - 1) }
      ]]
    }.check { |etf|
      assert_equal etf, eval(etf.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      len = range(1, 3)
      Erlang::ETF::NewReference[Erlang::Reference[
        Erlang::Atom[random_string(range(0, 255))],
        range(0, (1 << 2) - 1),
        len.times.map { range(0, (1 << 18) - 1) }
      ]]
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::NewReference.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
