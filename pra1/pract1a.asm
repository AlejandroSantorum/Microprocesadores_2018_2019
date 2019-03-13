;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 1 Sistemas Basados en Microprocesadores
;**************************************************************************
;**************************************************************************
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
;-- rellenar con los datos solicitados
DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
MOV AX, PILA
MOV SS, AX
MOV AX, EXTRA
MOV ES, AX
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA
;DIRECCIONAMIENTO INMEDIATO
MOV AX, 0015H
MOV BX, 00BBH
MOV CX, 3412H ;Vemos como cambian los registros en el td
;DIRECCIONAMIENTO POR REGISTRO
MOV DX, CX ;Se copia el registro cx al dx
;CAMBIO DE LA DIRECCION DE DS
MOV AX, 6553H
MOV DS, AX ;vemos como cambia el ds
;DIRECCIONAMIENTO DIRECTO
MOV BH, DS:[6H]
MOV BL, DS:[7H] ;se reseta bx a 00 por que ds:6 ds:7 es 0000
;MOV BX, [536H]

;CAMBIO DE LA DIRECCION DE DS
MOV AX, 5000H
MOV DS, AX ;vemos como cambia el ds
;DIRECCIONAMIENTO DIRECTO
MOV DS:[5H], CH ;escribimos el 34 de haber cargado cx antes en memoria

;DIRECCIONAMIENTO INDIRECTO POR REGISTRO
MOV AX, [SI]
;DIRECCIONAMIENTO RELATIVO A BASE
MOV BX, 10[BP]
; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
