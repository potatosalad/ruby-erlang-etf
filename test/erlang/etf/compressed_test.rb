# encoding: utf-8

require 'test_helper'

class Erlang::ETF::CompressedTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::Compressed.erlang_load(StringIO.new([0,0,0,18,120,156,203,102,224,103,68,5,0,9,0,0,138].pack('C*')))
    assert_equal Erlang.from(Erlang::String["\x01" * 15]), etf.term
    etf = Erlang::ETF::Compressed.erlang_load(StringIO.new([0,0,0,18,120,1,1,18,0,237,255,107,0,15,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,9,0,0,138].pack('C*')))
    assert_equal Erlang.from(Erlang::String["\x01" * 15]), etf.term
    etf = Erlang::ETF::Compressed.erlang_load(StringIO.new([0,0,0,18,120,1,203,102,224,103,68,5,0,9,0,0,138].pack('C*')))
    assert_equal Erlang.from(Erlang::String["\x01" * 15]), etf.term
    etf = Erlang::ETF::Compressed.erlang_load(StringIO.new([0,0,0,18,120,218,203,102,224,103,68,5,0,9,0,0,138].pack('C*')))
    assert_equal Erlang.from(Erlang::String["\x01" * 15]), etf.term
    # Invalid zlib, valid size
    assert_raises(::Zlib::BufError) { Erlang::ETF::Compressed.erlang_load(StringIO.new([0,0,0,18,120,156,203,102,224,103,68,5,0,9,0,0].pack('C*'))) }
    # Valid zlib, invalid size
    assert_raises(::Zlib::DataError) { Erlang::ETF::Compressed.erlang_load(StringIO.new([0,0,0,17,120,156,203,102,224,103,68,5,0,9,0,0,138].pack('C*'))) }
  end

  def test_new
    etf = Erlang::ETF::Compressed[Erlang::String["test"]]
    assert_equal Erlang.from(Erlang::String["test"]), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::Compressed[Erlang::String["\x01" * 15]].erlang_dump
    assert_equal [80,0,0,0,18,120,156,203,102,224,103,68,5,0,9,0,0,138].pack('C*'), binary
    binary = Erlang::ETF::Compressed[Erlang::String["\x01" * 15], level: 0].erlang_dump
    assert_equal [80,0,0,0,18,120,1,1,18,0,237,255,107,0,15,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,9,0,0,138].pack('C*'), binary
    binary = Erlang::ETF::Compressed[Erlang::String["\x01" * 15], level: 1].erlang_dump
    assert_equal [80,0,0,0,18,120,1,203,102,224,103,68,5,0,9,0,0,138].pack('C*'), binary
    binary = Erlang::ETF::Compressed[Erlang::String["\x01" * 15], level: 9].erlang_dump
    assert_equal [80,0,0,0,18,120,218,203,102,224,103,68,5,0,9,0,0,138].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Compressed[Erlang::String["test"]]
    assert_equal :compressed, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Compressed[Erlang::String["test"]]
    assert_equal Erlang.from(Erlang::String["test"]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      len = range(0, 2048)
      sized(len) {
        Erlang::ETF::Compressed[Erlang::String[random_string(len)]]
      }
    }.check { |etf|
      assert_equal etf, eval(etf.inspect)
    }
  end

  def test_property_of_serialization
    property_of {
      Erlang::ETF::Compressed[random_erlang_etf_term, level: range(0, 9)]
    }.check { |etf|
      term = Erlang.from(etf)
      binary = etf.erlang_dump
      assert_equal etf, Erlang::ETF::Compressed.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf))
    }
  end

end
