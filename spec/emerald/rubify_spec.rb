require "spec_helper"
require "rubify"
require "emerald/atom"
require "emerald/string"
require "emerald/number"
require "emerald/list"

RSpec.describe Emerald::Rubify do

  it "compiles an empty source" do
    compiled_code = Emerald::Rubify.new([]).rubify
    expect(compiled_code).to eq('')
  end

  it "generates code from an empty list" do
    compiled_code = Emerald::Rubify.new( [ Emerald::List.new() ] ).rubify
    expect(compiled_code).to eq('')
  end

  describe "code generation from atoms" do
    it "generates a symbol from a single atom outside of a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::Atom.new("hello") ] ).rubify
      expect(compiled_code).to eq(':hello')
    end

    it "generates two symbols on separate lines from two atoms outside of a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::Atom.new("hello"), Emerald::Atom.new("world") ] ).rubify
      expect(compiled_code).to eq(":hello\n:world")
    end
  end

  describe "code generation from numbers" do
    it "generates a number from a single number" do
      compiled_code = Emerald::Rubify.new( [ Emerald::Number.new(5.0) ] ).rubify
      expect(compiled_code).to eq('5.0')
    end

    it "generates two numbers on separate lines from two numbers" do
      compiled_code = Emerald::Rubify.new( [ Emerald::Number.new(1.0), Emerald::Number.new(3.0) ] ).rubify
      expect(compiled_code).to eq("1.0\n3.0")
    end
  end

  describe "code generation from strings" do
    it "generates a string from a single string" do
      compiled_code = Emerald::Rubify.new( [ Emerald::String.new('"Hey there"') ] ).rubify
      expect(compiled_code).to eq('"Hey there"')
    end

    it "generates two strings on separate lines from two strings" do
      compiled_code = Emerald::Rubify.new( [ Emerald::String.new('"goat"'), Emerald::String.new('"duck"') ] ).rubify
      expect(compiled_code).to eq('"goat"'"\n"'"duck"')
    end
  end

  describe "numeric operations" do
    it "generates addition operations from addition functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('+'), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 + 2.0')
    end

    it "generates addition operations from addition functions within a list when the arguments are identical" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('+'), Emerald::Number.new(2.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('2.0 + 2.0')
    end

    it "generates addition operations from addtion functions within a list with several arguments" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('+'), Emerald::Number.new(1.0), Emerald::Number.new(2.0), Emerald::Number.new(9),  Emerald::Number.new(0.5) ) ]  ).rubify
      expect(compiled_code).to eq('1.0 + 2.0 + 9 + 0.5')
    end

    it "generates subtration operations from subtraction functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('-'), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 - 2.0')
    end

    it "generates division operations from division functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('/'), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 / 2.0')
    end

    it "generates multiplication from multiplication functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('*'), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 * 2.0')
    end

    it "generates less than operations from comparision functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('<'), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 < 2.0')
    end

    it "generates greater than operations from comparison functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('>'), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 > 2.0')
    end

    it "generates less than or equal to operations from comparison functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('<='), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 <= 2.0')
    end

    it "generates greater than or equal to operations from comparison functions within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new( Emerald::Atom.new('>='), Emerald::Number.new(1.0), Emerald::Number.new(2.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0 >= 2.0')
    end

    #it "generates addition with negative arguments" do
      #compiled_code = Emerald::Rubify.new([Emerald::Atom.new('+'), Emerald::Number.new(1.0), Emerald::Number.new(2.0), Emerald::Number.new(-9)]).rubify
      #expect(compiled_code).to eq('1.0 + 2.0 - 9')
    #end
  end

  describe "logical operations" do
    it "generates a symbol and a number on separate lines when querying nil outside a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::Atom.new('nil?'), Emerald::Number.new(1.0) ] ).rubify
      expect(compiled_code).to eq(':nil?'"\n"'1.0')
    end

    it "generates code for querying nil on number from a nil-querying function within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new(Emerald::Atom.new('nil?'), Emerald::Number.new(1.0) ) ] ).rubify
      expect(compiled_code).to eq('1.0.nil?')
    end

    it "generates code for querying nil on a string from a nil-querying function within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new(Emerald::Atom.new('nil?'), Emerald::String.new('"i like"') ) ] ).rubify
      expect(compiled_code).to eq('"i like".nil?')
    end

    it "generates code for querying empty on a string from an empty-querying function within a list" do
      compiled_code = Emerald::Rubify.new( [ Emerald::List.new(Emerald::Atom.new('empty?'), Emerald::String.new('"bumblebee"') ) ] ).rubify
      expect(compiled_code).to eq('"bumblebee".empty?')
    end

    it "raises an InvalidFunctionError when a list does not have a function call" do
      expect{ Emerald::Rubify.new( [ Emerald::List.new( Emerald::String.new('"bumblebee"') ) ] ).rubify }.to raise_error(Emerald::Rubify::InvalidFunctionError)
    end
  end
end
