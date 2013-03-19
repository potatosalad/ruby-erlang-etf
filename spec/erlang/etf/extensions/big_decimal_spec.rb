# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::BigDecimal do
  let(:klass) { ::BigDecimal }

  describe '[instance]' do
    let(:instance) { klass.new(*args) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      let(:args) {[ "1.1" ]}
      it { should eq(:float) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      let(:args) {[ "1.1" ]}
      it { should eq(Erlang::ETF::Float.new(instance)) }
    end
  end

end
