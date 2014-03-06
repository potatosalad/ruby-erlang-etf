# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangMap do
  let(:klass) { ::Erlang::Map }

  describe '[instance]' do
    let(:instance) { klass[keys.zip(values)] }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'when empty' do
        let(:keys)   { [] }
        let(:values) { [] }

        it { should eq(:map) }
      end

      context 'when not empty' do
        let(:keys)   { [:a] }
        let(:values) { [1] }

        it { should eq(:map) }
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'when empty' do
        let(:keys)   { [] }
        let(:values) { [] }

        it { should eq(Erlang::ETF::Map.new([], [])) }
      end

      context 'when not empty' do
        let(:keys)   { [:a] }
        let(:values) { [1] }

        it { should eq(Erlang::ETF::Map.new([Erlang::ETF::SmallAtom.new("a")], [Erlang::ETF::SmallInteger.new(1)])) }
      end
    end
  end

end
