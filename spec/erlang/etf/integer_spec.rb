# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Integer do
  let(:term_class) { Erlang::ETF::Integer }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:int) { 3_13_1988 }
      let(:bytes) { [0, 47, 202, 84] }

      its(:int) { should eq(int) }
    end

    describe 'new' do
      subject { term_class.new(int) }

      let(:int) { 3_13_1988 }

      its(:int) { should eq(int) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(int) }

    describe 'serialize' do
      subject { term.serialize }

      let(:int) { 3_13_1988 }
      let(:bytes) { [98, 0, 47, 202, 84].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:int) { 3_13_1988 }
      it { should eq(:integer) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      let(:ruby_obj) { 3_13_1988 }
      let(:int)      { 3_13_1988 }

      it { should eq(ruby_obj) }
    end
  end

end
