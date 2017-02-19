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

    it "parses atoms with upper and lower case" do
      source = "Hello WOrld"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Atom.new("Hello"),
                         Emerald::Atom.new("WOrld")])
    end
  end

  describe "number parsing" do
    it "parses one number" do
      source = "25"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(25)])
    end

    it "parses two numbers" do
      source = "12345 789"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(12345),
                         Emerald::Number.new(789)])
    end
  end

  describe "number and atom parsing" do
    it "parses one number and one atom" do
      source = "11 hey"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([ Emerald::Number.new(11),
                          Emerald::Atom.new("hey")])
    end

    it "parses a combination of atoms and numbers" do
      source = "2 eyes 10 toes"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([ Emerald::Number.new(2),
                          Emerald::Atom.new("eyes"),
                          Emerald::Number.new(10),
                          Emerald::Atom.new("toes")])
    end

  end
end
