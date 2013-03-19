# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Regexp do
  let(:klass) { ::Regexp }

  describe '[instance]' do
    let(:instance) { /./imx }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:bert_regex) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(
        Erlang::ETF::SmallTuple.new([
          Erlang::ETF::SmallAtom.new("bert"),
          Erlang::ETF::SmallAtom.new("regex"),
          Erlang::ETF::Binary.new("."),
          Erlang::ETF::List.new([
            Erlang::ETF::SmallAtom.new("caseless"),
            Erlang::ETF::SmallAtom.new("extended"),
            Erlang::ETF::SmallAtom.new("multiline")
          ])
        ])
      ) }
    end
  end

end
