require_relative 'atom'
require_relative 'number'
require_relative 'list'
require_relative 'string'

module Emerald
  class Parser

    ERROR_INVALID_LIST = 'Oh no! A list has been received without matching brackets'

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
        source.slice(1) == " " ?  parse_atom(source) : parse_number(source)
      when /"/
        parse_string(source)
      when /[(]/, /[)]/
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
      pattern = /\(.*\)/
      raise InvalidListError, ERROR_INVALID_LIST unless pattern.match(source)
      list_range = pattern.match(source).to_s
      rest_of_source = drop(source, list_range.size)
      list_contents = list_range[1...(list_range.size - 1)]

      child = parse_input(list_contents, [])
      list = List.new(*child)
      [list, rest_of_source]
    end

    def drop(source, count)
      range = count..(source.size)
      source.slice(range)
    end

    class InvalidListError < StandardError
    end
  end
end
