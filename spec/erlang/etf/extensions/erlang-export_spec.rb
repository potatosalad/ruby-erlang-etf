# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangExport do
  let(:klass) { ::Erlang::Export }

  describe '[instance]' do
    let(:instance) { klass.new(*args) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      let(:args) {[ :erlang, :now, 0 ]}
      it { should eq(:export) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      let(:args) {[ :erlang, :now, 0 ]}
      it { should eq(
        Erlang::ETF::Export.new(
          Erlang::ETF::SmallAtom.new("erlang"),
          Erlang::ETF::SmallAtom.new("now"),
          Erlang::ETF::SmallInteger.new(0)
        )
      ) }
    end
  end

end
