# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::BitBinary do
  let(:term_class) { Erlang::ETF::BitBinary }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context "ASCII bytes" do
        let(:bytes) { [0, 0, 0, 5, 1, 116, 101, 115, 116, 128] }

        its(:len)  { should eq(5) }
        its(:bits) { should eq(1) }
        its(:data) { should eq("test\x80") }
      end

      context "UTF-8 bytes" do
        let(:bytes) { [0, 0, 0, 3, 1, 206, 169, 128] }

        its(:len)  { should eq(3) }
        its(:bits) { should eq(1) }
        its(:data) { should eq("Ω\x80") }
      end
    end

    describe 'new' do
      subject { term_class.new(bits, data) }

      context "ASCII" do
        let(:bits) { 1 }
        let(:data) { "test\x80" }

        its(:data) { should eq(data) }
      end

      context "UTF-8" do
        let(:bits) { 1 }
        let(:data) { "Ω\x80" }

        its(:data) { should eq(data) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(bits, data) }

    describe 'serialize' do
      subject { term.serialize }

      context "ASCII" do
        let(:bits)  { 1 }
        let(:data)  { "test\x80" } 
        let(:bytes) { [77, 0, 0, 0, 5, 1, 116, 101, 115, 116, 128].pack('C*') }

        it { should eq(bytes) }
      end

      context "UTF-8" do
        let(:bits)  { 1 }
        let(:data)  { "Ω\x80" } 
        let(:bytes) { [77, 0, 0, 0, 3, 1, 206, 169, 128].pack('C*') }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:bits) { 1 }
      let(:data) { "test\x80" }
      it { should eq(:bit_binary) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      context "ASCII" do
        let(:bits) { 1 }
        let(:data) { "test\x80" }

        it { should eq(term) }
      end

      context "UTF-8" do
        let(:bits) { 1 }
        let(:data) { "Ω\x80" }

        it { should eq(term) }
      end
    end
  end

end
