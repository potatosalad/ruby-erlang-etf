# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF do
  it 'has a version number' do
    expect(Erlang::ETF::VERSION).to_not be_nil
  end

  describe 'decode' do
    context 'without magic byte' do
      subject { -> { Erlang::ETF.decode(StringIO.new("")) } }
      it { should raise_error(NotImplementedError) }
    end
  end

  describe 'encode' do
    context 'when term cannot evolve' do
      subject { -> { Erlang::ETF.encode(Object.new) } }
      it { should raise_error(NotImplementedError) }
    end
  end
end
