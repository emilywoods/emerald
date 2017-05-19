require "spec_helper"

require "emerald/variable"
require "emerald/atom"
require "emerald/string"



RSpec.describe Emerald::Variable do
  describe "assign_variable" do
    it "assigns a global variable" do
      variable_assignor = 'def'
      variables_and_assignments = [Emerald::Atom.new("input"), Emerald::String.new('"Hello"')]
      variable_assignment = Emerald::Variable.new(variable_assignor, variables_and_assignments).assign_variable

      expect(variable_assignment).to eq('input = ')
    end

    it "returns an error if the variable is not an atom" do
      variable_assignor = 'def'
      variables_and_assignments = [Emerald::String.new('"This"'), Emerald::String.new('"Hello"')]

      expect{Emerald::Variable.new(variable_assignor, variables_and_assignments).assign_variable}.to raise_error(Emerald::Variable::InvalidVariableAssignment)
    end
  end
end