(def y (- 1 6))

; the ast of this is:
; list
;   atom def
;   atom y
;   list
;       atom -
;       number 1
;       number 6

; compiles to: y = 1 - 6

; evaluates to: - 5