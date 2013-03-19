# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::List do
  let(:term_class) { Erlang::ETF::List }

  let(:atom)          { Erlang::ETF::SmallAtom.new("test").tap(&:serialize) }
  let(:binary)        { Erlang::ETF::Binary.new("test").tap(&:serialize) }
  let(:new_float)     { Erlang::ETF::NewFloat.new(1.1) }
  let(:small_integer) { Erlang::ETF::SmallInteger.new(13) }
  let(:small_list)    { Erlang::ETF::List.new([atom, binary, new_float, small_integer]) }
  let(:small_tuple)   { Erlang::ETF::SmallTuple.new([atom, binary, new_float, small_integer, small_list]) }

  let(:erlang_nil) { Erlang::ETF::Nil.new }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context 'single improper list' do
        let(:bytes) { [0, 0, 0, 1, 100, 0, 1, 97, 100, 0, 1, 98] }
        let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }
        let(:atom_b) { Erlang::ETF::Atom.new("b").tap(&:serialize) }

        it { should be_improper }
        its(:len)      { should eq(1) }
        its(:elements) { should eq([atom_a]) }
        its(:tail)     { should eq(atom_b) }
      end

      context 'single proper list' do
        let(:bytes) { [0, 0, 0, 1, 97, 13, 106] }

        it { should_not be_improper }
        its(:len)      { should eq(1) }
        its(:elements) { should eq([small_integer]) }
        its(:tail)     { should eq(erlang_nil) }
      end

      context 'complex improper list' do
        let(:bytes) { [0, 0, 0, 6, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 104, 5, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106] }

        it { should be_improper }
        its(:len)      { should eq(6) }
        its(:elements) { should eq([atom, binary, new_float, small_integer, small_tuple, small_list]) }
        its(:tail)     { should eq(small_list) }
      end

      context 'complex proper list' do
        let(:bytes) { [0, 0, 0, 6, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 104, 5, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 106] }

        it { should_not be_improper }
        its(:len)      { should eq(6) }
        its(:elements) { should eq([atom, binary, new_float, small_integer, small_tuple, small_list]) }
        its(:tail)     { should eq(erlang_nil) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(elements, tail) }

    let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }
    let(:atom_b) { Erlang::ETF::Atom.new("b").tap(&:serialize) }

    describe 'serialize' do
      subject { term.serialize }

      context 'single improper list' do
        let(:bytes) { [108, 0, 0, 0, 1, 100, 0, 1, 97, 100, 0, 1, 98].pack('C*') }

        let(:elements) { [atom_a] }
        let(:tail)     { atom_b }

        it { should eq(bytes) }
      end

      context 'single proper list' do
        let(:bytes) { [108, 0, 0, 0, 1, 100, 0, 1, 97, 106].pack('C*') }

        let(:elements) { [atom_a] }
        let(:tail)     { erlang_nil }

        it { should eq(bytes) }
      end

      context 'complex improper list' do
        let(:bytes) { [108, 0, 0, 0, 6, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 104, 5, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106].pack('C*') }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }
        let(:tail)     { small_list }

        it { should eq(bytes) }
      end

      context 'complex proper list' do
        let(:bytes) { [108, 0, 0, 0, 6, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 104, 5, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 106].pack('C*') }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }
        let(:tail)     { erlang_nil }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:elements) { [atom_a] }
      let(:tail)     { erlang_nil }
      it { should eq(:list) }
    end

    describe '__ruby_evolve__' do
      context 'single improper list' do
        let(:ruby_obj) { ::Erlang::List[:a].tail(:b) }
        subject { term.__ruby_evolve__ }

        let(:elements) { [atom_a] }
        let(:tail)     { atom_b }

        it { should eq(ruby_obj) }
      end

      context 'single proper list' do
        let(:ruby_obj) { [:a] }
        subject { term.__ruby_evolve__ }

        let(:elements) { [atom_a] }
        let(:tail)     { erlang_nil }

        it { should eq(ruby_obj) }
      end

      context 'complex improper list' do
        let(:ruby_obj) { ::Erlang::List[:test, "test", 1.1, 13, ::Erlang::Tuple[:test, "test", 1.1, 13, ::Erlang::List[:test, "test", 1.1, 13]], ::Erlang::List[:test, "test", 1.1, 13]].tail(::Erlang::List[:test, "test", 1.1, 13]) }
        subject { term.__ruby_evolve__ }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }
        let(:tail)     { small_list }

        it { should eq(ruby_obj) }
      end

      context 'complex proper list' do
        let(:ruby_obj) { ::Erlang::List[:test, "test", 1.1, 13, ::Erlang::Tuple[:test, "test", 1.1, 13, ::Erlang::List[:test, "test", 1.1, 13]], ::Erlang::List[:test, "test", 1.1, 13]] }
        subject { term.__ruby_evolve__ }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }
        let(:tail)     { erlang_nil }

        it { should eq(ruby_obj) }
      end
    end
  end

end
