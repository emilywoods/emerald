require 'spec_helper'
require 'tempfile'
require 'emerald/user_comms_helper'
require 'emerald/parser'
require 'emerald/compiler'
include Emerald

RSpec.describe 'Emerald' do

  let(:stdout) { spy('STDOUT') }
  let(:user_comms) { Emerald::UserCommsHelper.new(stdout) }
  let(:parser) { Emerald::Parser }

  describe 'given an invalid file is passed in' do
    it 'raises an InvalidFileType error' do
      expect { user_comms.verify_input('test$-!f&ile') }.to\
        raise_error(Emerald::UserCommsHelper::InvalidFileError)
    end

    it 'raises an error with invalid file message' do
      expect { user_comms.verify_input('test$-!f&ile') }.to\
        raise_error.with_message(Emerald::UserCommsHelper::ERROR_INVALID_FILE)
    end
  end

  describe 'given no file is passed in' do
    it 'returns an InvalidFileType error' do
      expect { user_comms.verify_input('') }.to\
        raise_error(Emerald::UserCommsHelper::InvalidFileError)
    end

    it 'raises an error with incorrect file type message' do
      expect { user_comms.verify_input('') }.to \
        raise_error.with_message(Emerald::UserCommsHelper::ERROR_INVALID_FILE)
    end
  end

  describe 'given a valid lisp file is passed' do
    let(:test_file) { Tempfile.new('new-file') }

    it 'raises an InvalidListError for a list without a closing bracket' do
      create_test_file('(+ 5 2')

      expect { compile_lisp(test_file) }.to \
        raise_error(parser::InvalidListError)
      expect { compile_lisp(test_file) }.to \
        raise_error.with_message(parser::ERROR_INVALID_LIST)
    end

    it 'raises an InvalidListError for a list without an opening bracket' do
      create_test_file('+ 5 2 )')

      expect { compile_lisp(test_file) }.to \
        raise_error(parser::InvalidListError)
      expect { compile_lisp(test_file) }.to \
        raise_error.with_message(parser::ERROR_INVALID_LIST)
    end

    it 'raises an InvalidListError for an invalid lisp expression' do
      create_test_file('( 5 + 5 )')

      expect { compile_lisp(test_file) }.to \
        raise_error(Emerald::Rubify::InvalidLispFunctionError)
    end

    it 'compiles and evaluates a valid lisp expression with a number' do
      create_test_file('5')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('5.0')
    end

    it 'compiles and evaluates a valid lisp expression with addition' do
      create_test_file('(+ 2 5)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('7.0')
    end

    it 'compiles and evaluates a valid lip expression with subtraction' do
      create_test_file('(- 5 2 1)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('2.0')
    end

    it 'compiles and evaluates a valid lip expression with division' do
      create_test_file('(/ 20 2 2)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('5.0')
    end

    it 'compiles and evaluates a valid lip expression with multiplication' do
      create_test_file('(* 12 2 2)')

      stdout = `ruby lib/emerald.rb "#{test_file.path}"`.chomp
      expect(stdout).to eq('48.0')
    end

    def create_test_file(file_contents)
      test_file.write(file_contents)
      test_file.close
    end

    def compile_lisp(test_file)
      lisp_file_contents = File.read(test_file)
      compiler = Emerald::Compiler.new(lisp_file_contents)
      compiler.compile
    end

    after(:each) do
      test_file.unlink
    end
  end
end
