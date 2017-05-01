require_relative 'emerald/parser.rb'
require_relative 'rubify'
require_relative 'invalid-file-error'
require_relative '../helper/user_comms.rb'
require_relative '../helper/file_io.rb'


module Emerald
  class Compile

    COMPILED_LISP_FILE = "compiled_lisp.rb"

    user_comms = Emerald::UserCommsHelper.new(STDOUT)
    file_io = Emerald::FileIO.new

    input_file = user_comms.get_arguments
    read_file = file_io.read_file(input_file)
    parsed_lisp = Parser.new(read_file).parse
    compiled_lisp = Rubify.new(parsed_lisp).rubify
    file_io.open_and_write_to_file(COMPILED_LISP_FILE, compiled_lisp)
    output = eval file_io.read_file(COMPILED_LISP_FILE)
    user_comms.output_to_console(output)
  end
end
