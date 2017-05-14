require_relative 'parser'
require_relative 'rubify'

module Emerald
  class Compiler
    attr_reader :lisp_file_contents

    def initialize(lisp_file_contents)
      @lisp_file_contents = lisp_file_contents
    end

    def compile
      parsed_lisp = Parser.new(lisp_file_contents).parse
      Rubify.new(parsed_lisp).rubify
    end
  end
end
