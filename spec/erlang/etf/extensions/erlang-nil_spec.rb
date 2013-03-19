# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangNil do
  let(:klass) { ::Erlang::Nil }

  describe '[instance]' do
    let(:instance) { klass.new }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:nil) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(Erlang::ETF::Nil.new) }
    end
  end

end
