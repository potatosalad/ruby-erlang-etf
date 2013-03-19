# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Float do
  let(:term_class) { Erlang::ETF::Float }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context 'with 2 significant digits' do
        let(:float_string) { "1.10000000000000000000e+00\0\0\0\0\0" }
        let(:bytes) { [49, 46, 49, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 101, 43, 48, 48, 0, 0, 0, 0, 0] }

        its(:float_string) { should eq(float_string) }
      end

      context 'with 21 significant digits' do
        let(:float_string) { "1.12233445566778899001e-03\0\0\0\0\0" }
        let(:bytes) { [49, 46, 49, 50, 50, 51, 51, 52, 52, 53, 53, 54, 54, 55, 55, 56, 56, 57, 57, 48, 48, 49, 101, 45, 48, 51, 0, 0, 0, 0, 0] }

        its(:float_string) { should eq(float_string) }
      end
    end

    describe 'new' do
      subject { term_class.new(float_string) }

      context 'with 2 significant digits as BigDecimal' do
        let(:float_string) { BigDecimal.new("-1.1") }

        its(:float_string) { should eq(float_string) }
      end

      context 'with 21 significant digits as String' do
        let(:float_string) { "1.12233445566778899001e-03\0\0\0\0\0" }

        its(:float_string) { should eq(float_string) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(float_string) }

    describe 'serialize' do
      subject { term.serialize }

      context 'with 2 significant digits as BigDecimal' do
        let(:float_string) { BigDecimal.new("-1.1") }
        let(:bytes) { [99, 45, 49, 46, 49, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 56, 56, 56, 50, 101, 43, 48, 48, 0, 0, 0, 0].pack('C*') }

        it { should eq(bytes) }
      end

      context 'with 21 significant digits as String' do
        let(:float_string) { "1.12233445566778899001e-03\0\0\0\0\0" }
        let(:bytes) { [99, 49, 46, 49, 50, 50, 51, 51, 52, 52, 53, 53, 54, 54, 55, 55, 56, 56, 57, 57, 48, 48, 49, 101, 45, 48, 51, 0, 0, 0, 0, 0].pack('C*') }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:float_string) { BigDecimal.new("1.1") }
      it { should eq(:float) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      context 'with 2 significant digits as BigDecimal' do
        let(:ruby_obj)     { BigDecimal.new("1.1") }
        let(:float_string) { BigDecimal.new("1.1") }

        it { should eq(ruby_obj) }
      end

      context 'with 21 significant digits as String' do
        let(:ruby_obj)     { BigDecimal.new("0.00112233445566778899001") }
        let(:float_string) { "1.12233445566778899001e-03\0\0\0\0\0" }

        it { should eq(ruby_obj) }
      end
    end
  end

end
