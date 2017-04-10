(defn hello
  []
    (print "Hello World"))

;compiles to:
;def hello
;  print "Hello World"
;end


(defn add-this
       [a b]
       (+ a b))

;compiles to:
;def add-this (a, b)
;  a + b
;end


(defn print-first
  [& arguments]
  (print (first arguments)))

;compiles to:
;def print-first(*arguments)
;  print arguments.first
;end
