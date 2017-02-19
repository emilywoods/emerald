;
; Exploring use of modules
;

(defmodule
  MyModule

  (defun double (x)
    (+ x x)))

(MyModule/double 2)

;
; This would compile to this Ruby code:
;
; module MyModule
;   def self.double(x)
;     x + x
;   end
; end
;
; MyModule.double(2)
