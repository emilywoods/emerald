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
        list_items = first_node.elements
        return ["", source[1..-1]] if list_items.empty?
        list_items.first.is_a?(Atom) ? serialise_atom(list_items) : (raise InvalidLispFunctionError)
      end
    end

    def serialise_atom_as_symbol(source)
      first_node = source.first.value
      atom_args = source.slice(1..source.size)
      [first_node, atom_args]
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

    def serialise_atom(source)
      first_node = source.first.value
      atom_functn = type_of_atom(first_node).first
      atom_args = source.slice(1..source.size)
      case atom_functn
      when "num_ops"
        [generate_numeric_operation(first_node, atom_args), []]
      when "logical_ops"
        generate_logical_operation(first_node, atom_args)
      when "variable_assignment"
        [generate_variable_assignment(first_node, atom_args), []]
      when "function"
        [generate_method(atom_args), []]
      when "variable"
        [first_node, atom_args]
      end
    end

    def type_of_atom(node)
      atom_types = {
        /^[-+*\/<>=]+$/ => "num_ops",
        /(?:empty\?)|(?:nil\?)/ => "logical_ops",
        /(?:defun)/ => "function",
        /(?:let)|(?:def)/ => "variable_assignment",
        /[\w]/ => "variable"
      }
      atom_types.map { |key, val| val if key.match(node) }.compact
    end

    def generate_numeric_operation(operator, args)
      args.map.with_index do |item, index|
        if item.is_a?(Number)
          "#{item.number} " + (args[index + 1].nil? ? "" : "#{operator} ")
        elsif item.is_a?(Atom)
          "#{item.value} " + (args[index + 1].nil? ? "" : "#{operator} ") if item.is_a?(Atom)
        end
      end.join
    end

    def generate_logical_operation(operator, arguments)
      arg = serialise_node(arguments)
      ["#{arg.first}.#{operator}", arg.slice(1..arg.size)]
    end

    def generate_variable_assignment(variable_type, arguments)
      if /(?:def)/ =~ variable_type
        assign_value_to_var(arguments)
      elsif /(?:let)/ =~ variable_type
        raise InvalidVariableAssignment unless arguments.first.is_a?(List)
        assign_local_variable(arguments)
      end
    end

    def assign_local_variable(lists_to_assign_and_op_on_vars)
      if lists_to_assign_and_op_on_vars.size > 1
        var_operations = local_var_operations(lists_to_assign_and_op_on_vars[1..-1])
      end
      "begin\n\t" +
        local_var_assignment(lists_to_assign_and_op_on_vars.first).to_s +
        (!var_operations.nil? ? var_operations : "") +
        "\nend"
    end

    def local_var_operations(variable_operations)
      "\n\t" + serialise_node(variable_operations).first.to_s.strip
    end

    def local_var_assignment(var_value_list)
      var_value_list.elements.map do |var_value_pair|
        raise InvalidVariableAssignment unless var_value_pair.is_a?(List)
        assign_value_to_var(var_value_pair.elements)
      end.join("\n\t")
    end

    def assign_value_to_var(var_and_values)
      values = var_and_values.slice(1..var_and_values.size)
      raise InvalidVariableAssignment unless var_and_values.first.is_a?(Atom)
      "#{var_and_values.first.value} = " + serialise_node(values).first.to_s.strip
    end

    def generate_method(params)
      raise InvalidLispFunctionError unless params.first.is_a?(Atom)

      "def #{params.first.value}" +
        arg_steps([params[1]], ", ") +
        "\n\t" +
        method_steps(params[2..-1], "\n").to_s +
        "end"
    end

    def arg_steps(method_operations, concat_with)
      argument_string = ""
      result = serialise_node(method_operations)
      while result
        node, source = result
        argument_string.concat(node.strip) if node
        argument_string.concat(concat_with) unless source.empty?
        result = serialise_node(source)
      end
      argument_string.empty? ? "" : "(" + argument_string + ")"
    end

    def method_steps(method_operations, concat_with)
      method_string = ""
      result = serialise_node(method_operations)
      while result
        node, source = result
        method_string.concat(node.strip + concat_with) if node
        result = serialise_node(source)
      end
      method_string
    end

    class InvalidLispFunctionError < StandardError
    end

    class InvalidVariableAssignment < StandardError
    end
  end
end
