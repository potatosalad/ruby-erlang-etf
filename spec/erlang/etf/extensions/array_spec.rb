# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Array do
  let(:klass) { ::Array }

  describe '[instance]' do
    let(:instance) { klass.new(*args) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'when empty' do
        let(:args) {[ ]}
        it { should eq(:nil) }
      end

      context 'when not empty' do
        let(:args) {[ [:a] ]}
        it { should eq(:list) }
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'when empty' do
        let(:args) {[ ]}
        it { should eq(Erlang::ETF::Nil.new) }
      end

      context 'when not empty' do
        let(:args) {[ [:a] ]}
        it { should eq(Erlang::ETF::List.new([Erlang::ETF::SmallAtom.new("a")])) }
      end
    end
  end

end
