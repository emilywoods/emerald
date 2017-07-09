require_relative "atom_categorisation_helper"
require_relative "serialisation_helper"


module Emerald
  class Rubify
    def initialize(source, serialisation_helper, atom_categorisation_helper)
      @source = source
      @serialisation_helper = serialisation_helper
      @atom_categorisation_helper = atom_categorisation_helper
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
      when Atom, Number, String
        @serialisation_helper.serialise(source)
      when List
        list_items = first_node.elements
        return ["", source[1..-1]] if list_items.empty?
        list_items.first.is_a?(Atom) ? serialise_atom(list_items) : (raise InvalidLispFunctionError)
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
      when "variable_assignment"
        [assign_variable(first_node, atom_args), []]
      when "function"
        [generate_method(atom_args), []]
      when "variable"
        [first_node, atom_args]
      end
    end

    def type_of_atom(node)
      @atom_categorisation_helper.type_of_atom(node)
    end

    def numeric_operation(operator, args)
      args.map.with_index do |item, index|
        if item.is_a?(Number)
          "#{item.number} " + (args[index + 1].nil? ? "" : "#{operator} ")
        elsif item.is_a?(Atom)
          "#{item.value} " + (args[index + 1].nil? ? "" : "#{operator} ") if item.is_a?(Atom)
        end
      end.join
    end

    def logical_operation(operator, arguments)
      arg = serialise_node(arguments)
      ["#{arg.first}.#{operator}", arg.slice(1..arg.size)]
    end

    def assign_variable(variable_type, arguments)
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

      function_name = params.first.value
      function_arguments = arg_steps([params[1]], ", ")
      function_arguments.empty? ? arguments =  "" :  arguments = "(" + function_arguments + ")"
      function_ops = method_steps(params[2..-1], "\n").to_s

      "def #{function_name}" +
         arguments +
          "\n\t" +
          function_ops +
          "end"
    end

    def arg_steps(method_operations, concat_with)
      method_string = ""
      result = serialise_node(method_operations)
      while result
        node, source = result
        method_string.concat(node.strip) if (node && !node.empty?)
        method_string.concat(concat_with) if (!source.empty?)
        result = serialise_node(source)
      end
      method_string
    end

    def method_steps(method_operations, concat_with)
      method_string = ""
      result = serialise_node(method_operations)
      while result
        node, source = result
        method_string.concat(node.strip + concat_with) if (node && !node.empty?)
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
