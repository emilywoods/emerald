module Emerald
  class Variable

    def initialize(variable_type, variables_to_be_assigned)
      @variable_type = variable_type
      @variables_to_be_assigned = variables_to_be_assigned
    end

    def assign_variable
      type_of_variable(@variable_type, @variables_to_be_assigned)
    end

    private

    def type_of_variable(variable_type, variables_to_be_assigned)
      case variable_type
      when "def"
        global_variable(variables_to_be_assigned)
      end
    end

    def global_variable(variables)
      values = variables.slice(1..variables.size)
      variables.first.is_a?(Atom) ? ["#{variables.first.value } = ", values] : (raise InvalidVariableAssignment)
    end

    class InvalidVariableAssignment < StandardError
    end
  end
end