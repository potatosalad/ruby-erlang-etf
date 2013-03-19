# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangString do
  let(:klass) { ::Erlang::String }

  describe '[instance]' do
    let(:instance) { klass.new(*args) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      let(:args) {[ "test" ]}
      it { should eq(:string) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      let(:args) {[ "test" ]}
      it { should eq(Erlang::ETF::String.new("test")) }
    end
  end

end
