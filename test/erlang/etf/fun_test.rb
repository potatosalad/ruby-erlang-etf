# encoding: utf-8

require 'test_helper'

class Erlang::ETF::FunTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::Fun.erlang_load(StringIO.new([0,0,0,3,103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,38,0,0,0,0,0,100,0,8,101,114,108,95,101,118,97,108,97,20,98,5,182,139,98,108,0,0,0,3,104,2,100,0,1,66,109,0,0,0,33,131,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0,104,2,100,0,1,76,107,0,33,131,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0,104,2,100,0,1,82,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0,106,108,0,0,0,1,104,5,100,0,6,99,108,97,117,115,101,97,1,106,106,108,0,0,0,1,104,3,100,0,7,105,110,116,101,103,101,114,97,1,97,1,106,106,104,3,100,0,4,101,118,97,108,104,2,100,0,5,115,104,101,108,108,100,0,10,108,111,99,97,108,95,102,117,110,99,108,0,0,0,1,103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,22,0,0,0,0,0,106].pack('C*')))
    assert_equal Erlang.from(hash_SUITE_example), etf.term
  end

  def test_new
    etf = hash_SUITE_example
    assert_equal Erlang.from(hash_SUITE_example), etf.term
  end

  def test_erlang_dump
    binary = hash_SUITE_example(strict: true).erlang_dump
    assert_equal [117,0,0,0,3,103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,38,0,0,0,0,0,100,0,8,101,114,108,95,101,118,97,108,97,20,98,5,182,139,98,108,0,0,0,3,104,2,100,0,1,66,109,0,0,0,33,131,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0,104,2,100,0,1,76,107,0,33,131,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0,104,2,100,0,1,82,114,0,3,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,0,122,0,0,0,0,0,0,0,0,106,108,0,0,0,1,104,5,100,0,6,99,108,97,117,115,101,97,1,106,106,108,0,0,0,1,104,3,100,0,7,105,110,116,101,103,101,114,97,1,97,1,106,106,104,3,100,0,4,101,118,97,108,104,2,100,0,5,115,104,101,108,108,100,0,10,108,111,99,97,108,95,102,117,110,99,108,0,0,0,1,103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,22,0,0,0,0,0,106].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = hash_SUITE_example
    assert_equal :fun, etf.erlang_external_type
  end

  def test_to_erlang
    etf = hash_SUITE_example
    assert_equal Erlang.from(hash_SUITE_example), etf.to_erlang
  end

  def test_inspect
    etf0 = hash_SUITE_example(strict: true)
    etf1 = hash_SUITE_example
    assert_equal etf0, eval(etf0.inspect)
    assert_equal etf0, eval(etf0.pretty_inspect)
    assert_equal etf1, eval(etf1.inspect)
    assert_equal etf1, eval(etf1.pretty_inspect)
  end

  def test_etf
    etf0 = hash_SUITE_example(strict: true)
    etf1 = hash_SUITE_example
    term = Erlang.from(etf0)
    binary = etf0.erlang_dump
    assert_equal etf0, Erlang::ETF::Fun.erlang_load(StringIO.new(binary[1..-1]))
    assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
    term = Erlang.from(etf1)
    binary = etf1.erlang_dump
    assert_equal etf1, Erlang::ETF::Fun.erlang_load(StringIO.new(binary[1..-1]))
    assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
  end

private
  def hash_SUITE_example(strict: false)
    term = Erlang::Function[
      pid: Erlang::Pid[:"nonode@nohost", 38, 0, 0],
      mod: :erl_eval,
      index: 20,
      uniq: 95849314,
      free_vars:
       [
        [
         Erlang::Tuple[
          :B,
          "\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"],
         Erlang::Tuple[
          :L,
          Erlang::String["\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"]],
         Erlang::Tuple[:R, Erlang::Reference[:"nonode@nohost", 0, [122, 0, 0]]]],
        [Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:integer, 1, 1]]]],
        Erlang::Tuple[
         :eval,
         Erlang::Tuple[:shell, :local_func],
         [Erlang::Pid[:"nonode@nohost", 22, 0, 0]]]]]
    return Erlang::ETF::Fun[term] if strict == false
    return Erlang::ETF::Fun[
     term,
     Erlang::ETF::Pid[
      Erlang::Pid[:"nonode@nohost", 38, 0, 0],
      Erlang::ETF::Atom[:"nonode@nohost"],
      38,
      0,
      0],
     Erlang::ETF::Atom[:erl_eval],
     Erlang::ETF::SmallInteger[20],
     Erlang::ETF::Integer[95849314],
     [Erlang::ETF::List[
       [
        Erlang::Tuple[
         :B,
         "\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"],
        Erlang::Tuple[
         :L,
         Erlang::String["\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"]],
        Erlang::Tuple[:R, Erlang::Reference[:"nonode@nohost", 0, [122, 0, 0]]]],
       [Erlang::ETF::SmallTuple[
         Erlang::Tuple[
          :B,
          "\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"],
         [Erlang::ETF::Atom[:B],
          Erlang::ETF::Binary["\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"]]],
        Erlang::ETF::SmallTuple[
         Erlang::Tuple[
          :L,
          Erlang::String["\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"]],
         [Erlang::ETF::Atom[:L],
          Erlang::ETF::String[Erlang::String["\x83r\x00\x03d\x00\rnonode@nohost\x00\x00\x00\x00z\x00\x00\x00\x00\x00\x00\x00\x00"]]]],
        Erlang::ETF::SmallTuple[
         Erlang::Tuple[:R, Erlang::Reference[:"nonode@nohost", 0, [122, 0, 0]]],
         [Erlang::ETF::Atom[:R],
          Erlang::ETF::NewReference[
           Erlang::Reference[:"nonode@nohost", 0, [122, 0, 0]],
           Erlang::ETF::Atom[:"nonode@nohost"],
           0,
           [122, 0, 0]]]]],
       Erlang::ETF::Nil[[]]],
      Erlang::ETF::List[
       [Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:integer, 1, 1]]]],
       [Erlang::ETF::SmallTuple[
         Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:integer, 1, 1]]],
         [Erlang::ETF::Atom[:clause],
          Erlang::ETF::SmallInteger[1],
          Erlang::ETF::Nil[[]],
          Erlang::ETF::Nil[[]],
          Erlang::ETF::List[
           [Erlang::Tuple[:integer, 1, 1]],
           [Erlang::ETF::SmallTuple[
             Erlang::Tuple[:integer, 1, 1],
             [Erlang::ETF::Atom[:integer],
              Erlang::ETF::SmallInteger[1],
              Erlang::ETF::SmallInteger[1]]]],
           Erlang::ETF::Nil[[]]]]]],
       Erlang::ETF::Nil[[]]],
      Erlang::ETF::SmallTuple[
       Erlang::Tuple[
        :eval,
        Erlang::Tuple[:shell, :local_func],
        [Erlang::Pid[:"nonode@nohost", 22, 0, 0]]],
       [Erlang::ETF::Atom[:eval],
        Erlang::ETF::SmallTuple[
         Erlang::Tuple[:shell, :local_func],
         [Erlang::ETF::Atom[:shell], Erlang::ETF::Atom[:local_func]]],
        Erlang::ETF::List[
         [Erlang::Pid[:"nonode@nohost", 22, 0, 0]],
         [Erlang::ETF::Pid[
           Erlang::Pid[:"nonode@nohost", 22, 0, 0],
           Erlang::ETF::Atom[:"nonode@nohost"],
           22,
           0,
           0]],
         Erlang::ETF::Nil[[]]]]]]]
  end

end
