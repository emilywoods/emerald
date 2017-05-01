require_relative 'emerald/parser.rb'
require_relative 'rubify'
require_relative 'invalid-file-error'
require '../emerald/helper/user_comms.rb'
module Emerald
  class Compile
    user_comms = Emerald::UserCommsHelper.new
    input_file = user_comms.get_arguments
    read_file = File.read(input_file)
    parsed_lisp = Parser.new(read_file).parse
    compiled_lisp = Rubify.new(parsed_lisp).rubify

    File.open("compiled_lisp.rb", 'w') {|f| f.puts(compiled_lisp)}
    output = eval File.read('compiled_lisp.rb')
    puts output
  end
end
