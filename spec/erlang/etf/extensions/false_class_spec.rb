# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::FalseClass do
  let(:klass) { ::FalseClass }

  describe '[instance]' do
    let(:instance) { false }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:bert_boolean) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(
        Erlang::ETF::SmallTuple.new([
          Erlang::ETF::SmallAtom.new("bert"),
          Erlang::ETF::SmallAtom.new("false")
        ])
      ) }
    end
  end

end
