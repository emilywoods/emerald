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
      source = "hello      world"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Atom.new("hello"),
                         Emerald::Atom.new("world")])
    end
  end
end
