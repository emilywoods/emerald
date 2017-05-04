require_relative 'emerald/parser'
require_relative 'emerald/rubify'
require_relative 'invalid-file-error'
require_relative 'helper/user_comms'
require_relative 'helper/file_io'
require_relative 'emerald/compiler'

module Emerald

    COMPILER_OUTPUT_FILE = 'compiled_lisp.rb'

    user_comms = Emerald::UserCommsHelper.new(STDOUT)

    input_file = user_comms.verify_lisp_file(ARGV[0])
    #^^Should raise if not?

    lisp_file_contents = File.read(input_file)

    compiler = Emerald::Compiler.new(lisp_file_contents)
    compiled_lisp = compiler.compile

    File.open(COMPILER_OUTPUT_FILE ,'w') {|f| f.puts(compiled_lisp)}
    output = eval File.read(COMPILER_OUTPUT_FILE)
    user_comms.output_to_console(output)
  
end
