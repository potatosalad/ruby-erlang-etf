# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Nil do
  let(:term_class) { Erlang::ETF::Nil }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:bytes) { [] }

      it { should eq(term_class.new) }
    end

    describe 'new' do
      subject { term_class.new }

      it { should eq(term_class.new) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new }

    describe 'serialize' do
      subject { term.serialize }

      let(:bytes) { [106].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      it { should eq(:nil) }
    end

    describe '__ruby_evolve__' do
      let(:ruby_obj) { [] }
      subject { term.__ruby_evolve__ }

      it { should eq(ruby_obj) }
    end
  end

end
