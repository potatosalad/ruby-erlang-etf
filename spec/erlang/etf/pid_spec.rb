# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Pid do
  let(:term_class) { Erlang::ETF::Pid }

  let(:node)     { Erlang::ETF::Atom.new("node@host").tap(&:serialize) }
  let(:id)       { 1234 }
  let(:serial)   { 13 }
  let(:creation) { 1 }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:bytes) { [100, 0, 9, 110, 111, 100, 101, 64, 104, 111, 115, 116, 0, 0, 4, 210, 0, 0, 0, 13, 1] }

      its(:node)     { should eq(node) }
      its(:id)       { should eq(id) }
      its(:serial)   { should eq(serial) }
      its(:creation) { should eq(creation) }
    end

    describe 'new' do
      subject { term_class.new(node, id, serial, creation) }

      its(:node)     { should eq(node) }
      its(:id)       { should eq(id) }
      its(:serial)   { should eq(serial) }
      its(:creation) { should eq(creation) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(node, id, serial, creation) }

    describe 'serialize' do
      subject { term.serialize }

      let(:bytes) { [103, 100, 0, 9, 110, 111, 100, 101, 64, 104, 111, 115, 116, 0, 0, 4, 210, 0, 0, 0, 13, 1].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      it { should eq(:pid) }
    end

    describe '__ruby_evolve__' do
      let(:ruby_obj) { ::Erlang::Pid.new(:'node@host', 1234, 13, 1) }
      subject { term.__ruby_evolve__ }

      it { should eq(ruby_obj) }
    end
  end

end
