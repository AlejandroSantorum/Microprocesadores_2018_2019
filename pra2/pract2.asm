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
    MATRIZ     DB 9 DUP(?)
    TEMP       DB ?
    ;MATRIZ     DB -16, 0, 0, 0, -16, 0, 0, 0, -16
    SALIDA     DB 10, 6 DUP(30H), 13, 10, '$'
    NUMERO     DB 4, 6 DUP(0)
    ASCIIMX    DB 10, 6 DUP(' '), "| 000 000 000 |", 13, 10,"|A| = | 000 000 000 | = 000000", 13, 10, 6 DUP (' '), "| 000 000 000 |$"
    ERRORMSG   DB "ERROR: EL VALOR INTRODUCIDO NO ES VALIDO. HAZLO DE NUEVO.", 13, 10, '$'
    REQUESTMSG DB 10, "INTRODUCE UN NUMERO EN EL INTERVALO [-16, 15]:", 13, 10, '$'

    CLR_PANT   DB 1BH,"[2","J$"
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
CALL LOADMX ; CARGA LA MATRIZ POR ENTRADA DE TECLADO

MOV AL, MATRIZ[0]
MOV AH, MATRIZ[4]
MOV BH, MATRIZ[8]
CALL IMUL3
ADC CX, AX

MOV AL, MATRIZ[1]
MOV AH, MATRIZ[5]
MOV BH, MATRIZ[6]
CALL IMUL3
ADC CX, AX

MOV AL, MATRIZ[2]
MOV AH, MATRIZ[3]
MOV BH, MATRIZ[7]
CALL IMUL3
ADC CX, AX

MOV AL, MATRIZ[2]
MOV AH, MATRIZ[4]
MOV BH, MATRIZ[6]
CALL IMUL3
SBB CX, AX

MOV AL, MATRIZ[0]
MOV AH, MATRIZ[5]
MOV BH, MATRIZ[7]
CALL IMUL3
SBB CX, AX

MOV AL, MATRIZ[1]
MOV AH, MATRIZ[3]
MOV BH, MATRIZ[8]
CALL IMUL3
SBB CX, AX

MOV BX, 5
MOV SI, OFFSET ASCIIMX
ADD SI, 48
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[0]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 9
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[1]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 13
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[2]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 17
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[3]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 32
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[4]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 36
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[5]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 40
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[6]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 64
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[7]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 68
CALL TOASCII

MOV BX, 3
MOV CH, MATRIZ[8]
MOV CL, 8
SAR CX, CL
MOV SI, OFFSET ASCIIMX
ADD SI, 72
CALL TOASCII

MOV DX, OFFSET ASCIIMX
MOV AH, 9
INT 21H

; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP

;_______________________________________________________________
; SUBRUTINA PARA CALCULAR LA MULTIPLICACION CON SIGNO DE 3 NUMEROS
; ENTRADA = AL, AH, BH
; SALIDA AX=RESULTADO ; SE SOBREESCRIBE DX
; HACE SET DE CF A 1 SI OCURRE UN OVERFLOW
;_______________________________________________________________
IMUL3 PROC NEAR
    MOV TEMP, CL
    MOV CL, 8
    SAR BX, CL
    IMUL AH
    IMUL BX
    MOV CL, TEMP
    RET
IMUL3 ENDP

;_______________________________________________________________
; SUBRUTINA PARA TRANSFORMAR UN VALOR NUMERICO EN ASCII
; ENTRADA = CX - NUMERO
;           SI - OFFSET DE LA MEMORIA
;           BX - TAMAÑO DE LA CADENA
; SALIDA = TEXTO EN MEMORIA
;_______________________________________________________________
TOASCII PROC NEAR
    MOV DX, 0
    MOV AX, CX ; GUARDO EL RESULTADO EN AX
    MOV CX, 10 ; HAGO SET DEL DIVISOR
    CMP AX, 0
    JNS DIVIDE ; COMPRUEBO SI ES NEGATIVO
    MOV DL, 2Dh
    MOV DS:[SI], DL ; SI LO ES GUARDO EL '-' EN MEMORIA
    MOV DL, 0
    NEG AX ; LE HAGO EL VALOR ABSOLUTO
    DIVIDE:
    DIV CX ; DIVIDE DX:AX ENTRE 10
    ADD DX, 30H ; TRANSFORMAMOS EL VALOR NUMERICO DE DX EN SU ASCII
    MOV DS:[SI][BX-1], DL ; GUARDAMOS EL CARACTER EN MEMORIA
    MOV DX, 0 ; VOLVEMOS A PONER DX A 0
    CMP AX, 0 ; SI EL COCIENTE ES 0 TERMINAMOS
    JE ENDF
    DEC BX ; DECREMENTAMOS EL CONTADOR
    JNE DIVIDE
    ENDF:
    RET
TOASCII ENDP

;_______________________________________________________________
; SUBRUTINA PARA TRANSFORMAR UN VALOR ASCII EN [-99,99] A NUMERICO
; ENTRADA = TEXTO EN MEMORIA - VARIABLE NUMERO
; SALIDA = AL
;_______________________________________________________________
TONUM PROC NEAR
    MOV AX, 0
    MOV DL, 10
    MOV DI, 3

    CMP NUMERO[2], '-'
    JE SIGUETONUM
    DEC DI

    SIGUETONUM:
    MUL DL
    ADD AL, NUMERO[DI]
    SUB AL, 30H
    INC DI
    CMP NUMERO[DI], 13
    JNE SIGUETONUM

    CMP NUMERO[2], '-'
    JNE ENDTONUM
    NEG AL
    ENDTONUM:
    RET
TONUM ENDP

;_______________________________________________________________
; SUBRUTINA PARA LEER 9 NUMEROS POR TECLADO
; ENTRADA = NINGUNA
; SALIDA = MATRIZ EN MEMORIA
;_______________________________________________________________
LOADMX PROC NEAR

    MOV BX, 0
    MOV AH, 9H
    MOV DX, OFFSET CLR_PANT
    INT 21H
    CICLO:
    MOV AH, 9H
    MOV DX, OFFSET REQUESTMSG
    INT 21H ; IMPRIME LA PETICION
    MOV AH, 0AH
    MOV DX, OFFSET NUMERO
    INT 21H ; OBTIENE EL NUMERO (EN ASCII) POR TECLADO

    CALL TONUM ; OBTENEMOS EN AL EL VALOR NUMÉRICO

    CMP AL, 15 ; COMPRUEBA QUE EL VALOR INTRODUCIDO ES VALIDO
    JG INVAL
    CMP AL, -16
    JL INVAL ; SI NO ES VALIDO VOLVEMOS A INTRODUCIRLO

    MOV MATRIZ[BX], AL ; ALMACENA EL NUMERO

    INC BX
    CMP BX, 9
    JNE CICLO ; VAMOS AL SIGUIENTE

    JMP FINLOAD ; TERMINAMOS

    INVAL:
    MOV AH, 9H
    MOV DX, OFFSET ERRORMSG
    INT 21H
    JMP CICLO

    FINLOAD:
    RET

LOADMX ENDP

; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
