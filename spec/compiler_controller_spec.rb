require 'spec_helper'
require './lib/compiler.rb'

describe 'Compiler' do

  let(:user_comms) {spy(Emerald::UserCommsHelper.new)}
  let(:file_io) {spy(Emerald::FileIO.new)}
  let(:parser) {spy(Parser.new)}

  subject(:compile) {Emerald::Compile.new}
    before(:each) do
      allow(user_comms).to receive(:get_arguments).and_return("input")
      allow(file_io).to receive(:read_files).with("this").and_return('lisp')
      allow(parser).to receive(:parse).and_return('parsed lisp')
    end

    it "does this" do
      puts compile
    end

end
