;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 2 Sistemas Basados en Microprocesadores
;**************************************************************************
;**************************************************************************
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
    MATRIZ DB 127, -3, 2, 3, 127 ,5, 2, 3, 127;
    SALIDA DB 6 DUP(32), 13, 10, '$'
    NUMERO DB 4 DUP(0)
    ERRORMSG DB "Error: Overflow", 13, 10, '$'
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
MOV CX, 0
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA
MOV AL, MATRIZ[0]
MOV AH, MATRIZ[4]
MOV BL, MATRIZ[8]
CALL IMUL3
JC OVERFLOW
ADC CX, AX

MOV AL, MATRIZ[1]
MOV AH, MATRIZ[5]
MOV BL, MATRIZ[6]
CALL IMUL3
JC OVERFLOW
ADC CX, AX

MOV AL, MATRIZ[2]
MOV AH, MATRIZ[3]
MOV BL, MATRIZ[7]
CALL IMUL3
JC OVERFLOW
ADC CX, AX

MOV AL, MATRIZ[2]
MOV AH, MATRIZ[4]
MOV BL, MATRIZ[6]
CALL IMUL3
JC OVERFLOW
SBB CX, AX

MOV AL, MATRIZ[0]
MOV AH, MATRIZ[5]
MOV BL, MATRIZ[7]
CALL IMUL3
JC OVERFLOW
SBB CX, AX

MOV AL, MATRIZ[1]
MOV AH, MATRIZ[3]
MOV BL, MATRIZ[8]
CALL IMUL3
JC OVERFLOW
SBB CX, AX

CALL TOASCII

MOV DX, OFFSET SALIDA
MOV AH, 9
INT 21H
JMP FIN

OVERFLOW:
MOV DX, OFFSET ERRORMSG
MOV AH, 9
INT 21H

; FIN DEL PROGRAMA
FIN:
MOV AX, 4C00H
INT 21H
INICIO ENDP

;_______________________________________________________________
; SUBRUTINA PARA CALCULAR LA MULTIPLICACION CON SIGNO DE 3 NUMEROS
; ENTRADA = AL, AH, BL
; SALIDA AX=RESULTADO ; SE SOBREESCRIBE DX
; HACE SET DE CF A 1 SI OCURRE UN OVERFLOW
;_______________________________________________________________
IMUL3 PROC NEAR
    MOV BH, 0
    IMUL AH
    IMUL BX
    RET
IMUL3 ENDP

;_______________________________________________________________
; SUBRUTINA PARA TRANSFORMAR UN VALOR NUMERICO EN ASCII
; ENTRADA = CX
; SALIDA = TEXTO EN MEMORIA
;_______________________________________________________________
TOASCII PROC NEAR
    MOV AX, CX
    MOV DL, 10
    MOV BX, 5
    CMP AX, 0
    JNS IR
    MOV SALIDA[0], '-'
    NEG AX
    IR:
    IDIV DL
    ADD AH, 30H
    MOV SALIDA[BX], AH
    MOV AH, 0
    CMP AL, 0
    JE ENDF
    DEC BX
    JNE IR
    ENDF:
    RET
TOASCII ENDP

;_______________________________________________________________
; SUBRUTINA PARA TRANSFORMAR UN VALOR ASCII EN NUMERICO
; ENTRADA = TEXTO EN MEMORIA - VARIABLE NUMERO
; SALIDA = AX
;_______________________________________________________________
TONUM PROC NEAR
    MOV DL, 10
    MOV AX, NUMERO[1]
    SUB AX, 30H
    MUL DL
    ADD AX, NUMERO[2]
    SUB AX, 30H
    MUL DL
    ADD AX, NUMERO[3]
    SUB AX, 30H
    CMP NUMERO[0], '-'
    JNE ENDTONUM
    NEG AX
    ENDTONUM:
    RET
TONUM ENDP


; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
