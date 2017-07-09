(defun hello
  ()
    (print "Hello World"))

;compiles to:
;def hello
;  print "Hello World"
;end


(defun add-this
       (a b)
       (+ a b))

;compiles to:
;def add-this (a, b)
;  a + b
;end


;OPTIONAL ARGUMENTS!!!

(defun print-first
  (& arguments)
  (print (first arguments)))

;compiles to:
;def print-first(*arguments)
;  print arguments.first
;end


(fn (x) (* 2 x))
;compiles to:
; { |x| 2 * x }


;see: methods are functions that belong to a class
;functions not
;could state that all methods are functions, but not all functions are methods
;https://stackoverflow.com/questions/155609/difference-between-a-method-and-a-function

;function -
;method - generic functions