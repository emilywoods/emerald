require_relative 'emerald/parser.rb'
require_relative 'emerald/rubify'
require_relative 'invalid-file-error'

module Emerald
  class Compile
    def initialize(source)
      @source = source
    end

      # Read
      pattern = /[a-zA-Z0-9\-_]+.lisp/
      pattern.match(ARGV[0]) ? input_file = ARGV[0] : (raise InvalidFileTypeError)
      read_file = File.read(input_file)
      parsed_lisp = Parser.new(read_file).parse
      compiled_lisp = Rubify.new(parsed_lisp).rubify
      ruby_output = Evaluator.new(compiled_lisp).evaluate
      # ruby_program = File.write(compiled_lisp)#write to ruby file?
      # run(ruby_program) #Run ruby file

  end
end
