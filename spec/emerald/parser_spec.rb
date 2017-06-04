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
      expect(ast).to eq([Emerald::Number.new(12_345),
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

  describe "string parsing" do
    it "parses a string ofcharacters" do
      source = '"Hello"'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"Hello"')])
    end

    it "parses a string of characters and whitespace" do
      source = '"Hello this is a string"'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"Hello this is a string"')])
    end

    it "parses a string of characters, whitespace and digits" do
      source = '"H3llo this is 1 str1ng"'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"H3llo this is 1 str1ng"')])
    end

    it "parses a string of characters, whitespace, digits and symbols" do
      source = '"H3llo, this is 1 str1ng."'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"H3llo, this is 1 str1ng."')])
    end

    it "parses unusual strings" do
      source = '"A weird string -> \" <- "'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"A weird string -> \" <- "')])
    end

    it "parses a string with quotation marks after a backslash" do
      source = '"Say \"hello\""'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"Say \"hello\""')])
    end

    it "parses a string over two lines" do
      source = '"A multiline \n  string"'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"A multiline \n  string"')])
    end

    it "parses a multiline string" do
      source = '"This is another
      string across
      three lines"'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"This is another
      string across
      three lines"')])
    end

    it "parses two separate strings" do
      source = '"This is one string""This is another string"'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"This is one string"'),
                         Emerald::String.new('"This is another string"')])
    end
  end

  describe "list parsing" do
    it "parses a list do" do
      source = "()"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new])
    end

    it "parses a list of atoms" do
      source = "(3 2)"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new(Emerald::Number.new(3),
                                           Emerald::Number.new(2))])
    end

    it "parses a list within a list" do
      source = "(3 2 (hello))"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new(Emerald::Number.new(3),
                                           Emerald::Number.new(2),
                                           Emerald::List.new(
                                             Emerald::Atom.new("hello")
                                           ))])
    end

    it "parses lists within lists" do
      source = "(+ 2 (+ 3 (- 4 ) ) )"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new(Emerald::Atom.new("+"),
                                           Emerald::Number.new(2),
                                           Emerald::List.new(
                                             Emerald::Atom.new("+"),
                                             Emerald::Number.new(3),
                                             Emerald::List.new(
                                               Emerald::Atom.new("-"),
                                               Emerald::Number.new(4)
                                             )
                                           ))])
    end

    it "parses a list which contains a list and a number in the outer list" do
      source = "(+ (- 0 1) 2)"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new(Emerald::Atom.new("+"),
                                           Emerald::List.new(
                                             Emerald::Atom.new("-"),
                                             Emerald::Number.new(0),
                                             Emerald::Number.new(1)
                                           ),
                                           Emerald::Number.new(2))])
    end

    it "parses nested lists with numbers to the left of the lists" do
      source = "(+ 2 (+ 3 ) 3 4)"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new(Emerald::Atom.new("+"),
                                           Emerald::Number.new(2),
                                           Emerald::List.new(
                                             Emerald::Atom.new("+"),
                                             Emerald::Number.new(3)
                                           ),
                                           Emerald::Number.new(3),
                                           Emerald::Number.new(4))])
    end

    it "parses lists for local variable assignment" do
      source = "(let ((x 1 y 2)) x)"
      ast = Emerald::Parser.new(source).parse

      expect(ast).to eq([Emerald::List.new(Emerald::Atom.new("let"),
                                           Emerald::List.new(
                                           Emerald::List.new(
                                             Emerald::Atom.new("x"),
                                             Emerald::Number.new(1),
                                             Emerald::Atom.new("y"),
                                             Emerald::Number.new(2)
                                           )),
                                           Emerald::Atom.new("x"))])
    end

    it "parses lists for local variable assignment with operations" do
      source = "(let ( (x 1) (+ x 3 )))"
      ast = Emerald::Parser.new(source).parse

      expect(ast).to eq([Emerald::List.new(Emerald::Atom.new("let"),
                                           Emerald::List.new( Emerald::List.new(
                                               Emerald::Atom.new("x"),
                                               Emerald::Number.new(1)
                                           ),
                                                              Emerald::List.new(
                                                                  Emerald::Atom.new("+"),
                                                                  Emerald::Atom.new("x"),
                                                                  Emerald::Number.new(3)
                                                              ))
                                          )])
    end

    it "raises an error for invalid lists missing closing bracket" do
      source = "(+ 2 (+ 3 5)"
      expect { Emerald::Parser.new(source).parse }.to \
        raise_error(Emerald::Parser::InvalidListError)
        .with_message(Emerald::Parser::ERROR_INVALID_LIST)
    end

    it "raises an error for invalid lists missing opening bracket" do
      source = "(+ 2 - 3 5) 2)"
      expect { Emerald::Parser.new(source).parse }.to \
        raise_error(Emerald::Parser::InvalidListError)
        .with_message(Emerald::Parser::ERROR_INVALID_LIST)
    end

    it "parses a paretheses within a string" do
      source = '(print "(this")'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::List.new(Emerald::Atom.new("print"),
                                           Emerald::String.new('"(this"'))])
    end
  end

  describe "number, atom and string parsing" do
    it "parses a string and a number" do
      source = '"This is one string" -20'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"This is one string"'),
                         Emerald::Number.new(-20)])
    end

    it "parses a string and a atom" do
      source = '"This is one string" hello'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::String.new('"This is one string"'),
                         Emerald::Atom.new("hello")])
    end

    it "parses one number and one atom" do
      source = "11 hey"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(11),
                         Emerald::Atom.new("hey")])
    end

    it "parses a combination of atoms and numbers" do
      source = "2 eyes 10 toes"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(2),
                         Emerald::Atom.new("eyes"),
                         Emerald::Number.new(10),
                         Emerald::Atom.new("toes")])
    end

    it "parses a negative and positive number" do
      source = "-20 +30"
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(-20),
                         Emerald::Number.new(30)])
    end

    it "parses a snumber, atom and string" do
      source = ' 456 "Look at this!" what'
      ast = Emerald::Parser.new(source).parse
      expect(ast).to eq([Emerald::Number.new(456),
                         Emerald::String.new('"Look at this!"'),
                         Emerald::Atom.new("what")])
    end
  end
end
