# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::SmallInteger do
  let(:term_class) { Erlang::ETF::SmallInteger }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:int) { 13 }
      let(:bytes) { [13] }

      its(:int) { should eq(int) }
    end

    describe 'new' do
      subject { term_class.new(int) }

      let(:int) { 13 }

      its(:int) { should eq(int) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(int) }

    describe 'serialize' do
      subject { term.serialize }

      let(:int) { 13 }
      let(:bytes) { [97, 13].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:int) { 13 }
      it { should eq(:small_integer) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      let(:ruby_obj) { 13 }
      let(:int)      { 13 }

      it { should eq(ruby_obj) }
    end
  end

end
