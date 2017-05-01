require_relative 'emerald/parser.rb'
require_relative 'rubify'
require_relative 'invalid-file-error'
require_relative '../helper/user_comms.rb'
require_relative '../helper/file_io.rb'


module Emerald
  class EmeraldCompiler

    COMPILED_LISP_FILE = "compiled_lisp.rb"

    user_comms = Emerald::UserCommsHelper.new(STDOUT)
    file_io = Emerald::FileIO.new

    input_file = user_comms.get_arguments
    #^^Should raise if not & should probably take ARGV as arg instead
    compiler = Emerald::CompilerController.new(input_file, COMPILED_LISP_FILE, user_comms, file_io)
    compiler.compile
  end
end
