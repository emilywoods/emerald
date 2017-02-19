; This is a comment

(defun puts-twice (thing)
  (puts thing)
  (puts thing))

; This is the AST of this program
;
; list
;   atom defun
;   atom print-twice
;   list
;     atom thing
;   list
;     atom print
;     atom thing
;   list
;     atom print
;     atom thing

;
; It would compile to this Ruby code
;
; def print_twice(thing)
;   puts(thing)
;   puts(thing)
; end
