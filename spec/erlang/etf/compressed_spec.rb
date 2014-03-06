# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Compressed do
  let(:term_class) { Erlang::ETF::Compressed }

  describe '[class]' do
    describe 'deserialize' do
      let(:buffer) { StringIO.new(bytes.pack('C*')) }
      subject { term_class.deserialize(buffer) }

      context "valid zlib bytes" do
        let(:bytes) { [0, 0, 0, 18, 120, 218, 203, 102, 224, 103, 68, 5, 0, 9, 0, 0, 138] }

        its(:uncompressed_size) { should eq(18) }
        its(:data)              { should eq(::Erlang::ETF::String.new(([1] * 15).pack('C*').from_utf8_binary).tap { |s| s.len = 15 }) }
        its(:__ruby_evolve__)   { should eq(::Erlang::String.new(([1] * 15).pack('C*').from_utf8_binary)) }
      end

      context "invalid zlib bytes" do
        subject { -> { term_class.deserialize(buffer) } }
        let(:bytes) { [0, 0, 0, 18, 120, 218, 203, 102, 224, 103, 68, 5, 0, 9, 0, 0] }

        it { should raise_error(::Zlib::BufError) }
      end

      context "valid zlib bytes, invalid uncompressed size" do
        subject { -> { term_class.deserialize(buffer) } }
        let(:bytes) { [0, 0, 0, 17, 120, 218, 203, 102, 224, 103, 68, 5, 0, 9, 0, 0, 138] }

        it { should raise_error(::Zlib::DataError) }
      end
    end
  end

end
