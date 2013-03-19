# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::Integer do
  let(:klass) { ::Integer }

  let(:small_integer_min) { Erlang::ETF::Extensions::Integer::UINT8_MIN }
  let(:small_integer_max) { Erlang::ETF::Extensions::Integer::UINT8_MAX }
  let(:integer_min)       { Erlang::ETF::Extensions::Integer::INT32_MIN }
  let(:integer_max)       { Erlang::ETF::Extensions::Integer::INT32_MAX }
  let(:small_big_min)     { (-1 << (255 * 8)) + 1 }
  let(:small_big_max)     { (+1 << (255 * 8)) - 1 }

  describe '[instance]' do
    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      context "when between #{Erlang::ETF::Extensions::Integer::UINT8_MIN} and #{Erlang::ETF::Extensions::Integer::UINT8_MAX}" do
        let(:min) { small_integer_min }
        let(:max) { small_integer_max }

        let(:current)  { :small_integer }
        let(:positive) { :integer }
        let(:negative) { :integer }

        context 'minimum' do
          let(:instance) { min }
          it { should eq(current) }
        end

        context 'minimum + 1' do
          let(:instance) { min + 1 }
          it { should eq(current) }
        end

        context 'minimum - 1' do
          let(:instance) { min - 1 }
          it { should eq(negative) }
        end

        context 'maximum' do
          let(:instance) { max }
          it { should eq(current) }
        end

        context 'maximum + 1' do
          let(:instance) { max + 1 }
          it { should eq(positive) }
        end

        context 'maximum - 1' do
          let(:instance) { max - 1 }
          it { should eq(current) }
        end
      end

      context "when between #{Erlang::ETF::Extensions::Integer::INT32_MIN} and #{Erlang::ETF::Extensions::Integer::INT32_MAX}" do
        let(:min) { integer_min }
        let(:max) { integer_max }

        let(:current)  { :integer }
        let(:positive) { :small_big }
        let(:negative) { :small_big }

        context 'minimum' do
          let(:instance) { min }
          it { should eq(current) }
        end

        context 'minimum + 1' do
          let(:instance) { min + 1 }
          it { should eq(current) }
        end

        context 'minimum - 1' do
          let(:instance) { min - 1 }
          it { should eq(negative) }
        end

        context 'maximum' do
          let(:instance) { max }
          it { should eq(current) }
        end

        context 'maximum + 1' do
          let(:instance) { max + 1 }
          it { should eq(positive) }
        end

        context 'maximum - 1' do
          let(:instance) { max - 1 }
          it { should eq(current) }
        end
      end

      context "when between ((-1 << (255 * 8)) + 1) and ((+1 << (255 * 8)) - 1)" do
        let(:min) { small_big_min }
        let(:max) { small_big_max }

        let(:current)  { :small_big }
        let(:positive) { :large_big }
        let(:negative) { :large_big }

        context 'minimum' do
          let(:instance) { min }
          it { should eq(current) }
        end

        context 'minimum + 1' do
          let(:instance) { min + 1 }
          it { should eq(current) }
        end

        context 'minimum - 1' do
          let(:instance) { min - 1 }
          it { should eq(negative) }
        end

        context 'maximum' do
          let(:instance) { max }
          it { should eq(current) }
        end

        context 'maximum + 1' do
          let(:instance) { max + 1 }
          it { should eq(positive) }
        end

        context 'maximum - 1' do
          let(:instance) { max - 1 }
          it { should eq(current) }
        end
      end
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      context "when >= #{Erlang::ETF::Extensions::Integer::UINT8_MIN} and <= #{Erlang::ETF::Extensions::Integer::UINT8_MAX}" do
        let(:min) { small_integer_min }
        let(:max) { small_integer_max }

        let(:current)  { Erlang::ETF::SmallInteger.new(instance) }
        let(:positive) { Erlang::ETF::Integer.new(instance) }
        let(:negative) { Erlang::ETF::Integer.new(instance) }

        context 'minimum' do
          let(:instance) { min }
          it { should eq(current) }
        end

        context 'minimum + 1' do
          let(:instance) { min + 1 }
          it { should eq(current) }
        end

        context 'minimum - 1' do
          let(:instance) { min - 1 }
          it { should eq(negative) }
        end

        context 'maximum' do
          let(:instance) { max }
          it { should eq(current) }
        end

        context 'maximum + 1' do
          let(:instance) { max + 1 }
          it { should eq(positive) }
        end

        context 'maximum - 1' do
          let(:instance) { max - 1 }
          it { should eq(current) }
        end
      end

      context "when between #{Erlang::ETF::Extensions::Integer::INT32_MIN} and #{Erlang::ETF::Extensions::Integer::INT32_MAX}" do
        let(:min) { integer_min }
        let(:max) { integer_max }

        let(:current)  { Erlang::ETF::Integer.new(instance) }
        let(:positive) { Erlang::ETF::SmallBig.new(instance) }
        let(:negative) { Erlang::ETF::SmallBig.new(instance) }

        context 'minimum' do
          let(:instance) { min }
          it { should eq(current) }
        end

        context 'minimum + 1' do
          let(:instance) { min + 1 }
          it { should eq(current) }
        end

        context 'minimum - 1' do
          let(:instance) { min - 1 }
          it { should eq(negative) }
        end

        context 'maximum' do
          let(:instance) { max }
          it { should eq(current) }
        end

        context 'maximum + 1' do
          let(:instance) { max + 1 }
          it { should eq(positive) }
        end

        context 'maximum - 1' do
          let(:instance) { max - 1 }
          it { should eq(current) }
        end
      end

      context "when between ((-1 << (255 * 8)) + 1) and ((+1 << (255 * 8)) - 1)" do
        let(:min) { small_big_min }
        let(:max) { small_big_max }

        let(:current)  { Erlang::ETF::SmallBig.new(instance) }
        let(:positive) { Erlang::ETF::LargeBig.new(instance) }
        let(:negative) { Erlang::ETF::LargeBig.new(instance) }

        context 'minimum' do
          let(:instance) { min }
          it { should eq(current) }
        end

        context 'minimum + 1' do
          let(:instance) { min + 1 }
          it { should eq(current) }
        end

        context 'minimum - 1' do
          let(:instance) { min - 1 }
          it { should eq(negative) }
        end

        context 'maximum' do
          let(:instance) { max }
          it { should eq(current) }
        end

        context 'maximum + 1' do
          let(:instance) { max + 1 }
          it { should eq(positive) }
        end

        context 'maximum - 1' do
          let(:instance) { max - 1 }
          it { should eq(current) }
        end
      end
    end
  end

end
