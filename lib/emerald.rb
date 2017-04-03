module Emerald
  require './emerald/parser.rb'
  require_relative 'emerald/rubify'

  class Compile
    def initialize(source)
      @source = source
    end

    # Read
    input_file = ARGV[0]
    # if file not .em -> error
    read_file = File.read(input_file)

    # Evaluate and compile to Ruby
    parsed_lisp = Parser.new(read_file).parse
    parsed_lisp.inspect
    evaluatedlisp = Rubify.new(parsed_lisp).show # convert to Ruby
    # ruby_program = File.write(evaluatedlisp)#write to ruby file
    # run(ruby_program) #Run ruby file

  end
end
