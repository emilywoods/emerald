require_relative "emerald/helpers/user_comms_helper"
require_relative "emerald/compiler"

module Emerald
  COMPILER_OUTPUT_FILE = "compiled_lisp.rb".freeze

  user_comms = UserCommsHelper.new(STDOUT)
  input_file = user_comms.verify_input(ARGV[0])
  lisp_file_contents = File.read(input_file)

  compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile

  File.open(COMPILER_OUTPUT_FILE, "w") { |f| f.puts(compiled_lisp) }
  output = eval File.read(COMPILER_OUTPUT_FILE)
  user_comms.output_to_console(output)
end
