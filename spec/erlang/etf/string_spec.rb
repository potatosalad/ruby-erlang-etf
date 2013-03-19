# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::String do
  let(:term_class) { Erlang::ETF::String }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context "ASCII bytes" do
        let(:bytes) { [0, 4, 116, 101, 115, 116] }

        its(:len)       { should eq(4) }
        its(:characters) { should eq("test") }
      end

      context "UTF-8 bytes" do
        let(:bytes) { [0, 2, 206, 169] }

        its(:len)       { should eq(2) }
        its(:characters) { should eq("Ω") }
      end
    end

    describe 'new' do
      subject { term_class.new(characters) }

      context "ASCII" do
        let(:characters) { "test" }

        its(:characters) { should eq(characters) }
      end

      context "UTF-8" do
        let(:characters) { "Ω" }

        its(:characters) { should eq(characters) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(characters) }

    describe 'serialize' do
      subject { term.serialize }

      context "ASCII" do
        let(:characters) { "test" } 
        let(:bytes)     { [107, 0, 4, 116, 101, 115, 116].pack('C*') }

        it { should eq(bytes) }
      end

      context "UTF-8" do
        let(:characters) { "Ω" } 
        let(:bytes)     { [107, 0, 2, 206, 169].pack('C*') }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:characters) { "test" }
      it { should eq(:string) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      context "ASCII" do
        let(:ruby_obj)   { ::Erlang::String.new("test") }
        let(:characters) { "test" }

        it { should eq(ruby_obj) }
      end

      context "UTF-8" do
        let(:ruby_obj)   { ::Erlang::String.new("Ω") }
        let(:characters) { "Ω" }

        it { should eq(ruby_obj) }
      end
    end
  end

end
