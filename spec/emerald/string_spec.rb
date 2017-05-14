require "spec_helper"

require "emerald/string"
require "emerald/atom"

RSpec.describe Emerald::String do
  describe '#==' do
    it "can be equal" do
      string1 = Emerald::String.new('"This string"')
      string2 = Emerald::String.new('"This string"')
      expect(string1).to eq(string2)
    end

    it "can be unequal with the same class" do
      string1 = Emerald::String.new('"This is one string"')
      string2 = Emerald::String.new('"This is another string"')
      expect(string1).not_to eq(string2)
    end

    it "can be unequal with a different class" do
      string1 = Emerald::String.new('"This is a string"')
      string2 = Emerald::Atom.new("This")
      expect(string1).not_to eq(string2)
    end
  end
end
