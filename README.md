# Emerald

A Ruby language with Lisp syntax.


## About

The compilation process:

1. Read the Lisp source code from a file.
2. Parse the source into an abstract syntax tree made up of Ruby objects.
3. Transform and optimise the AST if need be.
4. Convert the AST into strings of Ruby code.
5. Write the strings to files.

## Usage
To compile an emerald file e.g `example.emerald` , run: 
```
ruby emerald.rb example.emerald
``` 

The evaluated code will be output to the console, and the generated Ruby code will be can be found in `compiled_lisp.rb`

## Tests
To run all tests, run: 
```
rspec spec
```

## Formatting
To run linting with Rubocop, run: 
```
bundle exec rubocop
```