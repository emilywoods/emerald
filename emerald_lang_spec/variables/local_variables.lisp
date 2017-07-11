(let ((x 1) (y (+ 3 4)))
        (- y x))


; compiles to:
; begin
;   x = 1.0
;   y = 3.0 + 4.0
;   y - x
; end