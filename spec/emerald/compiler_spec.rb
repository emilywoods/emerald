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
end
