# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Atom do
  let(:term_class) { Erlang::ETF::Atom }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context "ASCII bytes" do
        let(:bytes) { [0, 4, 116, 101, 115, 116] }

        its(:len)       { should eq(4) }
        its(:atom_name) { should eq("test") }
      end

      context "UTF-8 bytes" do
        let(:bytes) { [0, 2, 206, 169] }

        its(:len)       { should eq(2) }
        its(:atom_name) { should eq("Ω") }
      end
    end

    describe 'new' do
      subject { term_class.new(atom_name) }

      context "ASCII" do
        let(:atom_name) { "test" }

        its(:atom_name) { should eq(atom_name) }
      end

      context "UTF-8" do
        let(:atom_name) { "Ω" }

        its(:atom_name) { should eq(atom_name) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(atom_name) }

    describe 'serialize' do
      subject { term.serialize }

      context "ASCII" do
        let(:atom_name) { "test" } 
        let(:bytes)     { [100, 0, 4, 116, 101, 115, 116].pack('C*') }

        it { should eq(bytes) }
      end

      context "UTF-8" do
        let(:atom_name) { "Ω" } 
        let(:bytes)     { [100, 0, 2, 206, 169].pack('C*') }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:atom_name) { "test" }
      it { should eq(:atom) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      context "ASCII" do
        let(:atom_name) { "test" }

        it { should eq(:test) }
      end

      context "UTF-8" do
        let(:atom_name) { "Ω" }

        it { should eq(:'Ω') }
      end
    end
  end

end
