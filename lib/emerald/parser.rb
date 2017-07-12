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
      parse_sexp(ast)
    end

    def parse_node(source)
      first_char = source.slice(0)
      case first_char
      when " "
        parse_whitespace(source)
      when /\n/
        parse_newline(source)
      when /[a-zA-Z]/
        parse_atom(source)
      when /[\d]/
        parse_number(source)
      when /[+-]/
        source.slice(1) == " " ? parse_atom(source) : parse_number(source)
      when /[*\/<>%=]/
        parse_atom(source)
      when /"/
        parse_string(source)
      when /[(]/, /[)]/
        parse_list(source, first_char)
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

    def parse_list(source, char)
      rest_of_source = source[1..-1]
      if /\(/ =~ char
        [:left_bracket, rest_of_source]
      elsif /\)/ =~ char
        [:right_bracket, rest_of_source]
      end
    end

    def parse_sexp(source)
      sexp_stack = [[]]
      source.each do |char|
        case char
        when :left_bracket
          sexp_stack.push([])
        when :right_bracket
          raise InvalidListError, ERROR_INVALID_LIST if sexp_stack[-2].nil?
          sexp_stack[-2].push(List.new(*sexp_stack.pop))
        else
          sexp_stack[-1] << char
        end
      end
      raise InvalidListError, ERROR_INVALID_LIST if sexp_stack.size > 1
      sexp_stack.first
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
