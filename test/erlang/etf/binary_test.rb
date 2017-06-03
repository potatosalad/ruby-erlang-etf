# encoding: utf-8

require 'test_helper'

class Erlang::ETF::BinaryTest < Minitest::Test

  def test_erlang_load
    # Empty binary
    etf = Erlang::ETF::Binary.erlang_load(StringIO.new([0,0,0,0].pack('C*')))
    assert_equal Erlang.from(""), etf.term
    # 4-byte binary ASCII
    etf = Erlang::ETF::Binary.erlang_load(StringIO.new([0,0,0,4,116,101,115,116].pack('C*')))
    assert_equal Erlang.from("test"), etf.term
    # 2-byte binary UTF-8
    etf = Erlang::ETF::Binary.erlang_load(StringIO.new([0,0,0,2,206,169].pack('C*')))
    assert_equal Erlang.from("Ω"), etf.term
  end

  def test_new
    # Empty binary
    etf = Erlang::ETF::Binary[Erlang::Binary[]]
    assert_equal Erlang.from(""), etf.term
    # 4-byte binary ASCII
    etf = Erlang::ETF::Binary[Erlang::Binary["test"]]
    assert_equal Erlang.from("test"), etf.term
    # 2-byte binary UTF-8
    etf = Erlang::ETF::Binary[Erlang::Binary['Ω']]
    assert_equal Erlang.from("Ω"), etf.term
  end

  def test_erlang_dump
    # Empty binary
    binary = Erlang::ETF::Binary[Erlang::Binary[]].erlang_dump
    assert_equal [109,0,0,0,0].pack('C*'), binary
    # 4-byte binary ASCII
    binary = Erlang::ETF::Binary[Erlang::Binary["test"]].erlang_dump
    assert_equal [109,0,0,0,4,116,101,115,116].pack('C*'), binary
    # 2-byte binary UTF-8
    binary = Erlang::ETF::Binary[Erlang::Binary["Ω"]].erlang_dump
    assert_equal [109,0,0,0,2,206,169].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Binary[Erlang::Binary[]]
    assert_equal :binary, etf.erlang_external_type
  end

  def test_to_erlang
    # Empty binary
    etf = Erlang::ETF::Binary[Erlang::Binary[]]
    assert_equal Erlang.from(""), etf.to_erlang
    # 4-byte binary ASCII
    etf = Erlang::ETF::Binary[Erlang::Binary["test"]]
    assert_equal Erlang.from("test"), etf.to_erlang
    # 2-byte binary UTF-8
    etf = Erlang::ETF::Binary[Erlang::Binary['Ω']]
    assert_equal Erlang.from("Ω"), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(0, 2048)
      sized(len) {
        Erlang::ETF::Binary[Erlang::Binary[random_string(len)]]
      }
    }.check { |term|
      assert_equal term, eval(term.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      len = range(0, 2048)
      sized(len) {
        Erlang::ETF::Binary[Erlang::Binary[random_string(len)]]
      }
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::Binary.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
