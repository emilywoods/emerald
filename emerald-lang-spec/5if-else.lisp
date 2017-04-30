(if (< 2 20)
 (print "val1 is less than val2")
  (print "This will print if val1 is not less than val2")
  )

;compiles to:
;if 2 < 20
;  print "val1 is less than val2"
;else
;  print "Val1 is not less than val2"
;end


(if (< number 100) "yes" "no"))

;compiles to
(number < 100) ? "yes" : "no"
