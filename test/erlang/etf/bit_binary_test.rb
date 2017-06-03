# encoding: utf-8

require 'test_helper'

class Erlang::ETF::BitBinaryTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::BitBinary.erlang_load(StringIO.new([0,0,0,5,7,116,101,115,116,254].pack('C*')))
    assert_equal Erlang.from(Erlang::Bitstring["test\x7F",bits:7]), etf.term
    etf = Erlang::ETF::BitBinary.erlang_load(StringIO.new([0,0,0,3,7,206,169,254].pack('C*')))
    assert_equal Erlang.from(Erlang::Bitstring["Ω\x7F",bits:7]), etf.term
  end

  def test_new
    etf = Erlang::ETF::BitBinary[Erlang::Bitstring["test\x7F",bits:7]]
    assert_equal Erlang.from(Erlang::Bitstring["test\x7F",bits:7]), etf.term
    etf = Erlang::ETF::BitBinary[Erlang::Bitstring["Ω\x7F",bits:7]]
    assert_equal Erlang.from(Erlang::Bitstring["Ω\x7F",bits:7]), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::BitBinary[Erlang::Bitstring["test\x7F",bits:7]].erlang_dump
    assert_equal [77,0,0,0,5,7,116,101,115,116,254].pack('C*'), binary
    binary = Erlang::ETF::BitBinary[Erlang::Bitstring["Ω\x7F",bits:7]].erlang_dump
    assert_equal [77,0,0,0,3,7,206,169,254].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::BitBinary[Erlang::Bitstring["test\x7F",bits:7]]
    assert_equal :bit_binary, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::BitBinary[Erlang::Bitstring["test\x7F",bits:7]]
    assert_equal Erlang.from(Erlang::Bitstring["test\x7F",bits:7]), etf.to_erlang
    etf = Erlang::ETF::BitBinary[Erlang::Bitstring["Ω\x7F",bits:7]]
    assert_equal Erlang.from(Erlang::Bitstring["Ω\x7F",bits:7]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(0, 2048)
      bits = range(1, 8)
      sized(len) {
        Erlang::ETF::BitBinary[Erlang::Bitstring[random_string(len), bits: bits]]
      }
    }.check { |term|
      assert_equal term, eval(term.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      len = range(0, 2048)
      bits = range(1, 8)
      sized(len) {
        Erlang::ETF::BitBinary[Erlang::Bitstring[random_string(len), bits: bits]]
      }
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::BitBinary.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
