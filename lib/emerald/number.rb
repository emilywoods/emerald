module Emerald
  class Number
    attr_reader :number

    def initialize(number)
      @number = number
    end

    def ==(other)
      other.is_a?(Number) && number == other.number
    end
  end
end
