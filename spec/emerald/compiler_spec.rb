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
    it "parses the lisp and returns an assigned global variable" do
      lisp_file_contents = "(def y (- 1 6))"
      compiled_lisp = Emerald::Compiler.new(lisp_file_contents).compile
      expect(compiled_lisp).to eq("$y = 1.0 - 6.0")
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
end
