
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
        (slot  nombre)
        (slot altura)
)

(deftemplate nota
        (slot nombre)
        (slot  altura)
        (slot sistemaTonal)
)

(deftemplate circuloQuintas
        (slot nombre);;falta definir props
)


;;===================== Regla Inicio ==========================
(defrule main

        =>
        (assert (nodoActual 0))
)

(defrule obtenerNotacion
        (nodoActual 0)
        =>
        (load-facts "intervalo.dat")
        (printout t crlf "Sistema Experto" crlf crlf
                         "Indique el sistema de notacion que prefiere:" crlf
                         "-Digite 1 para Italiana" crlf
                         "-Digite 2 para Inglesa" crlf
                         "-Mi opcion elegida es: "
        )
        (bind ?tipoNotacion (read))
        (assert(notacionSeleccionada ?tipoNotacion))
)

(defrule esNotacionItaliana
        (notacionSeleccionada 1)
        =>
        (assert(nodoActual 1))

)

(defrule esNotacionInglesa
        (notacionSeleccionada 2)
        =>
        (assert(nodoActual 2))

)

(defrule esNotacionInvalida
        (notacionSeleccionada ?notacion)
        (test (not (eq ?notacion 1)))
        (test (not (eq ?notacion 2)))
        =>
        (assert(nodoActual -1))

)

(defrule cargaItaliana
        (nodoActual 1)
        ?indice <- (nodoActual 1)
        =>
        (load-facts "notacionItaliana.dat")
        (retract ?indice)
        (assert (nodoActual 3))
)

(defrule cargaInglesa
        (nodoActual 2)
        ?indice <- (nodoActual 2)
        =>
        (load-facts "notacionInglesa.dat")
        (retract ?indice)
        (assert (nodoActual 3))
)

(defrule errorNotacion
        (nodoActual -1)
        ?indice <- (nodoActual -1)
        =>
        (printout t "Error Notacion")
        (retract ?indice)
        (assert (nodoActual 0))
)

;;TONALIDAD
(defrule obtenerTipoTonalidad
        (nodoActual 3)
        ?indice <- (nodoActual 3)
        =>
        (printout t crlf "Indique como indicara la tonalidad:" crlf
                         "Digite 1 para nombre" crlf
                         "Digite 2 para numero y tipo de alteraciones" crlf
                         "Mi opcion elegida es: "
        )
        (bind ?tipoTonalidad (read))
        (assert(tonalidadSeleccionada ?tipoTonalidad))
        (retract ?indice)
)

(defrule esTonalidadPorNombre
        (tonalidadSeleccionada 1)
        =>
        (assert(nodoActual 4))
)

(defrule esTonalidadPorAlteraciones
        (tonalidadSeleccionada 2)
        =>
        (assert(nodoActual 5))
)

(defrule esTonalidadInvalida
        (tonalidadSeleccionada ?tonalidad)
        (test (not (eq ?tonalidad 1)))
        (test (not (eq ?tonalidad 2)))
        =>
        (assert(nodoActual -2))
)

(defrule errorTonalidad
        (nodoActual -2)
        ?indice <- (nodoActual -2)
        =>
        (printout t "Error Tonalidad")
        (retract ?indice)
        (assert (nodoActual 3))
)

;;Tonalidad Por Nombre
(defrule obtenerTonalidadPorNombre
        (nodoActual 4)
        ?indice <- (nodoActual 4)
        =>
        (printout t "Digite el nombre de la tonalidad:")
        (bind ?nombreTonalidad (read))
        (assert (tonalidad ?nombreTonalidad))
        (retract ?indice)
)

(defrule esTonalidadNombreValido
        (tonalidad ?tonalidadIngresada)
        (notacion (nombre ?tonalidadIngresada))
        =>
        (assert (nodoActual 6))
)

(defrule esTonalidadNombreInvalido
        (tonalidad ?tonalidadIngresada)
        (not (notacion (nombre ?tonalidadIngresada)))
        =>
        (printout t "ERROR NOMBRE TONALIDAD INVALIDO" crlf)
)


;;Tonalidad Alteraciones
(defrule obtenerTonalidadPorAlteraciones
        (nodoActual 5)
        ?indice <- (nodoActual 5)
        =>
        (printout t "Digite el numero de alteraciones, rango [0,7]:"crlf)
        (bind ?numeroAlteraciones (read))
        (printout t "Digite el tipo de alteracion:"crlf)
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
        (printout t "ERROR NUMERO INVALIDO" crlf)
)
;;Acorde pedir la triada
(defrule obtenerAcorde
        (nodoActual 6)
        ?indice <- (nodoActual 6)
        =>
        (printout t "Digite la primer nota: "
        );;;validar la forma de ingresar datos
        (bind ?primerNota (read))
        (printout t "Digite la primera altura: "
        );;;validar la forma de ingresar datos
        (bind ?primerAltura (read))
        (printout t "Digite la segunda nota: "
        );;;validar la forma de ingresar datos
        (bind ?segundaNota (read))
        (printout t "Digite la segunda altura: "
        );;;validar la forma de ingresar datos
        (bind ?segundaAltura (read))
        (printout t "Digite la tercer nota: "
        );;;validar la forma de ingresar datos
        (bind ?tercerNota (read))
        (printout t "Digite la tercer altura: "
        );;;validar la forma de ingresar datos
        (bind ?tercerAltura (read))


        (assert (acorde ?primerNota ?primerAltura ?segundaNota ?segundaAltura ?tercerNota ?tercerAltura))
        (retract ?indice)
        (assert(nodoActual 7))
)

(defrule ordenaAcordePorAlturaPar1
        (nodoActual 7)
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
        ;;;(retract ?indice)borrar nodo
        ;;(assert (nodoActual 7))
)
;;Ordenar la triada primero por altura
;;luego por notas

;;Buscar cual es la tónica-> la de 0 semitonos.
;;Busca la dominante->4 semitonos con respecto a la tonalidad.
;;Buscar la pentatonica-> 7 semitonos

;;Si cumple lo anterior es que es un acorde mayor
;;Otra regla que haga lo mismo, pero para las inversiones.

;;Como programar la regla para las otras escalas
