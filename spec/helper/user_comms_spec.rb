require 'rspec'
require_relative '../../lib/helper/user_comms'

RSpec.describe Emerald::UserCommsHelper do

  let(:stdout) {spy('STDOUT')}
  subject(:user_comms) { Emerald::UserCommsHelper.new(stdout)}

  describe "initialize" do
    it "raises an error if not initialized with stdout" do
      expect{(Emerald::UserCommsHelper.new(nil))}.to raise_error.with_message(Emerald::UserCommsHelper::ERROR_INITIALISE_WITH_STRING_IO)
    end
  end

  describe "get_arguments" do
    it "returns input arguments when they match the lisp file format" do
      input_file = "this.lisp"
      expect(user_comms.verify_lisp_file(input_file)).to eq("this.lisp")
    end

    it "returns an error message when input arguments do not match lisp file format" do
      input_file = "this.rb"
      allow(stdout).to receive(:puts).and_return(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      expect(user_comms.verify_lisp_file(input_file)).to eq(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
    end
  end

  describe "output_to_console" do
    it "outputs arguments to the console" do
      to_output = "it will return this"
      user_comms.output_to_console(to_output)
      expect(stdout).to have_received(:puts).with(to_output)
    end
  end
end
