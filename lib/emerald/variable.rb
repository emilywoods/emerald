module Emerald
  class Variable

    def self.global_variable(variables)
      values = variables.slice(1..variables.size)
      variables.first.is_a?(Atom) ? ["#{variables.first.value } = ", values] : (raise InvalidVariableAssignment)
    end

    def self.local_variable(variables)
      raise InvalidVariableAssignment unless variables.first.is_a?(List)

      hello = variables.first.elements.each {|var_assignment|
        raise InvalidVariableAssignment if (!var_assignment.is_a?(List) || !var_assignment.elements.first.is_a?(Atom))
        var_assignment.elements.map {|hav| hav}
      }
      global_variable(hello.first.elements) #should get it for each, not just the first
    end

    class InvalidVariableAssignment < StandardError
    end
  end
end
