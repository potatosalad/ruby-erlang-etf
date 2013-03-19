# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Export do
  let(:term_class) { Erlang::ETF::Export }

  let(:mod)      { Erlang::ETF::Atom.new("erlang").tap(&:serialize) }
  let(:function) { Erlang::ETF::Atom.new("now").tap(&:serialize) }
  let(:arity)    { Erlang::ETF::SmallInteger.new(0).tap(&:serialize) }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:bytes) { [100, 0, 6, 101, 114, 108, 97, 110, 103, 100, 0, 3, 110, 111, 119, 97, 0] }

      its(:mod)      { should eq(mod) }
      its(:function) { should eq(function) }
      its(:arity)    { should eq(arity) }
    end

    describe 'new' do
      subject { term_class.new(mod, function, arity) }

      its(:mod)      { should eq(mod) }
      its(:function) { should eq(function) }
      its(:arity)    { should eq(arity) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(mod, function, arity) }

    describe 'serialize' do
      subject { term.serialize }

      let(:bytes) { [113, 100, 0, 6, 101, 114, 108, 97, 110, 103, 100, 0, 3, 110, 111, 119, 97, 0].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      it { should eq(:export) }
    end

    describe '__ruby_evolve__' do
      let(:ruby_obj) { ::Erlang::Export.new(:erlang, :now, 0) }
      subject { term.__ruby_evolve__ }

      it { should eq(ruby_obj) }
    end
  end

end
