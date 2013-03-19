# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Binary do
  let(:term_class) { Erlang::ETF::Binary }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context "ASCII bytes" do
        let(:bytes) { [0, 0, 0, 4, 116, 101, 115, 116] }

        its(:len)  { should eq(4) }
        its(:data) { should eq("test") }
      end

      context "UTF-8 bytes" do
        let(:bytes) { [0, 0, 0, 2, 206, 169] }

        its(:len)  { should eq(2) }
        its(:data) { should eq("Ω") }
      end
    end

    describe 'new' do
      subject { term_class.new(data) }

      context "ASCII" do
        let(:data) { "test" }

        its(:data) { should eq(data) }
      end

      context "UTF-8" do
        let(:data) { "Ω" }

        its(:data) { should eq(data) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(data) }

    describe 'serialize' do
      subject { term.serialize }

      context "ASCII" do
        let(:data)  { "test" } 
        let(:bytes) { [109, 0, 0, 0, 4, 116, 101, 115, 116].pack('C*') }

        it { should eq(bytes) }
      end

      context "UTF-8" do
        let(:data)  { "Ω" } 
        let(:bytes) { [109, 0, 0, 0, 2, 206, 169].pack('C*') }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:data) { "test" }
      it { should eq(:binary) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      context "ASCII" do
        let(:data) { "test" }

        it { should eq("test") }
      end

      context "UTF-8" do
        let(:data) { "Ω" }

        it { should eq("Ω") }
      end
    end
  end

end
