# encoding: utf-8

require 'test_helper'

class Erlang::ETF::FloatTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::Float.erlang_load(StringIO.new([49,46,49,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0,0].pack('C*')))
    assert_equal Erlang.from(Erlang::Float["1.10000000000000000000e+00", old: true]), etf.term
    etf = Erlang::ETF::Float.erlang_load(StringIO.new([45,49,46,49,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0].pack('C*')))
    assert_equal Erlang.from(Erlang::Float["-1.10000000000000000000e+00", old: true]), etf.term
    etf = Erlang::ETF::Float.erlang_load(StringIO.new([49,46,49,50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,48,48,49,101,45,48,51,0,0,0,0,0].pack('C*')))
    assert_equal Erlang.from(Erlang::Float["1.12233445566778899001e-03", old: true]), etf.term
  end

  def test_new
    etf = Erlang::ETF::Float[Erlang::Float[-1.1, old: true]]
    assert_equal Erlang.from(Erlang::Float[-1.1, old: true]), etf.term
    etf = Erlang::ETF::Float[Erlang::Float["1.12233445566778899001e-03", old: true]]
    assert_equal Erlang.from(Erlang::Float["1.12233445566778899001e-03", old: true]), etf.term
  end

  def test_erlang_dump
    binary = Erlang::ETF::Float[Erlang::Float[1.1, old: true]].erlang_dump
    assert_equal [99,49,46,49,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0,0].pack('C*'), binary
    binary = Erlang::ETF::Float[Erlang::Float[-1.1, old: true]].erlang_dump
    assert_equal [99,45,49,46,49,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0].pack('C*'), binary
    binary = Erlang::ETF::Float[Erlang::Float["1.12233445566778899001e-03", old: true], "1.12233445566778899001e-03\0\0\0\0\0"].erlang_dump
    assert_equal [99,49,46,49,50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,48,48,49,101,45,48,51,0,0,0,0,0].pack('C*'), binary
    binary = Erlang::ETF::Float[Erlang::Float["1.12233445566778899001234e-03", old: true]].erlang_dump
    assert_equal [99,49,46,49,50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,48,48,49,101,45,48,51,0,0,0,0,0].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = Erlang::ETF::Float[Erlang::Float[1.1, old: true]]
    assert_equal :float, etf.erlang_external_type
  end

  def test_to_erlang
    etf = Erlang::ETF::Float[Erlang::Float[-1.1, old: true]]
    assert_equal Erlang.from(Erlang::Float[-1.1, old: true]), etf.to_erlang
    etf = Erlang::ETF::Float[Erlang::Float["1.12233445566778899001e-03", old: true]]
    assert_equal Erlang.from(Erlang::Float["1.12233445566778899001e-03", old: true]), etf.to_erlang
  end

  def test_property_of_inspect
    property_of {
      etf0 = erlang_etf_float(strict: true)
      etf1 = Erlang::ETF::Float[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      assert_equal etf0, eval(etf0.inspect)
      assert_equal etf1, eval(etf1.inspect)
    }
  end

  def test_property_of_etf
    property_of {
      etf0 = erlang_etf_float(strict: true)
      etf1 = Erlang::ETF::Float[etf0.term]
      [ etf0, etf1 ]
    }.check { |(etf0, etf1)|
      term = Erlang.from(etf0)
      binary = etf0.erlang_dump
      assert_equal etf0, Erlang::ETF::Float.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
      term = Erlang.from(etf1)
      binary = etf1.erlang_dump
      assert_equal etf1, Erlang::ETF::Float.erlang_load(StringIO.new(binary[1..-1]))
      assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
    }
  end

end
