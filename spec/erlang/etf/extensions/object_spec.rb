# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Object do
  let(:klass) { ::Object }

  describe '[instance]' do
    let(:instance) { klass.new }

    describe '__erlang_type__' do
      subject { -> { instance.__erlang_type__ } }

      it { should raise_error(NotImplementedError) }
    end

    describe '__erlang_evolve__' do
      subject { -> { instance.__erlang_evolve__ } }

      it { should raise_error(NotImplementedError) }
    end

    describe '__erlang_dump__' do
      subject { -> { instance.__erlang_dump__("") } }

      it { should raise_error(NotImplementedError) }
    end
  end

end
