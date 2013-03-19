# encoding: utf-8

require 'spec_helper'

describe Erlang do
  describe 'binary_to_term' do
    context 'without magic byte' do
      subject { -> { Erlang.binary_to_term("") } }
      it { should raise_error(NotImplementedError) }
    end
  end

  describe 'term_to_binary' do
    context 'when term cannot evolve' do
      subject { -> { Erlang.term_to_binary(Object.new) } }
      it { should raise_error(NotImplementedError) }
    end
  end

  def roundtrip(term)
    expect(term).to eq(Erlang.binary_to_term(Erlang.term_to_binary(term)))
  end

  roundtrip_variables = [
    1,
    1.0,
    :a,
    Erlang::Tuple[],
    Erlang::Tuple[:a],
    Erlang::Tuple[:a, :b],
    Erlang::Tuple[Erlang::Tuple[:a, 1], Erlang::Tuple[:b, 2]],
    Erlang::Tuple[:bert, :unknown],
    Erlang::Tuple[:bert, "bad value"],
    [],
    [:a],
    [:a, 1],
    [[:a, 1], [:b, 2]],
    Erlang::List[:a].tail(:b),
    Erlang::List[:a, :b],
    "a",
    Erlang::String.new("a"),
    Erlang::Nil.new,
    nil,
    true,
    false,
    {},
    {:a => 1},
    {:a => 1, :b => 2},
    {a: {b: 1}},
    Erlang::Tuple[:bert, :dict, :invalid],
    Erlang::Tuple[:bert, :dict],
    Erlang::Tuple[:bert, :dict, Erlang::Tuple[:a]],
    Time.now,
    Erlang::Tuple[:bert, :time],
    Erlang::Tuple[:bert, :time, 1, 1],
    Erlang::Tuple[:bert, :time, 1, 1, 1, 1],
    /^c(a)t$/imx,
    Erlang::Tuple[:bert, :regex, ".", "invalid"],
    Erlang::Tuple[:bert, :regex],
    178,
    (256 ** 256) - 1,
    :true,
    :false,
    :nil,
    Erlang::Tuple[:bert, *([0] * 256)],

    Erlang::Export.new(:erlang, :now, 0),
    Erlang::Pid.new(:'node@host', 100, 10, 1),
    Erlang::String.new("test")
  ]

  roundtrip_variables.each do |roundtrip_variable|
    it "roundtrips #{roundtrip_variable.inspect}" do
      roundtrip(roundtrip_variable)
    end
  end
end
