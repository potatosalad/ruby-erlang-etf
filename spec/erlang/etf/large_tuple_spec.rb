# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::LargeTuple do
  let(:term_class) { Erlang::ETF::LargeTuple }

  let(:atom)          { Erlang::ETF::SmallAtom.new("test").tap(&:serialize) }
  let(:binary)        { Erlang::ETF::Binary.new("test").tap(&:serialize) }
  let(:new_float)     { Erlang::ETF::NewFloat.new(1.1) }
  let(:small_integer) { Erlang::ETF::SmallInteger.new(13) }
  let(:small_list)    { Erlang::ETF::List.new([atom, binary, new_float, small_integer]) }
  let(:small_tuple)   { Erlang::ETF::SmallTuple.new([atom, binary, new_float, small_integer, small_list]) }

  let(:erlang_nil) { Erlang::ETF::Nil.new }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context 'single item tuple' do
        let(:bytes) { [0, 0, 0, 1, 100, 0, 1, 97] }
        let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }

        its(:arity)    { should eq(1) }
        its(:elements) { should eq([atom_a]) }
      end

      context 'multiple item tuple' do
        let(:bytes) { [0, 0, 0, 6, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 104, 5, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106] }

        its(:arity)    { should eq(6) }
        its(:elements) { should eq([atom, binary, new_float, small_integer, small_tuple, small_list]) }
      end

      context 'very large tuple' do
        let(:bytes) { [0, 0, 1, 0, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106] }

        its(:arity)    { should eq(256) }
        its(:elements) { should eq([erlang_nil] * 256) }
      end
    end
  end

  describe '[instance]' do
    let(:term) { term_class.new(elements) }

    let(:atom_a) { Erlang::ETF::Atom.new("a").tap(&:serialize) }

    describe 'serialize' do
      subject { term.serialize }

      context 'single item tuple' do
        let(:bytes) { [105, 0, 0, 0, 1, 100, 0, 1, 97].pack('C*') }

        let(:elements) { [atom_a] }

        it { should eq(bytes) }
      end

      context 'multiple item tuple' do
        let(:bytes) { [105, 0, 0, 0, 6, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 104, 5, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106, 108, 0, 0, 0, 4, 115, 4, 116, 101, 115, 116, 109, 0, 0, 0, 4, 116, 101, 115, 116, 70, 63, 241, 153, 153, 153, 153, 153, 154, 97, 13, 106].pack('C*') }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }

        it { should eq(bytes) }
      end
    end

    describe 'serialize_header' do
      subject { term.serialize_header("") }

      context 'single item tuple' do
        let(:bytes) { [105, 0, 0, 0, 1].pack('C*') }

        let(:elements) { [atom_a] }

        it { should eq(bytes) }
      end

      context 'multiple item tuple' do
        let(:bytes) { [105, 0, 0, 0, 6].pack('C*') }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }

        it { should eq(bytes) }
      end
    end

    describe '__erlang_type__' do
      subject { term.__erlang_type__ }

      let(:elements) { [atom_a] }
      it { should eq(:large_tuple) }
    end

    describe '__ruby_evolve__' do
      context 'single item tuple' do
        let(:ruby_obj) { ::Erlang::Tuple[:a] }
        subject { term.__ruby_evolve__ }

        let(:elements) { [atom_a] }

        it { should eq(ruby_obj) }
      end

      context 'multiple item tuple' do
        let(:ruby_obj) { ::Erlang::Tuple[:test, "test", 1.1, 13, ::Erlang::Tuple[:test, "test", 1.1, 13, ::Erlang::List[:test, "test", 1.1, 13]], ::Erlang::List[:test, "test", 1.1, 13]] }
        subject { term.__ruby_evolve__ }

        let(:elements) { [atom, binary, new_float, small_integer, small_tuple, small_list] }

        it { should eq(ruby_obj) }
      end
    end
  end

end
