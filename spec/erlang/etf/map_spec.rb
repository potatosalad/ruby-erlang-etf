# encoding: utf-8

require 'spec_helper'
require 'pry'

describe Erlang::ETF::Map do
  let(:term_class) { Erlang::ETF::Map }

  let(:atom)          { Erlang::ETF::SmallAtom.new("test").tap(&:serialize) }
  let(:binary)        { Erlang::ETF::Binary.new("test").tap(&:serialize) }
  let(:new_float)     { Erlang::ETF::NewFloat.new(1.1) }
  let(:small_integer) { Erlang::ETF::SmallInteger.new(13) }
  let(:small_list)    { Erlang::ETF::List.new([atom, binary, new_float, small_integer]) }
  let(:erlang_nil)    { Erlang::ETF::Nil.new }
  let(:small_tuple)   { Erlang::ETF::SmallTuple.new([atom, binary, new_float, small_integer, small_list]) }
  let(:small_map)     { Erlang::ETF::Map.new([atom, binary, new_float], [small_integer, erlang_nil, small_list]) }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context 'single item map' do
        let(:bytes) { [0, 0, 0, 1, 100, 0, 1, 97, 106] }
        let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }

        its(:size)   { should eq(1) }
        its(:keys)   { should eq([atom_a]) }
        its(:values) { should eq([erlang_nil]) }
      end

      context 'multiple item map' do
        let(:bytes) { [0, 0, 0, 3, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106] }

        its(:size)   { should eq(3) }
        its(:keys)   { should eq([atom, binary, new_float]) }
        its(:values) { should eq([small_integer, erlang_nil, small_list]) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(keys, values) }

    let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }

    describe 'serialize' do
      subject { term.serialize }

      context 'single item map' do
        let(:bytes) { [116, 0, 0, 0, 1, 100, 0, 1, 97, 106].pack('C*') }

        let(:keys)   { [atom_a] }
        let(:values) { [erlang_nil] }

        it { should eq(bytes) }
      end

      context 'multiple item map' do
        let(:bytes) { [116, 0, 0, 0, 3, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 116, 0, 0, 0, 3, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106].pack('C*') }

        let(:keys)   { [atom, binary, new_float] }
        let(:values) { [small_integer, small_map, small_list] }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:keys)   { [atom_a] }
      let(:values) { [erlang_nil] }
      it { should eq(:map) }
    end

    describe '__ruby_evolve__' do
      context 'single item map' do
        let(:ruby_obj) { ::Erlang::Map[:a, :a] }
        subject { term.__ruby_evolve__ }

        let(:keys)   { [atom_a] }
        let(:values) { [atom_a] }

        it { should eq(ruby_obj) }
      end

      context 'multiple item map' do
        let(:ruby_obj) { ::Erlang::Map[:test, "test", 1.1, 13, ::Erlang::Tuple[:test, "test", 1.1, 13, ::Erlang::List[:test, "test", 1.1, 13]], ::Erlang::List[:test, "test", 1.1, 13]] }
        subject { term.__ruby_evolve__ }

        let(:keys)   { [atom, new_float, small_tuple] }
        let(:values) { [binary, small_integer, small_list] }

        it { should eq(ruby_obj) }
      end
    end
  end

end
