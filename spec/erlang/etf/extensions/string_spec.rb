# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Extensions::String do
  let(:klass) { ::String }

  describe '[instance]' do
    let(:instance) { "test" }

    describe '__erlang_type__' do
      subject { instance.__erlang_type__ }

      it { should eq(:binary) }
    end

    describe '__erlang_evolve__' do
      subject { instance.__erlang_evolve__ }

      it { should eq(Erlang::ETF::Binary.new(instance)) }
    end

    describe 'to_utf8_binary' do
      it "converts \"Ω\" to \"\\xCE\\xA9\"" do
        expect("Ω".to_utf8_binary).to eq("\xCE\xA9".force_encoding('BINARY'))
      end

      it "handles EncodingError" do
        string = "Ωomega"
        string.should_receive(:encode).with(Erlang::ETF::Extensions::UTF8_ENCODING).and_raise(EncodingError)

        expect(string.to_utf8_binary).to eq("\xCE\xA9omega".force_encoding('BINARY'))
      end
    end

    describe 'from_utf8_binary' do
      it "converts \"\\xCE\\xA9\" to \"Ω\"" do
        expect("\xCE\xA9".force_encoding('BINARY').from_utf8_binary).to eq("Ω")
      end
    end
  end

end
