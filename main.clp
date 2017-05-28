
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
        (printout t "tonalidad: " ?tonalidad)
)

;;valida si el tipo de tonalidad seleccionada es no valida
;;envia a estado de error si se cumple
(defrule esOpcionTonalidadInvalida
        ?indice <- (tonalidadSeleccionada  ?tonalidad)
        ?indiceNotacion <- (notacionSeleccionada ?notacion)
        (and (not (test (eq ?tonalidad 1)))
             (not (test (eq ?tonalidad 2))))
        =>
        (retract ?indiceNotacion)
        (retract ?indice)
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

(defrule esTonalidadPorAlteraciones
        (tonalidadSeleccionada 2)
        =>
        (assert(nodoActual 5))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;validad si el nombre de la tonalidad ingresada es valida
;;
(defrule esTonalidadNombreValido
        (tonalidad ?tonalidadIngresada)
        ?indiceTonalidad <- (tonalidadSeleccionada  ?tonalidad)
        (notacion (indice ?) (nombre ?tonalidadIngresada) (altura ?))
        =>
        (retract ?indiceTonalidad)
        (printout t "Tonalidad valida")
        (assert (acorde))
)
;;si el nombre de la tonalidad no es validad imprime el error
(defrule esTonalidadNombreInvalido
        ?indice <- (tonalidad ?tonalidadIngresada)
        ?indiceTonalidad <- (tonalidadSeleccionada  ?tonalidad)
        (not (notacion (indice ?) (nombre ?tonalidadIngresada) (altura ?)))
        =>
        (retract ?indiceTonalidad)
        (retract ?indice)
        (printout t"Error: La tonalidad ingresada no es valida: " crlf crlf)
        (assert (tonalidadSeleccionada  ?tonalidad))
)


;;Tonalidad Alteraciones
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

(defrule esTonalidadAlteracionValido
        (tonalidad ?numero ?alteracion)
        (test (> ?numero -1))
        (test (< ?numero 8))
        (or (test (eq ?alteracion b))
            (test (eq ?alteracion #)))
        =>
        (assert (nodoActual 6))
)
;;Validación de un Rango
(defrule esTonalidadAlteracionInvalido
        (tonalidad ?numero ?alteracion)
  (or (not (and (test (> ?numero -1))
                (test (< ?numero 8))))
            (not (or (test (eq ?alteracion b))
                     (test (eq ?alteracion #)))))
        =>
        (printout t"Error: La tonalidad ingresada no es valida: " crlf crlf)
)
;;Acorde pedir la triada
(defrule obtenerAcorde
        ?indice <- (acorde)   
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
        (assert (acorde ?primerNota ?primerAltura ?segundaNota ?segundaAltura ?tercerNota ?tercerAltura))
        (assert(nodoActual 7))
)

(defrule ordenarAcordeAltura
        ?h1 <- (listaOrdenada $?r)
        ?h2 <- (indices ?x $?d)
        (not (indices ?y&:(< ?y ?x) $?))
        =>
        (retract ?h1 ?h2)
        (assert (listaOrdenada $?r ?x) (indices ?d))
)

(defrule ordenaAcordePorAlturaPar1
        ?indice <- (nodoActual 7)
        ?indiceAcorde <- (acorde ?primerNota ?primerAltura ?segundaNota ?segundaAltura ?tercerNota ?tercerAltura)
        (test (>  ?primerAltura ?segundaAltura))
        =>
        (assert(acorde ?segundaNota ?segundaAltura ?primerNota ?primerAltura ?tercerNota ?tercerAltura))
        (retract ?indiceAcorde)
        (retract ?indice)
        (assert(nodoActual 8))
)

(defrule ordenaAcordePorAlturaFinalPar2
        (nodoActual 8)
        ?indice <- (nodoActual 8)
        ?indiceAcorde <- (acorde ?primerNota ?primerAltura ?segundaNota ?segundaAltura ?tercerNota ?tercerAltura)
        (test (>  ?segundaAltura ?tercerAltura))
        =>
        (assert(acorde ?primerNota ?primerAltura ?tercerNota ?tercerAltura ?segundaNota ?segundaAltura ))
        (retract ?indiceAcorde)
        (retract ?indice)
        (assert(nodoActual 9))

)

(defrule esAcordeValido
        (acorde ?primerNota ?primerAltura  ?segundaNota ?segundaAltura  ?tercerNota ?tercerAltura)
        =>
        (printout t "Valido el acorde"crlf)
)
;;Ordenar la triada primero por altura
;;luego por notas

;;Buscar cual es la tónica-> la de 0 semitonos.
;;Busca la dominante->4 semitonos con respecto a la tonalidad.
;;Buscar la pentatonica-> 7 semitonos

;;Si cumple lo anterior es que es un acorde mayor
;;Otra regla que haga lo mismo, pero para las inversiones.

;;Como programar la regla para las otras escalas
