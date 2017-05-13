require_relative 'emerald/user_comms_helper'
require_relative 'emerald/compiler'

module Emerald

  COMPILER_OUTPUT_FILE = 'compiled_lisp.rb'

  user_comms = UserCommsHelper.new(STDOUT)

  input_file = user_comms.verify_input(ARGV[0])
  lisp_file_contents = File.read(input_file)

  compiler = Emerald::Compiler.new(lisp_file_contents)
  compiled_lisp = compiler.compile

  File.open(COMPILER_OUTPUT_FILE, 'w') {|f| f.puts(compiled_lisp)}
  output = eval File.read(COMPILER_OUTPUT_FILE)
  user_comms.output_to_console(output)

end
