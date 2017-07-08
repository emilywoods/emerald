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
    compiled_code = Emerald::Rubify.new([list]).rubify
    expect(compiled_code).to eq("")
  end

  describe "code generation from atoms" do
    it "generates a symbol from a single atom outside of a list" do
      compiled_code = Emerald::Rubify.new([atom("hello")]).rubify
      expect(compiled_code).to eq("hello")
    end

    it "generates symbols on separate lines from two atoms outside a list" do
      compiled_code = Emerald::Rubify.new([atom("hello"),
                                           atom("world")]).rubify
      expect(compiled_code).to eq("hello\nworld")
    end
  end

  describe "code generation from numbers" do
    it "generates a number from a single number" do
      compiled_code = Emerald::Rubify.new([number(5.0)]).rubify
      expect(compiled_code).to eq("5.0")
    end

    it "generates two numbers on separate lines from numbers outside a list" do
      compiled_code = Emerald::Rubify.new([number(1.0),
                                           number(3.0)]).rubify
      expect(compiled_code).to eq("1.0\n3.0")
    end
  end

  describe "code generation from strings" do
    it "generates a string from a single string" do
      compiled_code = Emerald::Rubify.new([string('"Hey there"')]).rubify
      expect(compiled_code).to eq('"Hey there"')
    end

    it "generates two strings on separate lines from strings outside a list" do
      compiled_code = Emerald::Rubify.new([string('"goat"'),
                                           string('"duck"')]).rubify
      expect(compiled_code).to eq('"goat"' "\n" '"duck"')
    end
  end

  describe "numeric operations" do
    it "generates addition operations from addition functions within a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("+"),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 + 2.0")
    end

    it "generates addition operations from addition functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("+"),
                                              number(1.0),
                                              number(2.0),
                                              number(9),
                                              number(0.5)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 + 2.0 + 9 + 0.5")
    end

    it "generates subtration operations from subtraction functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("-"),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 - 2.0")
    end

    it "generates division operations from division functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("/"),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 / 2.0")
    end

    it "generates multiplication from multiplication functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("*"),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 * 2.0")
    end

    it "generates less than operations from comparision functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("<"),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 < 2.0")
    end

    it "generates greater than operations from comparison functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom(">"),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 > 2.0")
    end

    it "generates less than or equal to operations from comparison functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("<="),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 <= 2.0")
    end

    it "generates greater than or equal to operations from comparison functions in a list" do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom(">="),
                                              number(1.0),
                                              number(2.0)
                                            )
                                          ]).rubify
      expect(compiled_code).to eq("1.0 >= 2.0")
    end
  end

  describe "logical operations" do
    it "generates a symbol and a number on separate lines when querying nil outside a list" do
      compiled_code = Emerald::Rubify.new([atom("nil?"),
                                           number(1.0)]).rubify
      expect(compiled_code).to eq("nil?\n1.0")
    end

    it "generates code for querying nil on a number: (nil? 1.0)" do
      compiled_code = Emerald::Rubify.new(
        [list(atom("nil?"),
              number(1.0))]
      ).rubify
      expect(compiled_code).to eq("1.0.nil?")
    end

    it 'generates code for querying nil: (nil? "i like")' do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("nil?"),
                                              string('"i like"')
                                            )
                                          ]).rubify
      expect(compiled_code).to eq('"i like".nil?')
    end

    it 'generates code for querying empty: (empty? "bumblebee")' do
      compiled_code = Emerald::Rubify.new([
                                            list(
                                              atom("empty?"),
                                              string('"bumblebee"')
                                            )
                                          ]).rubify
      expect(compiled_code).to eq('"bumblebee".empty?')
    end

    it "raises an InvalidFunctionError when a list has no function call" do
      expect do
        Emerald::Rubify.new([
                              list(string('"bee"'))
                            ]).rubify
      end.to raise_error(Emerald::Rubify::InvalidLispFunctionError)
    end
  end

  describe "variable assignment" do
    it 'generates code for variable assignment of a string: (def input "Hello")' do
      compiled_code = Emerald::Rubify.new([list(
        atom("def"),
        atom("input"),
        string('"Hello"'))
                                          ]).rubify

      expect(compiled_code).to eq('input = "Hello"')
    end

    it "generates code for variable assignment of a number (def input 4)" do
      compiled_code = Emerald::Rubify.new([list(
        atom("def"),
        atom("input"),
        number(4))]).rubify

      expect(compiled_code).to eq("input = 4")
    end

    it "generates code for variable assignment of numbers: (def input (+ 4 2))" do
      compiled_code = Emerald::Rubify.new([list(
        atom("def"),
        atom("input"),
        list(
          atom("+"),
          number(4),
          number(2))
      )]).rubify

      expect(compiled_code).to eq("input = 4 + 2")
    end

    it "generates code for variable assignment (let ((x 4)))" do
      compiled_code = Emerald::Rubify.new([list(
        atom("let"),
        list(
          list(atom("x"), number(4))
        ))]).rubify

      expect(compiled_code).to eq("begin\n\tx = 4\nend")
    end

    it "generates code for local variable assignment (let ((x 4) (y 5)))" do
      compiled_code = Emerald::Rubify.new([list(
        atom("let"),
        list(
          list(atom("x"), number(4)),
          list(atom("y"), number(5)))
      )]).rubify

      expect(compiled_code).to eq("begin\n\tx = 4\n\ty = 5\nend")
    end

    it "generates code for local variable assignment for (let ((x 4) (y 5)) (+ x y))" do
      compiled_code = Emerald::Rubify.new([list(
        atom("let"),
        list(
          list(atom("x"), number(4)),
          list(atom("y"), number(5))),
        list(atom("+"), atom("x"), atom("y"))
      )]).rubify

      expect(compiled_code).to eq("begin\n\tx = 4\n\ty = 5\n\tx + y\nend")
    end
  end

  private

  def atom(value)
    Emerald::Atom.new(value)
  end

  def number(value)
    Emerald::Number.new(value)
  end

  def string(text)
    Emerald::String.new(text)
  end

  def list(*elements)
    Emerald::List.new(*elements)
  end
end
