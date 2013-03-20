# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangTuple do
  let(:klass) { ::Erlang::Tuple }

  describe '[instance]' do
    let(:instance) { klass[*elements] }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'when empty' do
        let(:elements) { [] }

        it { should eq(:small_tuple) }
      end

      context 'when arity is less than 256' do
        let(:elements) { [:a] }

        it { should eq(:small_tuple) }
      end

      context 'when arity is greater than or equal to 256' do
        let(:elements) { [[]] * 256 }

        it { should eq(:large_tuple) }
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'when empty' do
        let(:elements) { [] }

        it { should eq(Erlang::ETF::SmallTuple.new([])) }
      end

      context 'when arity is less than 256' do
        let(:elements) { [:a] }

        it { should eq(Erlang::ETF::SmallTuple.new([Erlang::ETF::SmallAtom.new("a")])) }
      end

      context 'when arity is greater than or equal to 256' do
        let(:elements) { [[]] * 256 }

        its(:arity) { should eq(256) }
        it { should be_a(Erlang::ETF::LargeTuple) }
      end
    end
  end

end
