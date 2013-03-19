# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::NewFloat do
  let(:term_class) { Erlang::ETF::NewFloat }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context 'with 2 significant digits' do
        let(:float) { 1.1 }
        let(:bytes) { [63, 241, 153, 153, 153, 153, 153, 154] }

        its(:float) { should eq(float) }
      end

      context 'with 16 significant digits' do
        let(:float) { 0.001122334455667789 }
        let(:bytes) { [63, 82, 99, 105, 114, 16, 170, 24] }

        its(:float) { should eq(float) }
      end
    end

    describe 'new' do
      subject { term_class.new(float) }

      context 'with 2 significant digits' do
        let(:float) { -1.1 }

        its(:float) { should eq(float) }
      end

      context 'with 16 significant digits' do
        let(:float) { 0.001122334455667789 }

        its(:float) { should eq(float) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(float) }

    describe 'serialize' do
      subject { term.serialize }

      context 'with 2 significant digits' do
        let(:float) { -1.1 }
        let(:bytes) { [70, 191, 241, 153, 153, 153, 153, 153, 154].pack('C*') }

        it { should eq(bytes) }
      end

      context 'with 16 significant digits' do
        let(:float) { 0.001122334455667789 }
        let(:bytes) { [70, 63, 82, 99, 105, 114, 16, 170, 24].pack('C*') }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:float) { 1.1 }
      it { should eq(:new_float) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      context 'with 2 significant digits' do
        let(:ruby_obj) { -1.1 }
        let(:float)    { -1.1 }

        it { should eq(ruby_obj) }
      end

      context 'with 16 significant digits' do
        let(:ruby_obj) { 0.001122334455667789 }
        let(:float)    { 0.001122334455667789 }

        it { should eq(ruby_obj) }
      end
    end
  end

end
