require 'spec_helper'
require 'tempfile'
require 'emerald/user_comms_helper'
require 'emerald/parser'
require 'emerald/compiler'
include Emerald

RSpec.describe 'Emerald' do

  let(:stdout) {spy('STDOUT')}
  let(:user_comms) {Emerald::UserCommsHelper.new(stdout)}


  describe "given a non-lisp file is passed in" do
    context "an invalid file name is passed" do
      it "returns an InvalidFileType error" do
        expect {user_comms.verify_input('test$-!f&ile')}.to \
          raise_error(Emerald::UserCommsHelper::InvalidFileTypeError).with_message(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      end
    end

    context "when no file is passed" do
      it "returns an InvalidFileType error" do
        expect {user_comms.verify_input('')}.to \
        raise_error(Emerald::UserCommsHelper::InvalidFileTypeError).with_message(Emerald::UserCommsHelper::ERROR_INCORRECT_FILE_TYPE)
      end
    end
  end

  describe "given a valid lisp file is passed" do
    let(:test_file) {Tempfile.new('new-file')}

    it "raises an InvalidListError when it receives an invalid list without a closing bracket" do
      create_test_file('(+ 5 2')

      lisp_file_contents = File.read(test_file)
      compiler = Emerald::Compiler.new(lisp_file_contents)

      expect {compiler.compile}.to raise_error(Emerald::Parser::InvalidListError).with_message(Emerald::Parser::ERROR_INVALID_LIST)
    end

    it "raises an InvalidListError when it receives an invalid list without an opening bracket" do
      create_test_file('+ 5 2 )')

      lisp_file_contents = File.read(test_file)
      compiler = Emerald::Compiler.new(lisp_file_contents)

      expect {compiler.compile}.to raise_error(Emerald::Parser::InvalidListError).with_message(Emerald::Parser::ERROR_INVALID_LIST)
    end


    it "raises an InvalidListError when it receives an invalid lisp function expression" do
      create_test_file('( 5 + 5 )')

      lisp_file_contents = File.read(test_file)
      compiler = Emerald::Compiler.new(lisp_file_contents)

      expect {compiler.compile}.to raise_error(Emerald::Rubify::InvalidLispFunctionError)
    end


    it "compiles and evaluates the lisp when it receives a valid lisp expression with a single number" do
      create_test_file('5')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('5.0')
    end

    it "compiles and evaluates the lisp when it receives a valid lisp expression with an addition operation" do
      create_test_file('(+ 2 5)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('7.0')
    end

    it "compiles and evaluates the lisp when it receives a valid lisp expression with a subtraction operation" do
      create_test_file('(- 5 2 1)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('2.0')
    end

    it "compiles and evaluates the lisp when it receives a valid lisp expression with a division operation" do
      create_test_file('(/ 20 2 2)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('5.0')
    end

    it "compiles and evaluates the lisp when it receives a valid lisp expression with a multiplication operation" do
      create_test_file('(* 12 2 2)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('48.0')
    end

    def create_test_file(file_contents)
      test_file.write(file_contents)
      test_file.close
    end

    after(:each) do
      test_file.unlink
    end

  end
end
