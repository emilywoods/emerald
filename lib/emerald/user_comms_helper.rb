module Emerald
  class UserCommsHelper

    ERROR_INVALID_FILE = "Oops! The compiler requires an alphanumeric file without special characters"
    ERROR_INITIALISE_WITH_STRING_IO = "Error: Initialize with StringIO objects"

    def initialize(stdout)
      @stdout = stdout if stdout.respond_to?(:puts)
      raise InvalidArgumentError, ERROR_INITIALISE_WITH_STRING_IO if @stdout.nil?
    end

    def verify_input(input_file)
      pattern = /^[a-zA-Z0-9\-_.\/]+$/
      !(input_file =~ pattern).nil? ? input_file : ( raise InvalidFileError, ERROR_INVALID_FILE )
    end

    def output_to_console(to_output)
      @stdout.puts(to_output.to_s)
    end

    class InvalidFileError < StandardError
    end

    class InvalidArgumentError < StandardError
    end

  end
end
