require 'spec_helper'
require './lib/emerald.rb'

describe 'Compiler' do

  let(:user_comms) {spy('user_comms')}

  subject(:compile) {Emerald::Compile.new}
    before(:each) do
      allow(user_comms).to receive(:get_arguments).and_return("test-file.lisp")
      allow(File).to receive(:read).with("test-file.lisp").and_return('(+ 2 2)')
    end
end
