# encoding: utf-8

require 'test_helper'

class Erlang::ETF::StringTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::String.erlang_load(StringIO.new([0,4,116,101,115,116].pack('C*')))
    assert_equal Erlang.from(Erlang::String["test"]), etf.term
    etf = Erlang::ETF::String.erlang_load(StringIO.new([0,2,206,169].pack('C*')))
    assert_equal Erlang.from(Erlang::String["Ω"]), etf.term
  end

  def test_new
    etf = Erlang::ETF::String[Erlang::String["test"]]
    assert_equal Erlang.from(Erlang::String["test"]), etf.term
    etf = Erlang::ETF::String[Erlang::String["Ω"]]
    assert_equal Erlang.from(Erlang::String["Ω"]), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::String[Erlang::String["test"]].erlang_dump
    assert_equal [107,0,4,116,101,115,116].pack('C*'), binary
    binary = Erlang::ETF::String[Erlang::String["Ω"]].erlang_dump
    assert_equal [107,0,2,206,169].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::String[Erlang::String["test"]]
    assert_equal :string, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::String[Erlang::String["test"]]
    assert_equal Erlang.from(Erlang::String["test"]), etf.to_erlang
    etf = Erlang::ETF::String[Erlang::String["Ω"]]
    assert_equal Erlang.from(Erlang::String["Ω"]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(0, 2048)
      sized(len) {
        Erlang::ETF::String[Erlang::String[random_string(len)]]
      }
    }.check { |etf|
      assert_equal etf, eval(etf.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      len = range(0, 2048)
      sized(len) {
        Erlang::ETF::String[Erlang::String[random_string(len)]]
      }
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::String.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
