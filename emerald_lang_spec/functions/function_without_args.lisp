(defun hello
  ()
    (print "Hello World"))

; the ast of this is:
; list
;   atom defun
;   atom hello
;   list
;   list
;       atom print
;       string "Hello World"

; compiles to:
; def hello
;   print "Hello World"
; end

