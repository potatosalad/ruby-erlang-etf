# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangString do
  let(:klass) { ::Erlang::String }

  describe '[instance]' do
    let(:instance) { klass.new(*args) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'simple string' do
        let(:args) {[ "test" ]}
        it { should eq(:string) }
      end

      context 'when bytesize larger than 1 << 16' do
        let(:args) {[ "a" * (1 << 16) ]}
        it { should eq(:list) }
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'simple string' do
        let(:args) {[ "test" ]}
        it { should eq(Erlang::ETF::String.new("test")) }
      end

      context 'when bytesize larger than 1 << 16' do
        let(:args) {[ "a" * (1 << 16) ]}
        its(:len) { should eq(1 << 16) }
        it { should be_a(Erlang::ETF::List) }
      end
    end
  end

end
