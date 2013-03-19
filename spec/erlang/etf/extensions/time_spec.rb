# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Time do
  let(:klass) { ::Time }

  describe '[instance]' do
    let(:instance) { klass.at(1363190400) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:bert_time) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(
        Erlang::ETF::SmallTuple.new([
          Erlang::ETF::SmallAtom.new("bert"),
          Erlang::ETF::SmallAtom.new("time"),
          Erlang::ETF::Integer.new(1363),
          Erlang::ETF::Integer.new(190400),
          Erlang::ETF::SmallInteger.new(0)
        ])
      ) }
    end
  end

end
