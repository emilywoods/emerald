require_relative "atom"
require_relative "number"
require_relative "list"
require_relative "string"

module Emerald
  class Parser
    ERROR_INVALID_LIST = "Oh no! A list has been received without\
 matching brackets".freeze

    def initialize(source)
      @source = source
    end

    def parse
      ast = []
      parse_input(@source, ast)
    end

    private

    def parse_input(source, ast)
      result = parse_node(source)
      while result
        node, source = result
        ast.push(node) if node
        result = parse_node(source)
      end
      verify_balanced_list(ast)
      parse_sexp(ast)
    end

    def parse_node(source)
      first_char = source.slice(0)
      case first_char
      when " "
        parse_whitespace(source)
      when /\n/
        parse_newline(source)
      when /[a-zA-Z*\/<>%=]/
        parse_atom(source)
      when /[\d]/
        parse_number(source)
      when /[+-]/
        source.slice(1) == " " ? parse_atom(source) : parse_number(source)
      when /"/
        parse_string(source)
      when /[(]/, /[)]/
        replace_parens_with_symbol(source, first_char)
      end
    end

    def parse_newline(source)
      pattern = /\n/
      newline_to_string = pattern.match(source).to_s
      return_parsed_node_and_rest_of_source(source, nil, newline_to_string)
    end

    def parse_whitespace(source)
      pattern = /\s+/
      whitespace_to_string = pattern.match(source).to_s
      return_parsed_node_and_rest_of_source(source, nil, whitespace_to_string)
    end

    def parse_atom(source)
      pattern = /\A[a-zA-Z\d+\-*><=%\/]+/
      atom_to_string = pattern.match(source).to_s
      atom = Atom.new(atom_to_string)
      return_parsed_node_and_rest_of_source(source, atom, atom_to_string)
    end

    def parse_number(source)
      pattern = /[+-]?[\d]*\.?[\d]+/
      number_to_string = pattern.match(source).to_s
      number = Number.new(number_to_string.to_f)
      return_parsed_node_and_rest_of_source(source, number, number_to_string)
    end

    def parse_string(source)
      pattern = /"([^"\\]|\\.)*"/
      string_range = pattern.match(source).to_s
      string = String.new(string_range)
      return_parsed_node_and_rest_of_source(source, string, string_range)
    end

    def replace_parens_with_symbol(source, char)
      rest_of_source = source[1..-1]
      if /\(/ =~ char
        [:left_bracket, rest_of_source]
      elsif /\)/ =~ char
        [:right_bracket, rest_of_source]
      end
    end

    def verify_balanced_list(array_of_tokens)
      counter = 0
      array_of_tokens.each do |token|
        case token
        when :left_bracket
          counter += 1
        when :right_bracket
          counter -= 1
        else
          next
        end
      end
      raise InvalidListError, ERROR_INVALID_LIST unless counter == 0
    end

    def parse_sexp(array_of_tokens)
      _, elements = get_nested_struct_recursive(0, array_of_tokens)
      elements
    end

    def get_nested_struct_recursive(current_index, array_of_tokens)
      elements_at_my_level = []
      index = current_index

      until index == array_of_tokens.size
        token = array_of_tokens[index]

        case token
        when :left_bracket
          index, element = get_nested_struct_recursive(index + 1, array_of_tokens)
          elements_at_my_level.push(element)
        when :right_bracket
          return index + 1, List.new(*elements_at_my_level)
        else
          elements_at_my_level.push(token)
          index += 1
        end
      end
      [index, elements_at_my_level]
    end

    def return_parsed_node_and_rest_of_source(source, parsed_node, string_range_of_node)
      source_minus_node = string_range_of_node.size..(source.size)
      rest_of_source = source.slice(source_minus_node)
      [parsed_node, rest_of_source]
    end

    class InvalidListError < StandardError
    end
  end
end
