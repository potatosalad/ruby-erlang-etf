# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::NewFun do
  let(:term_class) { Erlang::ETF::NewFun }

  let(:arity)     { 1 }
  let(:uniq)      { [32, 134, 155, 11, 165, 194, 128, 94, 159, 150, 25, 37, 107, 162, 125, 47] }
  let(:index)     { 6 }
  let(:mod)       { Erlang::ETF::Atom.new("erl_eval") }
  let(:old_index) { Erlang::ETF::SmallInteger.new(6) }
  let(:old_uniq)  { Erlang::ETF::Integer.new(17052888) }
  let(:pid)       { Erlang::ETF::Pid.new(Erlang::ETF::Atom.new("nonode@nohost"), 2, 0, 0) }
  let(:free_vars) {
    [
      Erlang::ETF::Nil.new,
      Erlang::ETF::Atom.new("none"),
      Erlang::ETF::Atom.new("none"),
      Erlang::ETF::List.new([
        Erlang::ETF::SmallTuple.new([
          Erlang::ETF::Atom.new("clause"),
          Erlang::ETF::SmallInteger.new(1),
          Erlang::ETF::List.new([
            Erlang::ETF::SmallTuple.new([
              Erlang::ETF::Atom.new("atom"),
              Erlang::ETF::SmallInteger.new(1),
              Erlang::ETF::Atom.new("a")
            ])
          ]),
          Erlang::ETF::Nil.new,
          Erlang::ETF::List.new([
            Erlang::ETF::SmallTuple.new([
              Erlang::ETF::Atom.new("atom"),
              Erlang::ETF::SmallInteger.new(1),
              Erlang::ETF::Atom.new("true")
            ])
          ])
        ]),
        Erlang::ETF::SmallTuple.new([
          Erlang::ETF::Atom.new("clause"),
          Erlang::ETF::SmallInteger.new(1),
          Erlang::ETF::List.new([
            Erlang::ETF::SmallTuple.new([
              Erlang::ETF::Atom.new("var"),
              Erlang::ETF::SmallInteger.new(1),
              Erlang::ETF::Atom.new("_")
            ])
          ]),
          Erlang::ETF::Nil.new,
          Erlang::ETF::List.new([
            Erlang::ETF::SmallTuple.new([
              Erlang::ETF::Atom.new("atom"),
              Erlang::ETF::SmallInteger.new(1),
              Erlang::ETF::Atom.new("false")
            ])
          ])
        ])
      ])
    ]
  }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      # generated using:
      #   erl -noshell -eval 'io:format("~w~n", [term_to_binary(fun(a) -> true; (_) -> false end)]), init:stop().'
      #
      let(:bytes) { [
        0,0,0,212,1,32,134,155,11,165,194,128,94,159,150,25,37,107,162,125,
        47,0,0,0,6,0,0,0,4,100,0,8,101,114,108,95,101,118,97,108,97,6,98,1,4,52,216,
        103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,2,0,0,
        0,0,0,106,100,0,4,110,111,110,101,100,0,4,110,111,110,101,108,0,0,0,2,104,5,
        100,0,6,99,108,97,117,115,101,97,1,108,0,0,0,1,104,3,100,0,4,97,116,111,109,
        97,1,100,0,1,97,106,106,108,0,0,0,1,104,3,100,0,4,97,116,111,109,97,1,100,0,
        4,116,114,117,101,106,104,5,100,0,6,99,108,97,117,115,101,97,1,108,0,0,0,1,
        104,3,100,0,3,118,97,114,97,1,100,0,1,95,106,106,108,0,0,0,1,104,3,100,0,4,
        97,116,111,109,97,1,100,0,5,102,97,108,115,101,106,106
      ] }

      its(:size)      { should eq(212) }
      its(:arity)     { should eq(arity) }
      its(:uniq)      { should eq(uniq) }
      its(:index)     { should eq(index) }
      its(:num_free)  { should eq(4) }
      its(:mod)       { should eq(mod) }
      its(:old_index) { should eq(old_index) }
      its(:old_uniq)  { should eq(old_uniq) }
      its(:pid)       { should eq(pid) }
      its(:free_vars) { should eq(free_vars) }
    end

    describe 'new' do
      subject { term_class.new(arity, uniq, index, mod, old_index, old_uniq, pid, free_vars).tap(&:serialize) }

      its(:size)      { should eq(212) }
      its(:arity)     { should eq(arity) }
      its(:uniq)      { should eq(uniq) }
      its(:index)     { should eq(index) }
      its(:num_free)  { should eq(4) }
      its(:mod)       { should eq(mod) }
      its(:old_index) { should eq(old_index) }
      its(:old_uniq)  { should eq(old_uniq) }
      its(:pid)       { should eq(pid) }
      its(:free_vars) { should eq(free_vars) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(arity, uniq, index, mod, old_index, old_uniq, pid, free_vars) }

    describe 'serialize' do
      subject { term.serialize }

      let(:bytes) { [
        112,0,0,0,212,1,32,134,155,11,165,194,128,94,159,150,25,37,107,162,125,
        47,0,0,0,6,0,0,0,4,100,0,8,101,114,108,95,101,118,97,108,97,6,98,1,4,52,216,
        103,100,0,13,110,111,110,111,100,101,64,110,111,104,111,115,116,0,0,0,2,0,0,
        0,0,0,106,100,0,4,110,111,110,101,100,0,4,110,111,110,101,108,0,0,0,2,104,5,
        100,0,6,99,108,97,117,115,101,97,1,108,0,0,0,1,104,3,100,0,4,97,116,111,109,
        97,1,100,0,1,97,106,106,108,0,0,0,1,104,3,100,0,4,97,116,111,109,97,1,100,0,
        4,116,114,117,101,106,104,5,100,0,6,99,108,97,117,115,101,97,1,108,0,0,0,1,
        104,3,100,0,3,118,97,114,97,1,100,0,1,95,106,106,108,0,0,0,1,104,3,100,0,4,
        97,116,111,109,97,1,100,0,5,102,97,108,115,101,106,106
      ].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      it { should eq(:new_fun) }
    end

    describe '__ruby_evolve__' do
      let(:ruby_obj) { term }
      subject { term.__ruby_evolve__ }

      it { should eq(ruby_obj) }
    end
  end

end
