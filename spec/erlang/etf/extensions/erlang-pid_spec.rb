# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::ErlangPid do
  let(:klass) { ::Erlang::Pid }

  describe '[instance]' do
    let(:instance) { klass.new(*args) }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      let(:args) {[ :'nonode@nohost', 100, 10, 1 ]}
      it { should eq(:pid) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      let(:args) {[ :'nonode@nohost', 100, 10, 1 ]}
      it { should eq(
        Erlang::ETF::Pid.new(
          Erlang::ETF::SmallAtom.new("nonode@nohost"),
          100,
          10,
          1
        )
      ) }
    end
  end

end
