require './emerald/parser.rb'
require_relative 'emerald/rubify'

module Emerald
  class Compile
    def initialize(source)
      @source = source
    end

    # Read
    input_file = ARGV[0]
    # if file not .em -> error
    read_file = File.read(input_file)

    # compile to Ruby
    parsed_lisp = Parser.new(read_file).parse
    compiled_lisp = Rubify.new(parsed_lisp) #convert to Ruby
    # ruby_program = File.write(compiled_lisp)#write to ruby file?
    # run(ruby_program) #Run ruby file

  end
end
