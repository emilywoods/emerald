module Emerald
  class UserCommsHelper

    ERROR_INCORRECT_FILE_TYPE = "Oops! Incorrect file type received.\nExpecting a lisp file e.g. example.lisp\n"
    ERROR_INITIALISE_WITH_STRING_IO = "Error: Initialize with StringIO objects"

    def initialize(stdout)
      raise ERROR_INITIALISE_WITH_STRING_IO if stdout.nil?
      @stdout = stdout if stdout.respond_to?(:puts)
    end

    def verify_lisp_file(input_file)
      pattern = /[a-zA-Z0-9\-_]+.lisp/
      pattern.match(input_file) ? input_file : ( raise InvalidFileTypeError, ERROR_INCORRECT_FILE_TYPE )
    end

    def output_to_console(to_output)
      @stdout.puts(to_output.to_s)
    end

    class InvalidFileTypeError < StandardError
    end

  end
end
