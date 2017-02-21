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
      source = "H3llo World44"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Atom.new("H3llo"),
                         Emerald::Atom.new("World44")])
    end
  end

  describe "number parsing" do
    it "parses a single digit integer" do
      source = "2"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(2)])
    end

    it "parses one number" do
      source = "25"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(25)])
    end

    it "parses two integers" do
      source = "12345 789"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(12345),
                         Emerald::Number.new(789)])
    end

    it "parses a floating point number" do
      source = "5.55"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(5.55)])
    end

    it "parses a negative number" do
      source = "-5.0"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(-5.0)])
    end

    it "parses a positive integer" do
      source = "+5"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(5)])
    end
    
    
    it "parses a positive float" do
      source = "+5.55"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(5.55)])
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

    it "parses a negative and positive number" do
      source = "-20 +30"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([ Emerald::Number.new(-20),
                          Emerald::Number.new(30)])
    end
  end
end
