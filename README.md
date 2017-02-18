# Emerald

A Lisp that compiles to Ruby


## About

The compilation process:

1. Read the Lisp source code from a file.
2. Parse the source into an abstract syntax tree made up of Ruby objects.
3. Transform and optimise the AST if need be.
4. Convert the AST into strings of Ruby code.
5. Write the strings to files.
