require 'rspec'
require 'helper/user_comms'

RSpec.describe Emerald::UserCommsHelper do

  describe "initialize" do
    it "raises an error if not initialized with stdout" do
      expect{Emerald::UserCommsHelper.new(nil)}.to raise_error.with_message(Emerald::UserCommsHelper::ERROR_INITIALISE_WITH_STRING_IO)
    end
  end


  describe "get_arguments" do
    let(:stdout) {spy('STDOUT')}
    subject(:user_comms) { Emerald::UserCommsHelper.new(stdout)}

    context "when the input arguments match the lisp file format" do
      it "returns input arguments" do
        input_file = "this.lisp"
        expect(user_comms.verify_lisp_file(input_file)).to eq("this.lisp")
      end
    end

    context "when the input arguments do not match the lisp file format " do
      it "raises an InvalidFileType error" do
        input_file = "this.rb"
        expect{ user_comms.verify_lisp_file(input_file) }.to raise_error(Emerald::UserCommsHelper::InvalidFileTypeError).with_message(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      end
    end
  end

  describe "output_to_console" do
    let(:stdout) {spy('STDOUT')}
    subject(:user_comms) { Emerald::UserCommsHelper.new(stdout)}

    context "when outputting a response to the console" do
      it "outputs response to the console" do
        to_output = "it will return this"
        user_comms.output_to_console(to_output)
        expect(stdout).to have_received(:puts).with(to_output)
      end
    end
  end
end
