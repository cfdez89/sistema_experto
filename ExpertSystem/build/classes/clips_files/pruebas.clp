(deffacts hechos-iniciales
   (lista 4 1 6 )

)

(defrule ordena-lista
   ?indice<-(lista $?ini ?num1 ?num2 $?fin)
   (test (> ?num1 ?num2))
   =>
   (printout t $?ini )
    (printout t $?fin)
   (assert (lista $?ini ?num2 ?num1 $?fin))
   (retract ?indice)
)


;;(defrule print-lista-2
  ;; (lista $?values)
   ;;(not (lista $?ini ?num1 ?num2&:(< ?num1 ?num2) $?fin))
   ;;=>
   ;;(printout t "print2: " (str-implode ?values) crlf)
;;)



(defrule print-lista-1
  (declare (salience -10))
    (lista $?values)
  =>
    (printout t "print1: " (str-implode ?values) crlf)
)
