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

  class Atom
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def ==(other)
      other.is_a?(Atom) and value == other.value
    end
  end
end
