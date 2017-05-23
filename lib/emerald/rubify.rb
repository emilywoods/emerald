require_relative 'variable'

module Emerald
  class Rubify
    def initialize(source)
      @source = source
    end

    def rubify
      ruby_code = ""
      rubify_input(@source, ruby_code)
    end

    private

    def rubify_input(source, ruby_code)
      result = serialise_node(source)
      while result
        node, source = result
        ruby_code.concat(node + "\n") if node
        result = serialise_node(source)
      end
      ruby_code.rstrip
    end

    def serialise_node(source)
      first_node = source.first
      case first_node
      when Atom
        serialise_atom_as_symbol(source)
      when Number
        serialise_number(source)
      when String
        serialise_string(source)
      when List
        return if first_node.elements.empty?
        serialise_node(first_node.elements) if first_node.elements.first.is_a?(List)
        first_node.elements.first.is_a?(Atom) ? serialise_atom(first_node.elements) : (raise InvalidLispFunctionError)
      end
    end

    def serialise_atom(source)
      first_node = source.first.value
      atom_functn = type_of_atom(first_node).first
      atom_args = source.slice(1..source.size)
      case atom_functn
      when "num_ops"
        [numeric_operation(first_node, atom_args), []]
      when "logical_ops"
        logical_operation(first_node, atom_args)
      when "variable"
        [assign_variable(first_node, atom_args), []]
      when "symbol"
        [":" + first_node, atom_args]
      end
    end

    def serialise_list(source)
      serialise_atom(source)
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

    def serialise_atom_as_symbol(source)
      first_node = source.first.value
      atom_args = source.slice(1..source.size)
      [":" + first_node, atom_args]
    end

    def type_of_atom(node)
      atom_types = {
        /^[-+*\/<>=]+$/ => "num_ops",
        /(?:empty\?)|(?:nil\?)/ => "logical_ops",
        /(?:let)|(?:def)/ => "variable",
        /[\w]/ => "symbol"
      }
      atom_types.map { |k, v| v if k.match(node) }.compact
    end

    def numeric_operation(operator, arguments)
      arguments.map.with_index do |element, index|
        "#{element.number} " + (arguments[index + 1].nil? ? "" : "#{operator} ")
      end.join
    end

    def logical_operation(operator, arguments)
      arg = serialise_node(arguments)
      ["#{arg.first}.#{operator}", arg.slice(1..arg.size)]
    end

    def assign_variable(variable_type, arguments)
      if variable_type == "def"
        global_variables(arguments)
      elsif variable_type == "let"
        raise InvalidVariableAssignment unless arguments.first.is_a?(List)
        "begin\n\t" + assign_local_variables(arguments).to_s + "\nend"
      end
    end

    def assign_local_variables(arguments)
      arguments.first.elements.flatten.map {|var_assignment_list|
        raise InvalidVariableAssignment if (!var_assignment_list.is_a?(List) || !var_assignment_list.elements.first.is_a?(Atom))
        global_variables(var_assignment_list.elements)
      }.join("\n\t")
    end

    def global_variables(variables)
      values = variables.slice(1..variables.size)
      raise InvalidVariableAssignment unless variables.first.is_a?(Atom)
      "#{variables.first.value } = " + serialise_node(values).first.to_s
    end

    class InvalidVariableAssignment < StandardError
    end

    class InvalidLispFunctionError < StandardError
    end
  end
end
