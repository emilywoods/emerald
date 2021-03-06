module Emerald
  class Atom
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def ==(other)
      other.is_a?(Atom) && value == other.value
    end
  end
end
