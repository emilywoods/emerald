require 'rspec'
require 'emerald/user_comms_helper'

RSpec.describe Emerald::UserCommsHelper do

  describe "initialize" do
    it "raises an error if not initialized with stdout" do
      expect{Emerald::UserCommsHelper.new(nil)}.to raise_error(Emerald::UserCommsHelper::InvalidArgumentError).with_message(Emerald::UserCommsHelper::ERROR_INITIALISE_WITH_STRING_IO)
    end
  end

  let(:stdout) {spy('STDOUT')}
  subject(:user_comms) { Emerald::UserCommsHelper.new(stdout)}

  describe "get_arguments" do

    context "when the input arguments match the lisp file format" do
      it "returns input arguments" do
        input_file = "file-type1"
        expect(user_comms.verify_input(input_file)).to eq("file-type1")
      end
    end
  end

  describe "output_to_console" do

    context "when outputting a response to the console" do
      it "outputs response to the console" do
        to_output = "it will return this"
        user_comms.output_to_console(to_output)
        expect(stdout).to have_received(:puts).with(to_output)
      end
    end
  end
end
