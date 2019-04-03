;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 3 Sistemas Basados en Microprocesadores
;**************************************************************************
;**************************************************************************
PRAC3B SEGMENT BYTE PUBLIC 'CODE'
PUBLIC _createBarCode
ASSUME CS: PRAC3B

ASCIIOFFSET EQU 30H
RETSZ       EQU 14
PAISLEN     EQU 3
EMPRLEN     EQU 4
PRODLEN     EQU 5
SHRMASK     EQU 00FFH

_createBarCode PROC FAR
    PUSH BP
    MOV BP, SP

	; PRESERVANDO VALORES DE LOS REGISTROS
    PUSH DS BX CX DX DI AX

    LDS BX, [BP+16] ;Colocamos el segmento al comienzo de la cadena de salida

    MOV DI, RETSZ
    CALL INITSTR

    MOV AX, [BP+6] ;Guardamos el codigo de pais en AX
    MOV DX, 0
    MOV DI, PAISLEN
    CALL TOASCII

    ADD BX, DI
    MOV AX, [BP+8]
    MOV DI, EMPRLEN
    CALL TOASCII

    ADD BX, DI
    MOV AX, [BP+10]
    MOV DX, [BP+12]
    MOV DI, PRODLEN
    CALL TOASCII

    ADD BX, DI
    MOV AX, [BP+14]
    AND AX, SHRMASK
    MOV DX, 0
    MOV DI, 1
    CALL TOASCII

	FIN	:
    POP AX DI DX CX BX DS
    POP BP
    RET
_createBarCode ENDP

;_______________________________________________________________
; SUBRUTINA PARA TRANSFORMAR UN VALOR NUMERICO EN ASCII
; ENTRADA = AX - NUMERO
;           BX - OFFSET DE LA MEMORIA
;           DI - TAMAÑO DE LA CADENA
; SALIDA = TEXTO EN MEMORIA
;_______________________________________________________________
TOASCII PROC FAR
    PUSH CX
    PUSH DX
    PUSH AX
    PUSH DI
    MOV CX, 10 ; HAGO SET DEL DIVISOR
    DIVIDE:
    DIV CX ; DIVIDE DX:AX ENTRE 10
    ADD DX, ASCIIOFFSET ; TRANSFORMAMOS EL VALOR NUMERICO DE DX EN SU ASCII
    MOV DS:[BX][DI-1], DL ; GUARDAMOS EL CARACTER EN MEMORIA
    MOV DX, 0 ; VOLVEMOS A PONER DX A 0
    CMP AX, 0 ; SI EL COCIENTE ES 0 TERMINAMOS
    JE ENDF
    DEC DI ; DECREMENTAMOS EL CONTADOR
    JNE DIVIDE
    ENDF:
    POP DI
    POP AX
    POP DX
    POP CX
    RET
TOASCII ENDP

;_______________________________________________________________
; SUBRUTINA PARA INICIALIZAR UNA STRING EN MEMORIA
; ENTRADA = BX - OFFSET DE LA MEMORIA
;           DI - TAMAÑO DE LA CADENA
; SALIDA = TEXTO EN MEMORIA
;_______________________________________________________________
INITSTR PROC FAR
    PUSH BX
    PUSH DI
    DEC DI
    MOV BYTE PTR [DI][BX], 0
    SIGUEINIT:
    MOV BYTE PTR [BX], '0'
    INC BX
    DEC DI
    JNE SIGUEINIT
    POP DI
    POP BX
    RET
INITSTR ENDP

PRAC3B ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3b.asm
