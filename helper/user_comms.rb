module Emerald
  class UserCommsHelper

    ERROR_INCORRECT_FILE_TYPE = "Error: Incorrect file type received \n
                                 Expecting a lisp file e.g. example.lisp \n"
    ERROR_INITIALISE_WITH_STRING_IO = "Initialise with StringIO objects"

    def initialize(stdout)
      @stdout = stdout if stdout.respond_to?(:puts)
      puts @stdout.nil?
      raise ERROR_INITIALISE_WITH_STRING_IO if @stdout.nil?
    end

    def get_arguments
      pattern = /[a-zA-Z0-9\-_]+.lisp/
      pattern.match(ARGV[0]) ? ARGV[0]: @stdout.puts(ERROR_INCORRECT_FILE_TYPE + ARGV[0])
    end

  end
end
