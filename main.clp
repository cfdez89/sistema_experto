
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

(deftemplate bemoles
        (slot nombre)
)

(deftemplate triada
        (multislot acorde_1)
        (multislot acorde_2)
        (multislot acorde_3)
)

;;===================== Regla Inicio ==========================
(defrule main

        =>
        (assert (start))
)
;;obtiene el tipo de notacion a usar en el sistema
(defrule obtenerNotacion
        ?indice <- (start)
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
        ?indice <- (notacionSeleccionada ?notacion)
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
        (assert (start))
)
;;valida si el tipo de tonalidad seleccionada es valida
;;1 para nombre, 2 para numero y tipo de alteracion
(defrule esOpcionTonalidadValida
        (tonalidadSeleccionada ?tonalidad)
        ?indice <- (notacionSeleccionada ?notacion)
        (or (test (eq ?tonalidad 1))
            (test (eq ?tonalidad 2)))
        =>
        (retract ?indice)
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
;;falta
(defrule esTonalidadPorAlteraciones
        (tonalidadSeleccionada 2)
        =>
        (assert(nodoActual 5))
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


;;Tonalidad Alteraciones falta
(defrule obtenerTonalidadPorAlteraciones
        (nodoActual 5)
        ?indice <- (nodoActual 5)
        =>
        (printout t "-Digite el numero de alteraciones, rango [0,7]:"crlf)
        (bind ?numeroAlteraciones (read))
        (printout t "-Digite el tipo de alteracion:"crlf)
        (bind ?tipoAlteracion (read))
        (assert (tonalidad ?numeroAlteraciones ?tipoAlteracion ))
        (retract ?indice);;;jjjj
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
        (assert (acorde ?primerNota ?primerAltura)
                (acorde ?segundaNota ?segundaAltura)
                (acorde ?tercerNota ?tercerAltura)
        )
)
;;ordena las alturas de menor a mayor
(defrule ordenarAlturas
  ?indice <- (alturas $?inicio ?num1 ?num2 $?fin)
  (test (> ?num1 ?num2))
  =>
  (assert (alturas $?inicio ?num2 ?num1 $?fin))
  (retract ?indice)
)
;;crea una triada con 3 acordes, ordenada por su altura
(defrule ordenarTriadaAltura
        (declare (salience -10))
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
        (retract ?indiceAltura ?indiceAcorde1 ?indiceAcorde2 ?indiceAcorde3)
)
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
