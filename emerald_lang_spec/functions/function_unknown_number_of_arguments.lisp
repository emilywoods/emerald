(defun print_first
  [& arguments]
  (print (first arguments)))

; compiles to:
; def print_first(*arguments)
;  print arguments.first
; end
