module Emerald
  class List
    attr_reader :elements

    def initialize(elements)
      @elements = elements
    end

    def ==(other)
      other.is_a?(List) and elements == other.elements
    end
  end
end
