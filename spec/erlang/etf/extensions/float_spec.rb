# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Float do
  let(:klass) { ::Float }

  describe '[instance]' do
    let(:instance) { 1.1 }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:new_float) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(Erlang::ETF::NewFloat.new(instance)) }
    end
  end

end
