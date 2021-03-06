module Emerald
  class String
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def ==(other)
      other.is_a?(String) && string == other.string
    end
  end
end
