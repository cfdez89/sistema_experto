
;;===================== Acerca de ==========================
;;TECNOLOGICO DE COSTA RICA
;;Inteligencia Artificial
;;Sistema experto
;;Carlos Fernández Jiménez
;;Mariano Montero
;;Kenneth Quiros
;;Danilo Artavia
;;===================== Comandos ==========================
;;(clear)
;;(load ./main.clp)
;;(reset)
;;(run)
;;===================== Template ==========================
(deftemplate intervalo
        (slot  semitono)
        (slot  nombre)
        (slot  simbolo)
)

(deftemplate notacion
        (slot  indice)
        (slot  nombre)
        (slot  altura)
)

(deftemplate nota
        (slot nombre)
        (slot  altura)
        (slot sistemaTonal)
)

(deftemplate triada
        (multislot acorde_1)
        (multislot acorde_2)
        (multislot acorde_3)
)

(deftemplate notasDisponibles
        (multislot notas)
)

(deftemplate notasDisponibleOrdenadas
        (multislot notas)
)

;;===================== Regla Inicio ==========================
(defrule main

        =>
        (assert (inicio))
)
;;obtiene el tipo de notacion a usar en el sistema
(defrule obtenerNotacion
        ?indice <- (inicio)
        =>
        ;;(load-facts "intervalo.dat")
        (printout t crlf "Sistema Experto" crlf crlf
                         "Indique el sistema de notacion que prefiere:" crlf
                         "-Digite 1 para Inglesa" crlf
                         "-Digite 2 para Italiana" crlf
                         "-Mi opcion elegida es: "
        )
        (bind ?tipoNotacion (read))
        (assert(notacionSeleccionada ?tipoNotacion))
        (retract ?indice)
)
;;cargar notacion seleccionada por el usuario si es valida
;;1 para italiana, 2 para inglesa
;;obtiene el tipo de tonalidad
(defrule esOpcionNotacionValida
        (notacionSeleccionada ?notacion)
        (or (test (eq ?notacion 1))
            (test (eq ?notacion 2)))
        =>
        (load-facts (str-cat "notacion_" ?notacion ".dat"))
        (printout t crlf "Indique como indicara la tonalidad:" crlf
                         "-Digite 1 para nombre" crlf
                         "-Digite 2 para numero y tipo de alteraciones" crlf
                         "Mi opcion elegida es: "
        )
        (bind ?tipoTonalidad (read))
        (assert(tonalidadSeleccionada ?tipoTonalidad))
)
;;valida si el tipo de notacion seleccionada es no valida
;;envia a estado de error si se cumple
(defrule esOpcionNotacionInvalida
        ?indice <- (notacionSeleccionada ?notacion)
        (and (not (test (eq ?notacion 1)))
             (not (test (eq ?notacion 2))))
        =>
        (retract ?indice)
        (printout t"Error: La notacion no es valida" crlf crlf)
        (assert (inicio))
)
;;valida si el tipo de tonalidad seleccionada es no valida
;;envia a estado de error si se cumple
(defrule esOpcionTonalidadInvalida
        ?indice <- (tonalidadSeleccionada  ?tonalidad)
        ?indiceNotacion <- (notacionSeleccionada ?notacion)
        (and (not (test (eq ?tonalidad 1)))
            (not (test (eq ?tonalidad 2))))
        =>
        (retract ?indiceNotacion ?indice)
        (printout t "Error: La opcion para tonalidad no es valida: " tonalidad crlf crlf)
        (assert (notacionSeleccionada  ?notacion))
)
;;obtiene el nombre de la tonalidad ingresada
(defrule esTonalidadPorNombre
        (tonalidadSeleccionada 1)
        =>
        (printout t crlf "-Digite el nombre de la tonalidad:")
        (bind ?nombreTonalidad (read))
        (assert (tonalidad ?nombreTonalidad))
)
;;obtiene el tipo de alteracion y el numero de ellas,
;;acorde a una tonalidad
(defrule esTonalidadPorAlteraciones
        (tonalidadSeleccionada 2)
        =>
        (printout t "-Digite el numero de alteraciones, rango [0,7]:"crlf)
        (bind ?numeroAlteraciones (read))
        (printout t "-Digite el tipo de alteracion (b ó #):"crlf)
        (bind ?tipoAlteracion (read))
        (assert (tonalidad ?numeroAlteraciones ?tipoAlteracion))
)
;;validad si el nombre de la tonalidad ingresada es valida
(defrule esTonalidadNombreValido
        (tonalidad ?tonalidadIngresada)
        ?indiceTonalidad <- (tonalidadSeleccionada  ?tonalidad)
        (notacion (indice ?) (nombre ?tonalidadIngresada) (altura ?))
        =>
        (retract ?indiceTonalidad)
        (assert (acorde))
)
;;si el nombre de la tonalidad no es validad imprime el error
(defrule esTonalidadNombreInvalido
        ?indice <- (tonalidad ?tonalidadIngresada)
        ?indiceTonalidad <- (tonalidadSeleccionada  ?tonalidad)
        (not (notacion (indice ?) (nombre ?tonalidadIngresada) (altura ?)))
        =>
        (retract ?indiceTonalidad ?indice)
        (printout t"Error: La tonalidad ingresada no es valida: " crlf crlf)
        (assert (tonalidadSeleccionada  ?tonalidad))
)

;;falta
(defrule esTonalidadAlteracionValido
        (tonalidad ?numero ?alteracion)
        (test (> ?numero -1))
        (test (< ?numero 8))
        (or (test (eq ?alteracion b))
            (test (eq ?alteracion #)))
        =>
        (assert (nodoActual 6))
)
;;Validación de un Rango falta
(defrule esTonalidadAlteracionInvalido
        (tonalidad ?numero ?alteracion)
        (or (not (and (test (> ?numero -1))
                 (test (< ?numero 8))))
                 (not (or (test (eq ?alteracion b))
                          (test (eq ?alteracion #)))))
        =>
        (printout t"Error: La tonalidad ingresada no es valida: " crlf crlf)
)
;;obtiene los datos para formar la triada
(defrule obtenerAcorde
        ?indice <- (acorde) ;;revisar si se cambia
        =>
        (printout t crlf "Ahora formemos el acorde!" crlf)
        (printout t crlf "-Digite la primer nota: ");;;validar la forma de ingresar datos
        (bind ?primerNota (read))
        (printout t "-Digite la primera altura: ");;;validar la forma de ingresar datos
        (bind ?primerAltura (read))
        (printout t "-Digite la segunda nota: ");;;validar la forma de ingresar datos
        (bind ?segundaNota (read))
        (printout t "-Digite la segunda altura: ");;;validar la forma de ingresar datos
        (bind ?segundaAltura (read))
        (printout t "-Digite la tercer nota: ");;;validar la forma de ingresar datos
        (bind ?tercerNota (read))
        (printout t "-Digite la tercer altura: ");;;validar la forma de ingresar datos
        (bind ?tercerAltura (read))
        (retract ?indice)
        (assert (alturas ?primerAltura ?segundaAltura ?tercerAltura))
        (assert (notas ?primerNota  ?segundaNota ?tercerNota))
        (assert (acorde ?primerNota ?primerAltura)
                (acorde ?segundaNota ?segundaAltura)
                (acorde ?tercerNota ?tercerAltura)
        )
)
;;verifica que las alturas dadas se encuentren entre [2, 5]
;;(defrule validarAlturas
  ;;;      ?indiceAlturas <- (alturasTmp $?inicio ?altura $?fin)
    ;;    (test (> ?altura 1))
      ;;  (test (< ?altura 6))
        ;;=>
      ;;  (assert (alturasTmp $?inicio ?altura $?fin))
      ;;  (retract ?indiceAlturas)

;;)
;;ordena las alturas de menor a mayor
(defrule ordenarAlturas
  ?indiceNotas <- (notas $?notas);;podria declararse la lista de errores en deffacts y preguntar aca si es 0
  (test (> (length$ $?notas) 0))
  ?indiceAlturas <- (alturas $?inicio ?num1 ?num2 $?fin)
  (test (> ?num1 ?num2))
  =>
  (assert (alturas $?inicio ?num2 ?num1 $?fin))
  (retract ?indiceAlturas)
)
;;crea una triada con 3 acordes, ordenada por su altura
(defrule ordenarTriadaAltura
        ?indiceNotas <- (notas $?notas)
        (test (= (length$ $?notas) 0))
        ?indiceAltura <- (alturas ?primerAltura ?segundaAltura ?tercerAltura)
        ?indiceAcorde1 <- (acorde ?primerNota ?primerAltura)
        ?indiceAcorde2 <- (acorde ?segundaNota ?segundaAltura)
        ?indiceAcorde3 <- (acorde ?tercerNota ?tercerAltura)
        =>
        (assert (triada (acorde_1 ?primerNota ?primerAltura)
                        (acorde_2 ?segundaNota ?segundaAltura)
                        (acorde_3 ?tercerNota ?tercerAltura)
                )
        )
        (retract ?indiceNotas ?indiceAltura ?indiceAcorde1 ?indiceAcorde2 ?indiceAcorde3)
);;############################################
;;carga la escala de notas de la tonalidad en sostenidos
(defrule usarNotasSostenidos
        ?indiceTipoNotacion <- (notacionSeleccionada ?notacion)
        (tonalidad ?tonalidad)
        (notacion (indice ?indice) (nombre ?tonalidad) (altura ?))
        (test (> ?indice 0))
        =>
        (load-facts (str-cat "sostenidos_" ?notacion ".dat"))
        (retract ?indiceTipoNotacion)
)
;;carga la escala de notas de la tonalidad en bemoles
(defrule usarNotasBemoles
        ?indiceTipoNotacion <- (notacionSeleccionada ?notacion)
        (tonalidad ?tonalidad)
        (notacion (indice ?indice) (nombre ?tonalidad) (altura ?))
        (test (< ?indice 0))
        =>
        (load-facts (str-cat "bemoles_" ?notacion ".dat"))
        (retract ?indiceTipoNotacion)
)

(defrule ordenarNotasDisponibles
        (tonalidad ?tonalidad)
        ?indice <- (notasDisponibles(notas $?inicio ?tonalidad $?fin))
        =>
        (assert (notasDisponibleOrdenadas (notas ?tonalidad $?fin $?inicio)))
        (retract ?indice)
)

(defrule generarEscalaMayor
        (notasDisponibleOrdenadas (notas ?n1 ?n2 ?n3 ?n4 ?n5 ?n6 ?n7 ?n8 ?n9 ?n10 ?n11 ?n12))
        =>
        (assert (escalaMayor ?n1 ?n3 ?n5 ?n7 ?n8 ?n10 ?n12))
        (assert (notasInvalidas))
)
;;verifica que las notas de los acordes pertenezcan a la escala de la tonalidad
(defrule notasEnEscalaValido
        ?indice <- (notas ?cabeza $?cola)
        (escalaMayor $?inicio ?cabeza $?fin)
        =>
        (retract ?indice)
        (assert (notas $?cola))
)
;;verifica que las notas de los acordes no pertenezcan a la escala de la tonalidad
;;agrega las notas que no pertenezcan a una lista de notas no validas
(defrule notasEnEscalaInvalido
        ?indice <- (notas ?cabeza $?cola)
        ?indiceErrores <- (notasInvalidas $?notasInvalidas)
        (escalaMayor $?escala)
        (test (> (length$ $?escala) 0))
        (not (escalaMayor $?inicio ?cabeza $?fin))
        =>
        (retract ?indice ?indiceErrores)
        (assert (notasInvalidas $?notasInvalidas ?cabeza))
        (assert (notas $?cola))
)
;;imprime en pantalla las notas que no pertenecen a la escala
;;de la tonalidad dada, se redirige a un menu de opciones
(defrule mostrarNotasEnEscalaInvalido
        (notasInvalidas $?notas)
        (test (> (length$ $?notas) 0))
        (tonalidad ?tonalidad)
        =>
        (printout t crlf "Error: Las siguientes notas no son válidas en la escala de " ?tonalidad ":" crlf )
        (printout t  $?notas crlf crlf)
)
;;verifica las distancias entre los acordes para saber si la triada
;;es una ecala mayor con respecto a la tonalidad dada
(defrule esAcordeMayorValido
        (notasDisponibleOrdenadas (notas $?notas))
        (test (> (length$ $?notas) 0))
        (triada (acorde_1 ?primerNota ?primerAltura)
                (acorde_2 ?segundaNota ?segundaAltura)
                (acorde_3 ?tercerNota ?tercerAltura)
        )
        (test (= (- (member$ ?primerNota $?notas) 1) 0))
        (test (= (- (member$ ?segundaNota $?notas) 1) 4))
        (test (= (- (member$ ?tercerNota $?notas) 1) 7))
        =>
        (printout t "Es acorde mayor "crlf crlf)

)
;;verifica las distancias entre los acordes para saber si la triada
;;no es una ecala mayor con respecto a la tonalidad dada
(defrule esAcordeMayorInvalido
        (notasDisponibleOrdenadas (notas $?notas))
        (test (> (length$ $?notas) 0))
        (triada (acorde_1 ?primerNota ?primerAltura)
                (acorde_2 ?segundaNota ?segundaAltura)
                (acorde_3 ?tercerNota ?tercerAltura)
        )
        (or (not (test (= (- (member$ ?primerNota $?notas) 1) 0)))
            (not (test (= (- (member$ ?segundaNota $?notas) 1) 4)))
            (not (test (= (- (member$ ?tercerNota $?notas) 1) 7)))
        )
        =>
        (printout t "Es acorde no es valido "crlf crlf)

)
;;link de funciones clips
;;;https://www.csie.ntu.edu.tw/~sylee/courses/clips/rhs.htm

;;falta verificar que la altura asociada sea correcta
;;verificar que si se divide en 2 xq es muy larga la distancia



;;ordena la triada por nota
;;(defrule ordenarTriadaNota)



;;Ordenar la triada primero por altura
;;luego por notas

;;Buscar cual es la tónica-> la de 0 semitonos.
;;Busca la dominante->4 semitonos con respecto a la tonalidad.
;;Buscar la pentatonica-> 7 semitonos

;;Si cumple lo anterior es que es un acorde mayor
;;Otra regla que haga lo mismo, pero para las inversiones.

;;Como programar la regla para las otras escalas
