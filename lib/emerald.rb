require_relative 'emerald/parser'
require_relative 'emerald/rubify'
require_relative 'invalid-file-error'
require_relative 'helper/user_comms'
require_relative 'helper/file_io'
require_relative 'emerald/compiler'

module Emerald
  class Interface

    COMPILER_OUTPUT_FILE = 'compiled_lisp.rb'

    user_comms = Emerald::UserCommsHelper.new(STDOUT)
    file_io = Emerald::FileIO.new

    input_file = user_comms.verify_lisp_file(ARGV[0])
    #^^Should raise if not?

    lisp_file_contents = file_io.read_file(input_file)

    compiler = Emerald::Compiler.new(lisp_file_contents)
    compiled_lisp = compiler.compile

    file_io.open_and_write_to_file(COMPILER_OUTPUT_FILE, compiled_lisp)
    output = eval file_io.read_file(COMPILER_OUTPUT_FILE)
    user_comms.output_to_console(output)

  end
end
