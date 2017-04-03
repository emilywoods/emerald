require "spec_helper"
require "emerald/rubify"

RSpec.describe Emerald::Rubify do

  it "compiles an empty source" do
    ast = Emerald::Rubify.new([]).rubify
    expect(ast).to eq('')
  end

  describe "code generation from atoms" do
    it "generates code from a single atom" do
      ast = Emerald::Rubify.new([Emerald::Atom.new("hello-world")]).rubify     
      expect(ast).to eq('hello-world')
    end

    it "generates code from two atoms" do
      ast = Emerald::Rubify.new([Emerald::Atom.new("hello"),Emerald::Atom.new("world")]).rubify
      expect(ast).to eq('hello world')
    end
  end

  describe "code generation from numbers" do
    it "generates code from a single number" do
      ast = Emerald::Rubify.new([Emerald::Number.new(5.0)]).rubify     
      expect(ast).to eq('5.0')
    end

    it "generates code from two atoms" do
      ast = Emerald::Rubify.new([Emerald::Number.new(1.0),Emerald::Atom.new(3.0)]).rubify
      expect(ast).to eq('1.0 3.0')
    end
  end

  describe "code generation from strings" do
    it "generates code from a single string" do
      ast = Emerald::Rubify.new([Emerald::String.new('"Hey there"')]).rubify     
      expect(ast).to eq('"Hey there"')
    end

    it "generates code from two strings" do
      ast = Emerald::Rubify.new([Emerald::String.new('"goat"'),Emerald::String.new('"duck"')]).rubify
      expect(ast).to eq('"goat" "duck"')
    end
  end

end
