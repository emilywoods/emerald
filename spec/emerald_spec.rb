require 'spec_helper'
require 'tempfile'
require_relative '../lib/helper/user_comms'
include Emerald
require 'emerald/parser'
require 'emerald/compiler'


RSpec.describe 'Emerald' do

  let(:stdout) { spy('STDOUT')}
  let(:user_comms) { UserCommsHelper.new(stdout) }

  describe "given a non-lisp file is passed in" do
    context "when non-lisp file is passed" do
      it "returns an InvalidFileType error" do
        verify_lisp = Proc.new { user_comms.verify_lisp_file('test-file.rb') }
        expect(verify_lisp).to raise_error(Emerald::UserCommsHelper::InvalidFileTypeError).with_message(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      end
    end

    context "when no file is passed" do
      it "returns an InvalidFileType error" do
        verify_lisp = Proc.new { user_comms.verify_lisp_file('') }
        expect(verify_lisp).to raise_error(Emerald::UserCommsHelper::InvalidFileTypeError).with_message(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      end
    end
  end

  describe "given a valid lisp file is passed" do
    let(:test_file) { Tempfile.new('new-file.lisp') }

    context "when it receives an invalid list without a closing bracket" do
      it "raises an InvalidListError" do
        test_file.write('(+ 5 2')
        test_file.close

        allow(user_comms).to receive(:new).with(stdout)
        allow(user_comms).to receive(:verify_lisp_file).and_return(test_file)

        lisp_file_contents = File.read(test_file)
        compiler = Emerald::Compiler.new(lisp_file_contents)

        expect{ compiler.compile }.to raise_error(Emerald::Parser::InvalidListError).with_message(Emerald::Parser::ERROR_INVALID_LIST)
      end
    end

    context "when it receives an invalid list without an opening bracket" do
      it "raises an InvalidListError" do
        test_file.write('+ 5 2 )')
        test_file.close

        allow(user_comms).to receive(:new).with(stdout)
        allow(user_comms).to receive(:verify_lisp_file).and_return(test_file)
        lisp_file_contents = File.read(test_file)
        compiler = Emerald::Compiler.new(lisp_file_contents)

        expect{ compiler.compile }.to raise_error(Emerald::Parser::InvalidListError).with_message(Emerald::Parser::ERROR_INVALID_LIST)
      end
    end


    context "when it receives an invalid lisp function expression" do
      it "raises an InvalidListError" do
        test_file.write('( 5 + 5 )')
        test_file.close

        allow(user_comms).to receive(:new).with(stdout)
        allow(user_comms).to receive(:verify_lisp_file).and_return(test_file)
        lisp_file_contents = File.read(test_file)
        compiler = Emerald::Compiler.new(lisp_file_contents)

        expect{ compiler.compile }.to raise_error(Emerald::Rubify::InvalidLispFunctionError)
      end
    end


    context "when it receives a valid lisp expression with a single number" do
      it "compiles and evaluates the lisp" do
        test_file.write('5')
        test_file.close
        stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
        expect(stdout).to eq('5.0')
      end
    end

    context "when it receives a valid lisp expression with an addition operation" do
      it "compiles and evaluates the lisp" do
        test_file.write('(+ 2 5)')
        test_file.close

        stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
        expect(stdout).to eq('7.0')
      end
    end

    after(:each) do
      test_file.unlink
    end
  end
end