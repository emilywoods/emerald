require "spec_helper"

require "emerald/variable"
require "emerald/atom"
require "emerald/string"
require "emerald/number"
require "emerald/list"

RSpec.describe Emerald::Variable do
  describe "assign_variable" do
    it "returns an error if the variable is not an atom" do
      variables_and_assignments = [Emerald::String.new('"This"'), Emerald::String.new('"Hello"')]

      expect{Emerald::Variable.new('def', variables_and_assignments).assign_variable}.to raise_error(Emerald::Variable::InvalidVariableAssignment)
    end

    it "sets up a global variable assignment for a string" do
      variables_and_assignments = [Emerald::Atom.new("input"), Emerald::String.new('"Hello"')]
      variable_assignment = Emerald::Variable.new('def', variables_and_assignments).assign_variable

      expect(variable_assignment).to eq(['input = ', [Emerald::String.new('"Hello"')]])
    end

    it "sets up a global variable assignment for a number" do
      variables_and_assignments = [Emerald::Atom.new("x"), Emerald::Number.new(5.0)]
      variable_assignment = Emerald::Variable.new('def', variables_and_assignments).assign_variable

      expect(variable_assignment).to eq(['x = ', [Emerald::Number.new(5.0)]])
    end

    it "sets up a global variable assignment for a list" do
      variables_and_assignments = [Emerald::Atom.new("x"), Emerald::List.new(Emerald::Atom.new('+'), Emerald::Number.new(5.0))]
      variable_assignment = Emerald::Variable.new('def', variables_and_assignments).assign_variable

      expect(variable_assignment).to eq(['x = ', [Emerald::List.new(Emerald::Atom.new('+'), Emerald::Number.new(5.0))]])
    end

    it "sets up local variable assignment in a string" do
      variables_and_assignments = [Emerald::List.new( 
                                                     Emerald::List.new(
                                                       Emerald::Atom.new("x"), 
                                                       Emerald::Number.new(1.0)))]

      variable_assignment = Emerald::Variable.new('let', variables_and_assignments).assign_variable
      expect(variable_assignment).to eq(['begin\n\t',Emerald::List.new(
                                                       Emerald::Atom.new("x"), 
                                                       Emerald::Number.new(1.0)), 'end'])
    end


    it "raises an error if local variable assigment does not occur within a list" do
        expect{Emerald::Variable.new('let', [Emerald::List.new( Emerald::Atom.new("x"),
                                                              Emerald::Number.new(1.0))]).assign_variable}.to raise_error(Emerald::Variable::InvalidVariableAssignment) 
    end

    it "raises an error if the first variable is not an atom " do
      expect{Emerald::Variable.new('let', [Emerald::List.new(Emerald::List.new(
          Emerald::Number.new(1.0)))]).assign_variable}.to raise_error(Emerald::Variable::InvalidVariableAssignment)
    end
  end
end
