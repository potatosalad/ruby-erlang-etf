# encoding: utf-8

require 'spec_helper'
require 'pry'

describe Erlang::ETF::Map do
  let(:term_class) { Erlang::ETF::Map }

  let(:atom)          { Erlang::ETF::Atom.new("test").tap(&:serialize) }
  let(:binary)        { Erlang::ETF::Binary.new("test").tap(&:serialize) }
  let(:new_float)     { Erlang::ETF::NewFloat.new(1.1) }
  let(:small_integer) { Erlang::ETF::SmallInteger.new(13) }
  let(:small_list)    { Erlang::ETF::List.new([atom, binary, new_float, small_integer]) }
  #let(:small_list)    { Erlang::ETF::List.new([atom, binary, new_float, small_integer]) }
  let(:erlang_nil)    { Erlang::ETF::Nil.new }
  let(:small_tuple)   { Erlang::ETF::SmallTuple.new([atom, binary, new_float, small_integer, small_list]) }
  #let(:small_map)     { Erlang::ETF::Map.new([atom, binary, new_float], [small_integer, erlang_nil, small_list]) }
  let(:small_map)     { Erlang::ETF::Map.new([atom, small_integer, binary, erlang_nil, new_float, small_list]) }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context 'single item map' do
        let(:bytes) { [0, 0, 0, 1, 100, 0, 1, 97, 100, 0, 3, 110, 105, 108] }
        let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }

        its(:size)   { should eq(1) }
        its(:elements)   { should eq([ atom_a, Erlang::ETF::Atom.new("nil")]) }
      end

      context 'multiple item map' do
        let(:bytes) { [0, 0, 0, 3, 70, 63, 241, 153, 153, 153, 153, 153, 154, 108, 0, 0, 0, 4, 100, 0, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 100, 0, 4, 116, 101, 115, 116, 97, 13, 109, 0, 0, 0, 4, 116, 101, 115, 116, 106] }
        #%{1.1 => [:test, "test", 1.1, 13], :test => 13, "test" => []}

        its(:size)   { should eq(3) }
        its(:elements)   { should eq([new_float, small_list, atom, small_integer, binary, erlang_nil]) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(elements) }

    let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }

    describe 'serialize' do
      subject { term.serialize.bytes }

      context 'single item map' do
        #let(:bytes) { [116, 0, 0, 0, 1, 100, 0, 1, 97, 106].pack('C*') }
        let(:bytes) { [116, 0, 0, 0, 1, 100, 0, 1, 97, 106] }

        let(:elements) { [atom_a, erlang_nil] }

        it { should eq(bytes) }
      end

      context 'multiple item map' do
        let(:bytes) { [116, 0, 0, 0, 3, 100, 0, 4, 116, 101, 115, 116, 97, 13, 109, 0, 0, 0, 4, 116, 101, 115, 116, 116, 0, 0, 0, 3, 100, 0, 4, 116, 101, 115, 116, 97, 13, 109, 0, 0, 0, 4, 116, 101, 115, 116, 106, 70, 63, 241, 153, 153, 153, 153, 153, 154, 108, 0, 0, 0, 4, 100, 0, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 70, 63, 241, 153, 153, 153, 153, 153, 154, 108, 0, 0, 0, 4, 100, 0, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106] }

        let(:elements)   { [atom, small_integer, binary, small_map, new_float, small_list] }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:elements)   { [atom_a, erlang_nil] }

      it { should eq(:map) }
    end

    describe '__ruby_evolve__' do
      context 'single item map' do
        let(:ruby_obj) { ::Erlang::Map[:a, :a] }
        subject { term.__ruby_evolve__ }

        let(:elements)   { [atom_a, atom_a] }
        
        it { should eq(ruby_obj) }
      end

      context 'multiple item map' do
        let(:ruby_obj) { ::Erlang::Map[:test, "test", 1.1, 13, ::Erlang::Tuple[:test, "test", 1.1, 13, ::Erlang::List[:test, "test", 1.1, 13]], ::Erlang::List[:test, "test", 1.1, 13]] }
        subject { term.__ruby_evolve__ }

        let(:elements)   { [atom, binary, new_float, small_integer, small_tuple, small_list] }

        it { should eq(ruby_obj) }
      end
    end
  end

end
