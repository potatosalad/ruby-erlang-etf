# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Hash do
  let(:klass) { ::Hash }

  describe '[instance]' do
    let(:instance) { klass[*keyvalues] }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'when empty' do
        let(:keyvalues) { [] }

        it { should eq(:bert_dict) }
      end

      context 'when arity is less than 256' do
        let(:keyvalues) { [:a, 1] }

        it { should eq(:bert_dict) }
      end

      context 'when arity is greater than or equal to 256' do
        let(:keyvalues) { (1..256).zip([Erlang::Nil.new] * 256).flatten }

        it { should eq(:bert_dict) }
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'when empty' do
        let(:keyvalues) { [] }

        it { should eq(
          Erlang::ETF::SmallTuple.new([
            Erlang::ETF::SmallAtom.new("bert"),
            Erlang::ETF::SmallAtom.new("dict"),
            Erlang::ETF::Nil.new
          ])
        ) }
      end

      context 'when arity is less than 256' do
        let(:keyvalues) { [:a, 1] }

        it { should eq(
          Erlang::ETF::SmallTuple.new([
            Erlang::ETF::SmallAtom.new("bert"),
            Erlang::ETF::SmallAtom.new("dict"),
            Erlang::ETF::List.new([
              Erlang::ETF::SmallTuple.new([
                Erlang::ETF::SmallAtom.new("a"),
                Erlang::ETF::SmallInteger.new(1)
              ])
            ])
          ])
        ) }
      end

      context 'when arity is greater than or equal to 256' do
        let(:keyvalues) { (1..256).zip([Erlang::Nil.new] * 256).flatten }

        let(:elements) {
          elements = []
          1.upto(256) do |i|
            elements << Erlang::ETF::SmallTuple.new([
              i.__erlang_evolve__,
              Erlang::ETF::Nil.new
            ])
          end
          elements
        }

        it { should eq(
          Erlang::ETF::SmallTuple.new([
            Erlang::ETF::SmallAtom.new("bert"),
            Erlang::ETF::SmallAtom.new("dict"),
            Erlang::ETF::List.new(elements)
          ])
        ) }
      end
    end
  end

end
