module Emerald
  class FileIO

    def read_file(file)
      File.read(file)
    end

    def open_and_write_to_file(file, to_write)
      File.open(file ,'w') {|f| f.puts(to_write)}
    end
  end
end
