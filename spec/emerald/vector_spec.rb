require "spec_helper"

require "emerald/vector"
require "emerald/atom"

RSpec.describe Emerald::Vector do
  describe '#==' do
    it "can be equal" do
      vec1 = Emerald::Vector.new([])
      vec2 = Emerald::Vector.new([])
      expect(vec1).to eq(vec2)
    end

    it "can be unequal with the same class" do
      vec1 = Emerald::Vector.new([1])
      vec2 = Emerald::Vector.new([2])
      expect(vec1).not_to eq(vec2)
    end

    it "can be unequal with a different class" do
      vec1 = Emerald::Vector.new([])
      vec2 = Emerald::String.new("This")
      expect(vec1).not_to eq(vec2)
    end
  end
end
