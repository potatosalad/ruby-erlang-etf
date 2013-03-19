# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::NewReference do
  let(:term_class) { Erlang::ETF::NewReference }

  let(:node)     { Erlang::ETF::Atom.new("node@host").tap(&:serialize) }
  let(:ids)      { [1234, 5678] }
  let(:creation) { 1 }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:bytes) { [0, 2, 100, 0, 9, 110, 111, 100, 101, 64, 104, 111, 115, 116, 1, 0, 0, 4, 210, 0, 0, 22, 46] }

      its(:node)     { should eq(node) }
      its(:len)      { should eq(2) }
      its(:creation) { should eq(creation) }
      its(:ids)      { should eq(ids) }
    end

    describe 'new' do
      subject { term_class.new(node, creation, ids) }

      its(:node)     { should eq(node) }
      its(:len)      { should eq(2) }
      its(:creation) { should eq(creation) }
      its(:ids)      { should eq(ids) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(node, creation, ids) }

    describe 'serialize' do
      subject { term.serialize }

      let(:bytes) { [114, 0, 2, 100, 0, 9, 110, 111, 100, 101, 64, 104, 111, 115, 116, 1, 0, 0, 4, 210, 0, 0, 22, 46].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      it { should eq(:new_reference) }
    end

    describe '__ruby_evolve__' do
      let(:ruby_obj) { term }
      subject { term.__ruby_evolve__ }

      it { should eq(ruby_obj) }
    end
  end

end
