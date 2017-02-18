require "spec_helper"

require "emerald/atom"
require "emerald/list"

RSpec.describe Emerald::Atom do

  describe "#==" do
    it "can be equal" do
      atom1 = Emerald::Atom.new("defun")
      atom2 = Emerald::Atom.new("defun")
      expect(atom1).to eq(atom2)
    end

    it "can be unequal with the same class" do
      atom1 = Emerald::Atom.new("defun")
      atom2 = Emerald::Atom.new("print")
      expect(atom1).not_to eq(atom2)
    end

    it "can be unequal with different class" do
      atom1 = Emerald::Atom.new("defun")
      list1 = Emerald::List.new([])
      expect(atom1).not_to eq(list1)
    end
  end
end
