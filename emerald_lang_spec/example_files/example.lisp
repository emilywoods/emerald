(defun test_method (x)
    (def y (- 1 6))
    (print (nil? x))
    (+ (* 2 x) (- 5 y)))

; compiles to:
; def test_method(x)
;   y = 1 - 6
;   print x.nil?
;   (2 * x) * (5 - y)
