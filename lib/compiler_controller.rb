require_relative 'emerald/parser.rb'
require_relative 'rubify'
require_relative 'invalid-file-error'
require_relative '../helper/user_comms.rb'
require_relative '../helper/file_io.rb'


module Emerald
  class CompilerController

    attr_accessor :input_file, :output_file, :user_comms, :file_io

    def initialize(input_file, output_file, user_comms, file_io)
      self.input_file = input_file
      self.output_file = output_file
      self.user_comms = user_comms
      self.file_io = file_io
    end

    def compile
      read_file = file_io.read_file(input_file)
      parsed_lisp = Parser.new(read_file).parse #Should this be injected in & how?
      compiled_lisp = Rubify.new(parsed_lisp).rubify #Should this be injected in?
      file_io.open_and_write_to_file(output_file, compiled_lisp)
      output = eval file_io.read_file(output_file)
      user_comms.output_to_console(output)
    end
  end
end
