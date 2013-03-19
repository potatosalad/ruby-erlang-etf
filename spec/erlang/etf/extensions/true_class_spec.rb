# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::TrueClass do
  let(:klass) { ::TrueClass }

  describe '[instance]' do
    let(:instance) { true }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:bert_boolean) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(
        Erlang::ETF::SmallTuple.new([
          Erlang::ETF::SmallAtom.new("bert"),
          Erlang::ETF::SmallAtom.new("true")
        ])
      ) }
    end
  end

end
