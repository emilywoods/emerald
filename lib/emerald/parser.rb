module Emerald
  class Parser
    def initialize(source)
      @source = source
    end

    def parse
      ast = []
      parse_lists_and_nodes(@source, ast)
    end

    private

    def parse_lists_and_nodes(source, ast)
      result = parse_node(source)
      while result
        node, source = result
        if node.is_a? List
          child = parse_lists_and_nodes(source,[])
          ast.push(List.new(*child))
          break
        else 
          ast.push(node) if node
        end
        result = parse_node(source)
      end
      ast
    end
    
    def parse_node(source)
      first_char = source.slice(0)
      case first_char
      when " "
        parse_whitespace(source)
      when /[a-zA-Z]/
        parse_atom(source)
      when /[\d]/
        parse_number(source)
      when /[+-]/
        if source.slice(1) == " "
          parse_atom(source)
        else 
          parse_number(source) 
        end
      when /"/
        parse_string(source)
      when /[(]/
        parse_list(source)
      end
    end

    def parse_whitespace(source)
      pattern = /\A +/
      matches = pattern.match(source)
      rest_of_source = drop(source, matches.to_s.size)
      [nil, rest_of_source]
    end

    def parse_atom(source)
      pattern = /\A[a-zA-Z\d+\-]+/
      atom_value = pattern.match(source).to_s
      atom = Atom.new(atom_value)
      rest_of_source = drop(source, atom_value.size)
      [atom, rest_of_source]
    end

    def parse_number(source)
      pattern = /[+-]?[\d]*\.?[\d]+/
      number_value = pattern.match(source).to_s
      number = Number.new(number_value.to_f)
      rest_of_source = drop(source, number_value.size)
      [number, rest_of_source]
    end

    def parse_string(source)
      pattern = /"([^"\\]|\\.)*"/
      string_range = pattern.match(source).to_s
      string = String.new(string_range)
      rest_of_source = drop(source, string_range.size)
      [string, rest_of_source]
    end
  
    def parse_list(source)
      pattern = /([\s\S]+)/
      list_range = pattern.match(source).to_s
      list = List.new()
      [list, list_range[1..(source.size)]]
    end

    def drop(source, count)
      range = count..(source.size)
      source.slice(range)
    end
  end
end
