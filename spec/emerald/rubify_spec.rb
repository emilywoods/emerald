require "spec_helper"
require "emerald/rubify"
require "emerald/atom"
require "emerald/string"
require "emerald/number"
require "emerald/list"

RSpec.describe Emerald::Rubify do
  it "compiles an empty source" do
    compiled_code = Emerald::Rubify.new([]).rubify
    expect(compiled_code).to eq("")
  end

  it "generates code from an empty list" do
    compiled_code = Emerald::Rubify.new([Emerald::List.new]).rubify
    expect(compiled_code).to eq("")
  end

  describe "code generation from atoms" do
    it "generates a symbol from a single atom outside of a list" do
      compiled_code = Emerald::Rubify.new([Emerald::Atom.new("hello")]).rubify
      expect(compiled_code).to eq("hello")
    end

    it "generates symbols on separate lines from two atoms outside a list" do
      compiled_code = Emerald::Rubify.new([Emerald::Atom.new("hello"),
                                           Emerald::Atom.new("world")]).rubify
      expect(compiled_code).to eq("hello\nworld")
    end
  end

  describe "code generation from numbers" do
    it "generates a number from a single number" do
      compiled_code = Emerald::Rubify.new([Emerald::Number.new(5.0)]).rubify
      expect(compiled_code).to eq("5.0")
    end

    it "generates two numbers on separate lines from numbers outside a list" do
      compiled_code = Emerald::Rubify.new([Emerald::Number.new(1.0),
                                           Emerald::Number.new(3.0)]).rubify
      expect(compiled_code).to eq("1.0\n3.0")
    end
  end

  describe "code generation from strings" do
    it "generates a string from a single string" do
      compiled_code = Emerald::Rubify.new(
        [Emerald::String.new('"Hey there"')]
      ).rubify
      expect(compiled_code).to eq('"Hey there"')
    end

    it "generates two strings on separate lines from strings outside a list" do
      compiled_code = Emerald::Rubify.new([Emerald::String.new('"goat"'),
                                           Emerald::String.new('"duck"')]).rubify
      expect(compiled_code).to eq('"goat"' "\n" '"duck"')
    end
  end

  describe "numeric operations" do
    it "generates addition operations from addition functions within a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("+"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 + 2.0")
    end

    it "generates addition operations from addtion functions with several args" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("+"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0),
                                              Emerald::Number.new(9),
                                              Emerald::Number.new(0.5)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 + 2.0 + 9 + 0.5")
    end

    it "generates subtration operations from subtraction functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("-"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 - 2.0")
    end

    it "generates division operations from division functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("/"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 / 2.0")
    end

    it "generates multiplication from multiplication functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("*"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 * 2.0")
    end

    it "generates less than operations from comparision functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("<"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 < 2.0")
    end

    it "generates greater than operations from comparison functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new(">"),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 > 2.0")
    end

    it "generates less than or equal to operations from comparison functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("<="),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 <= 2.0")
    end

    it "generates greater than or equal to operations from comparison functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new(">="),
                                              Emerald::Number.new(1.0),
                                              Emerald::Number.new(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 >= 2.0")
    end
  end

  describe "logical operations" do
    it "generates a symbol and a number on separate lines when querying nil outside a list" do
      compiled_code = Emerald::Rubify.new([Emerald::Atom.new("nil?"),
                                           Emerald::Number.new(1.0)]).rubify
      expect(compiled_code).to eq("nil?\n1.0")
    end

    it "generates code for querying nil on a number from a nil-query function" do
      compiled_code = Emerald::Rubify.new(
        [Emerald::List.new(Emerald::Atom.new("nil?"),
                           Emerald::Number.new(1.0))]
      ).rubify
      expect(compiled_code).to eq("1.0.nil?")
    end

    it "generates code for querying nil on a string from a nil-query function" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("nil?"),
                                              Emerald::String.new('"i like"')
                                            )
                                          ]).rubify
      expect(compiled_code).to eq('"i like".nil?')
    end

    it "generates code for querying empty from an empty-query function in a list" do
      compiled_code = Emerald::Rubify.new([
                                            Emerald::List.new(
                                              Emerald::Atom.new("empty?"),
                                              Emerald::String.new('"bumblebee"')
                                            )
                                          ]).rubify
      expect(compiled_code).to eq('"bumblebee".empty?')
    end

    it "raises an InvalidFunctionError when a list has no function call" do
      expect do
        Emerald::Rubify.new([
                              Emerald::List.new(Emerald::String.new('"bee"'))
                            ]).rubify
      end.to raise_error(Emerald::Rubify::InvalidLispFunctionError)
    end
  end

  describe "variable assignment" do
    it "generates code for global variable assignment of a string" do
      compiled_code = Emerald::Rubify.new([Emerald::List.new(
        Emerald::Atom.new("def"),
        Emerald::Atom.new("input"),
        Emerald::String.new('"Hello"'))
                                          ]).rubify

      expect(compiled_code).to eq('$input = "Hello"')
    end

    it "generates code for global variable assignment of a number" do
      compiled_code = Emerald::Rubify.new([Emerald::List.new(
        Emerald::Atom.new("def"),
        Emerald::Atom.new("input"),
        Emerald::Number.new(4))]).rubify

      expect(compiled_code).to eq("$input = 4")
    end

    it "generates code for global variable assignment of numbers" do
      compiled_code = Emerald::Rubify.new([Emerald::List.new(
        Emerald::Atom.new("def"),
        Emerald::Atom.new("input"),
        Emerald::List.new(
          Emerald::Atom.new("+"),
          Emerald::Number.new(4),
          Emerald::Number.new(2))
      )]).rubify

      expect(compiled_code).to eq("$input = 4 + 2")
    end

    it "generates code for local variable assignment for x = 4 " do
      compiled_code = Emerald::Rubify.new([Emerald::List.new(
        Emerald::Atom.new("let"),
        Emerald::Vector.new(Emerald::Atom.new("x"), Emerald::Number.new(4)))]).rubify

      expect(compiled_code).to eq("begin\n\tx = 4\nend")
    end

    it "generates code for local variable assignment of two variables: x = 4 and y = 5" do
      compiled_code = Emerald::Rubify.new([Emerald::List.new(
        Emerald::Atom.new("let"),
        Emerald::Vector.new(Emerald::Atom.new("x"), Emerald::Number.new(4),
                            Emerald::Atom.new("y"), Emerald::Number.new(5)))]).rubify

      expect(compiled_code).to eq("begin\n\tx = 4\n\ty = 5\nend")
    end

    it "generates code for local variable assignment of two numbers with addition" do
      compiled_code = Emerald::Rubify.new([Emerald::List.new(
        Emerald::Atom.new("let"),
        Emerald::Vector.new(Emerald::Atom.new("x"), Emerald::Number.new(4),
                            Emerald::Atom.new("y"), Emerald::Number.new(5)),
        Emerald::List.new(Emerald::Atom.new("+"), Emerald::Atom.new("x"), Emerald::Atom.new("y"))
      )]).rubify

      expect(compiled_code).to eq("begin\n\tx = 4\n\ty = 5\n\tx + y\nend")
    end
  end
end
