# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangList do
  let(:klass) { ::Erlang::List }

  describe '[instance]' do
    let(:instance) { klass[*elements].tail(tail) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'when empty and proper' do
        let(:elements) { [] }
        let(:tail)     { [] }

        it { should eq(:nil) }
      end

      context 'when empty and improper' do
        let(:elements) { [] }
        let(:tail)     { :a }

        it { should eq(:list) }
      end

      context 'when not empty and proper' do
        let(:elements) { [:a] }
        let(:tail)     { [] }

        it { should eq(:list) }
      end

      context 'when not empty and improper' do
        let(:elements) { [:a] }
        let(:tail)     { :a }

        it { should eq(:list) }
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'when empty and proper' do
        let(:elements) { [] }
        let(:tail)     { [] }

        it { should eq(Erlang::ETF::Nil.new) }
      end

      context 'when empty and improper' do
        let(:elements) { [] }
        let(:tail)     { :a }

        it { should eq(Erlang::ETF::List.new([], Erlang::ETF::SmallAtom.new("a"))) }
      end

      context 'when not empty and proper' do
        let(:elements) { [:a] }
        let(:tail)     { [] }

        it { should eq(Erlang::ETF::List.new([Erlang::ETF::SmallAtom.new("a")])) }
      end

      context 'when not empty and improper' do
        let(:elements) { [:a] }
        let(:tail)     { :a }

        it { should eq(Erlang::ETF::List.new([Erlang::ETF::SmallAtom.new("a")], Erlang::ETF::SmallAtom.new("a"))) }
      end
    end
  end

end
