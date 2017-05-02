module Emerald
  class UserCommsHelper

    ERROR_INCORRECT_FILE_TYPE = "Error: Incorrect file type received.\nExpecting a lisp file e.g. example.lisp\n"
    ERROR_INITIALISE_WITH_STRING_IO = "Initialise with StringIO objects"

    def initialize(stdout)
      @stdout = stdout if stdout.respond_to?(:puts)
      raise ERROR_INITIALISE_WITH_STRING_IO if @stdout.nil?
    end

    def verify_lisp_file(input_file)
      pattern = /[a-zA-Z0-9\-_]+.lisp/
      pattern.match(input_file) ? input_file: @stdout.puts(ERROR_INCORRECT_FILE_TYPE)
    end

    def output_to_console(to_output)
      @stdout.puts(to_output.to_s)
    end
  end
end
