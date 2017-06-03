# encoding: utf-8

require 'test_helper'

class Erlang::ETF::BertTest < Minitest::Test

  # def test_roundtrip
  #   # Boolean
  #   term = Erlang::Tuple[:bert, :true]
  #   lhs = true
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  #   term = Erlang::Tuple[:bert, :false]
  #   lhs = false
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  #   # Dict
  #   term = Erlang::Tuple[:bert, :dict, []]
  #   lhs = {}
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  #   term = Erlang::Tuple[:bert, :dict, [Erlang::Tuple[:a, 1], Erlang::Tuple[:b, 2]]]
  #   lhs = {a: 1, b: 2}
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  #   # Nil
  #   term = Erlang::Tuple[:bert, :nil]
  #   lhs = nil
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  #   # Regex
  #   term = Erlang::Tuple[:bert, :regex, Erlang::Binary['.'], Erlang::List[:caseless, :extended, :multiline]]
  #   lhs = /./imx
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  #   # Time
  #   term = Erlang::Tuple[:bert, :time, 1471, 541315, 698117]
  #   lhs = ::Time.at(1471541315, 698117.0)
  #   assert_equal lhs, Erlang.binary_to_term(Erlang.term_to_binary(term))
  # end

end
