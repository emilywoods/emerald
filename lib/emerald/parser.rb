module Emerald
  class Parser
    def initialize(source)
      @source = source
    end

    def parse
      ast = []
      result = parse_node(@source)
      while result
        node, source = result
        ast.push(node) if node
        result = parse_node(source)
      end
      ast
    end

    private

    def parse_node(source)
      first_char = source.slice(0)
      case first_char
      when " "
        parse_whitespace(source)
      when /[a-zA-Z\-]/
        parse_atom(source)
      when /\d+/
        parse_number(source)
      end
    end

    def parse_whitespace(source)
      pattern = /\A +/
      matches = pattern.match(source)
      rest_of_source = drop(source, matches.to_s.size)
      [nil, rest_of_source]
    end

    def parse_atom(source)
      pattern = /\A[a-zA-Z\-]+/
      atom_value = pattern.match(source).to_s
      atom = Atom.new(atom_value)
      rest_of_source = drop(source, atom_value.size)
      [atom, rest_of_source]
    end

    def parse_number(source)
      pattern = /\d+/
      number_value = pattern.match(source).to_s
      number = Number.new(number_value.to_f)
      rest_of_source = drop(source, number_value.size)
      [number, rest_of_source]
    end

    def drop(source, count)
      range = count..(source.size)
      source.slice(range)
    end
  end
end
