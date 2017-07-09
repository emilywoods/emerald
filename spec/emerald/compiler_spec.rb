require "spec_helper"
require_relative "../../lib/emerald/compiler"

RSpec.describe "Compiler" do
  context "when the compiler receives a lisp input" do
    it "parses the lisp and then returns a ruby string" do
      lisp_file_contents = "(+ 2 2)"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("2.0 + 2.0")
    end
  end

  context "when the contents of the file are empty" do
    it "parses the lisp and then returns an empty string" do
      lisp_file_contents = ""
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("")
    end
  end

  context "when the contents of the file define a variable" do
    it "parses the lisp and returns an assigned variable" do
      lisp_file_contents = "(def y (- 1 6))"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("y = 1.0 - 6.0")
    end

    it "parses the lisp and returns an assigned local variable" do
      lisp_file_contents = "(let ((x 1) (y (+ 3 4))) x)"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("begin\n\tx = 1.0\n\ty = 3.0 + 4.0\n\tx\nend")
    end

    it "parses the lisp and returns an assigned local variable with operations" do
      lisp_file_contents = "(let ((x 1) (y (+ 3 4))) (- y x))"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("begin\n\tx = 1.0\n\ty = 3.0 + 4.0\n\ty - x\nend")
    end
  end

  context "when the contents of the file define a function" do
    it "parses the function and assigns it as a method" do
      lisp_file_contents = "(defun half () 0.5)"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("def half\n\t0.5\nend")
    end

    it "parses a function an argument and assigns it as a method" do
      lisp_file_contents= "(defun half (x) (* x 0.5))"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("def half(x)\n\tx * 0.5\nend")
    end

    it "parses a function arguments and assigns it as a method" do
      lisp_file_contents= "(defun half (x y) (* x y))"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("def half(x, y)\n\tx * y\nend")
    end
  end
end
