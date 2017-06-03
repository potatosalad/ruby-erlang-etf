# encoding: utf-8

require 'test_helper'

class Erlang::ETF::NewFunTest < Minitest::Test

  def test_erlang_load
    etf = Erlang::ETF::NewFun.erlang_load(StringIO.new([0,0,0,133,0,99,62,121,82,122,95,246,237,63,72,118,40,4,25,16,50,0,0,0,20,0,0,0,1,100,0,8,101,114,108,95,101,118,97,108,97,20,98,3,25,243,202,103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,5,0,0,0,0,0,104,4,106,100,0,4,110,111,110,101,100,0,4,110,111,110,101,108,0,0,0,1,104,5,100,0,6,99,108,97,117,115,101,97,1,106,106,108,0,0,0,1,104,3,100,0,4,97,116,111,109,97,1,100,0,2,111,107,106,106].pack('C*')))
    assert_equal Erlang.from(ok_example), etf.term
  end

  def test_new
    etf = ok_example
    assert_equal Erlang.from(ok_example), etf.term
  end

  def test_erlang_dump
    binary = ok_example(strict: true).erlang_dump
    assert_equal [112,0,0,0,133,0,99,62,121,82,122,95,246,237,63,72,118,40,4,25,16,50,0,0,0,20,0,0,0,1,100,0,8,101,114,108,95,101,118,97,108,97,20,98,3,25,243,202,103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,5,0,0,0,0,0,104,4,106,100,0,4,110,111,110,101,100,0,4,110,111,110,101,108,0,0,0,1,104,5,100,0,6,99,108,97,117,115,101,97,1,106,106,108,0,0,0,1,104,3,100,0,4,97,116,111,109,97,1,100,0,2,111,107,106,106].pack('C*'), binary
  end

  def test_erlang_external_type
    etf = ok_example
    assert_equal :new_fun, etf.erlang_external_type
  end

  def test_to_erlang
    etf = ok_example
    assert_equal Erlang.from(ok_example), etf.to_erlang
  end

  def test_inspect
    etf0 = ok_example(strict: true)
    etf1 = ok_example
    assert_equal etf0, eval(etf0.inspect)
    assert_equal etf0, eval(etf0.pretty_inspect)
    assert_equal etf1, eval(etf1.inspect)
    assert_equal etf1, eval(etf1.pretty_inspect)
  end

  def test_etf
    etf0 = ok_example(strict: true)
    etf1 = ok_example
    term = Erlang.from(etf0)
    binary = etf0.erlang_dump
    assert_equal etf0, Erlang::ETF::NewFun.erlang_load(StringIO.new(binary[1..-1]))
    assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf0))
    term = Erlang.from(etf1)
    binary = etf1.erlang_dump
    assert_equal etf1, Erlang::ETF::NewFun.erlang_load(StringIO.new(binary[1..-1]))
    assert_equal term, Erlang.binary_to_term(Erlang.term_to_binary(etf1))
  end

private
  def ok_example(strict: false)
    term = Erlang::Function[
     arity: 0,
     uniq: 131917954694080383981903414123034120242,
     index: 20,
     mod: :erl_eval,
     old_index: 20,
     old_uniq: 52032458,
     pid: Erlang::Pid[:"nonode@nohost", 5, 0, 0],
     free_vars:
      [
       Erlang::Tuple[
        [],
        :none,
        :none,
        [Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:atom, 1, :ok]]]]]]]
    return Erlang::ETF::NewFun[term] if strict == false
    return Erlang::ETF::NewFun[
     term,
     0,
     131917954694080383981903414123034120242,
     20,
     Erlang::ETF::Atom[:erl_eval],
     Erlang::ETF::SmallInteger[20],
     Erlang::ETF::Integer[52032458],
     Erlang::ETF::Pid[
      Erlang::Pid[:"nonode@nohost", 5, 0, 0],
      Erlang::ETF::Atom[:"nonode@nohost"],
      5,
      0,
      0],
     [Erlang::ETF::SmallTuple[
       Erlang::Tuple[
        [],
        :none,
        :none,
        [Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:atom, 1, :ok]]]]],
       [Erlang::ETF::Nil[[]],
        Erlang::ETF::Atom[:none],
        Erlang::ETF::Atom[:none],
        Erlang::ETF::List[
         [Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:atom, 1, :ok]]]],
         [Erlang::ETF::SmallTuple[
           Erlang::Tuple[:clause, 1, [], [], [Erlang::Tuple[:atom, 1, :ok]]],
           [Erlang::ETF::Atom[:clause],
            Erlang::ETF::SmallInteger[1],
            Erlang::ETF::Nil[[]],
            Erlang::ETF::Nil[[]],
            Erlang::ETF::List[
             [Erlang::Tuple[:atom, 1, :ok]],
             [Erlang::ETF::SmallTuple[
               Erlang::Tuple[:atom, 1, :ok],
               [Erlang::ETF::Atom[:atom],
                Erlang::ETF::SmallInteger[1],
                Erlang::ETF::Atom[:ok]]]],
             Erlang::ETF::Nil[[]]]]]],
         Erlang::ETF::Nil[[]]]]]]]
  end

end
