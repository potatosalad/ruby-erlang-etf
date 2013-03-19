# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::SmallBig do
  let(:term_class) { Erlang::ETF::SmallBig }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      let(:n)       { 128 }
      let(:sign)    { 0 }
      let(:integer) { (+1 << (128 * 8)) - 1 }
      let(:bytes)   { [128, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255] }

      its(:n)       { should eq(n) }
      its(:sign)    { should eq(sign) }
      its(:integer) { should eq(integer) }
    end

    describe 'new' do
      subject { term_class.new(integer).tap(&:serialize) }

      let(:n)       { 128 }
      let(:sign)    { 1 }
      let(:integer) { (-1 << (128 * 8)) + 1 }

      its(:n)       { should eq(n) }
      its(:sign)    { should eq(sign) }
      its(:integer) { should eq(integer) }
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(integer) }

    describe 'serialize' do
      subject { term.serialize }

      let(:n)       { 128 }
      let(:sign)    { 1 }
      let(:integer) { (-1 << (128 * 8)) + 1 }
      let(:bytes)   { [110, 128, 1, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255].pack('C*') }

      it { should eq(bytes) }
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:integer) { (+1 << (128 * 8)) - 1 }
      it { should eq(:small_big) }
    end

    describe '__ruby_evolve__' do
      subject { term.__ruby_evolve__ }

      let(:ruby_obj) { (+1 << (128 * 8)) - 1 }
      let(:integer)  { (+1 << (128 * 8)) - 1 }

      it { should eq(ruby_obj) }
    end
  end

end
