# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Terms do
  describe 'deserialize' do
    context 'with unknown Erlang External Format tag' do
      subject { -> { Erlang::ETF::Terms.deserialize(buffer) } }
      let(:buffer) { StringIO.new([82].pack('C*')) }

      it { should raise_error(NotImplementedError) }
    end
  end

  describe 'evolve' do
    context 'with unknown Erlang External Format tag' do
      subject { -> { Erlang::ETF::Terms.evolve(buffer) } }
      let(:buffer) { StringIO.new([82].pack('C*')) }

      it { should raise_error(NotImplementedError) }
    end
  end
end
