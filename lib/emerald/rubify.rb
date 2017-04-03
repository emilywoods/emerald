module Emerald

  class Rubify
    def initialize(source)
      @source = source
    end

    # def show
    #   puts @source.first.elements.first.value.inspect
    # end

    def rubify
      ruby_code = ''
      rubify_input(@source, ruby_code)
    end

    private
    def rubify_input(source, ruby_code)
      result = serialise_node(source)
      while result
        node, source = result
        ruby_code.concat(node + ' ') if node
        result = serialise_node(source)
      end
      ruby_code.rstrip
    end

    def serialise_node(source)
      first_node = source.first
      case first_node
      when Atom
        serialise_atom(source)
      when Number
        serialise_number(source)
      when String
        serialise_string(source)
      end
    end

    def serialise_atom(source)
      first_node = source.first.value
      rest_of_source = source.slice(1..source.size)
      [first_node.to_s, rest_of_source]
    end

    def serialise_number(source)
      first_node = source.first.number
      rest_of_source = source.slice(1..source.size)
      [first_node.to_s, rest_of_source]
    end
    
    def serialise_string(source)
      first_node = source.first.string
      rest_of_source = source.slice(1..source.size)
      [first_node.to_s, rest_of_source]
    end
  end
end
