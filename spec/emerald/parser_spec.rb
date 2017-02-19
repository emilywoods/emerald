require "spec_helper"
require "emerald/parser"

RSpec.describe Emerald::Parser do

  it "parses empty source" do
    ast = Emerald::Parser.new("").parse
    expect(ast).to eq([])
  end

  describe "atom parsing" do
    it "parses one atom" do
      source = "hello-world"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Atom.new("hello-world")])
    end

    it "parses two atoms" do
      source = "hello      World"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Atom.new("hello"),
                         Emerald::Atom.new("World")])
    end

    it "parses two atoms: a string and an integer" do
      source = "hey 65"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Atom.new("hey"),
                        Emerald::Atom.new("65")])
    end
  end
end
