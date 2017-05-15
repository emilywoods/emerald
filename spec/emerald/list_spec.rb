require "spec_helper"

require "emerald/atom"
require "emerald/list"

RSpec.describe Emerald::List do
  describe "#==" do
    it "can be equal" do
      list1 = Emerald::List.new([])
      list2 = Emerald::List.new([])
      expect(list1).to eq(list2)
    end

    it "can be unequal with the same class" do
      list1 = Emerald::List.new([1])
      list2 = Emerald::List.new([2])
      expect(list1).not_to eq(list2)
    end

    it "can be unequal with different class" do
      list1 = Emerald::List.new([])
      atom1 = Emerald::Atom.new("defun")
      expect(list1).not_to eq(atom1)
    end
  end
end
