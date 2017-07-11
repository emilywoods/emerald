;
; Exploring use of classes
;

(defclass Animal ()

  (defun legs ()
    4))


(defclass Dog (Animal)

  (defmethod bark ()
    "woof!"))


(defclass Human (Animal)

  (defun legs ()
    2)

  (defmethod pay-taxes ()
    "Fine..."))

(let ((fido (.new Dog))
      (jane (.new Human)))

  (Animal/legs)
  (Dog/legs)
  (Human/legs)

  (.pay-taxes jane)
  (.bark fido))

;
; This would compile to the following Ruby code
;
;
; class Animal
;   def self.legs
;     4
;   end
; end
;
; class Dog < Animal
;   def bark
;     "woof!"
;   end
; end
;
; class Human < Animal
;   def self.legs
;     2
;   end
;
;   def pay_taxes
;     "Fine..."
;   end
; end
;
; begin
;   fido = Dog.new
;   jane = Human.new
;   Animal.legs
;   Dog.legs
;   Human.legs
;   jane.pay_taxes
;   fido.bark
; end
