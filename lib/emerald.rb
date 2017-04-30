require_relative 'emerald/parser.rb'
require_relative 'rubify'
require_relative 'invalid-file-error'

module Emerald
  class Compile
    def initialize(source)
      @source = source
    end

    pattern = /[a-zA-Z0-9\-_]+.lisp/
    pattern.match(ARGV[0]) ? input_file = ARGV[0] : (raise InvalidFileTypeError)
    read_file = File.read(input_file)
    parsed_lisp = Parser.new(read_file).parse
    compiled_lisp = Rubify.new(parsed_lisp).rubify

    File.open("compiled_lisp.rb", 'w') {|f| f.puts(compiled_lisp)}
    puts eval File.read('compiled_lisp.rb')
  end
end
