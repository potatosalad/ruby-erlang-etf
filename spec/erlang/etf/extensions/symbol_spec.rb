# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Symbol do
  let(:klass) { ::Symbol }

  describe '[instance]' do
    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context 'when bytesize is < 256' do
        let(:instance) { :a }
        it { should eq(:small_atom) }

        context 'when it contains UTF-8 characters' do
          let(:instance) { :'Ω' }
          it { should eq(:small_atom_utf8) }
        end
      end

      context 'when bytesize is >= 256' do
        let(:instance) { ("a" * 256).intern }
        it { should eq(:atom) }

        context 'when it contains UTF-8 characters' do
          let(:instance) { ("Ω" * 256).intern }
          it { should eq(:atom_utf8) }
        end
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context 'when bytesize is < 256' do
        let(:instance) { :a }
        it { should eq(Erlang::ETF::SmallAtom.new(instance.to_s)) }

        context 'when it contains UTF-8 characters' do
          let(:instance) { :'Ω' }
          it { should eq(Erlang::ETF::SmallAtomUTF8.new(instance.to_s)) }
        end
      end

      context 'when bytesize is >= 256' do
        let(:instance) { ("a" * 256).intern }
        it { should eq(Erlang::ETF::Atom.new(instance.to_s)) }

        context 'when it contains UTF-8 characters' do
          let(:instance) { ("Ω" * 256).intern }
          it { should eq(Erlang::ETF::AtomUTF8.new(instance.to_s)) }
        end
      end
    end

    describe 'to_utf8_binary' do
      it "converts :Ω to \"\\xCE\\xA9\"" do
        expect(:'Ω'.to_utf8_binary).to eq("\xCE\xA9".force_encoding('BINARY'))
      end
    end
  end

end
