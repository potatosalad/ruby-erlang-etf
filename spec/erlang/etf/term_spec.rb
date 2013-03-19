# encoding: utf-8

require 'spec_helper'

describe Erlang::ETF::Term do
  let(:term_class) do
    Class.new do
      include Erlang::ETF::Term

      term :atom,   always:  -> { Erlang::ETF::Atom.new("atom") }
      term :binary, default: -> { Erlang::ETF::Binary.new("binary") }

      finalize
    end
  end
  let(:term) { term_class.new }

  describe '__erlang_evolve__' do
    subject { term.__erlang_evolve__ }
    it { should eq(term) }
  end

  describe '__ruby_evolve__' do
    subject { term.__ruby_evolve__ }
    it { should eq(term) }
  end
end
