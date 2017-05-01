require 'rspec'
require '././helper/user_comms.rb'

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
      ARGV[0] = "this.lisp"
      expect(user_comms.get_arguments).to eq("this.lisp")
    end

    it "returns an error message when input arguments do not match lisp file format" do
      ARGV[0] = "this.rb"
      allow(stdout).to receive(:puts).and_return(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      expect(user_comms.get_arguments).to eq(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
    end
  end
end
