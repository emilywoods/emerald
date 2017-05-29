module Emerald
  class Vector
    attr_reader :elements

    def initialize(*elements)
      @elements = elements
    end

    def ==(other)
      other.is_a?(Vector) && elements == other.elements
    end
  end
end
