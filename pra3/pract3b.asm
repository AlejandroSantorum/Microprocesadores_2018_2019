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

_createBarCode PROC FAR
    PUSH BP
    MOV BP, SP

	; PRESERVANDO VALORES DE LOS REGISTROS
    PUSH DS
    PUSH BX
    PUSH CX

    MOV BX, [BP+6]
    MOV DS, [BP+8]


	FIN	:
    POP DX
    POP CX
    POP BX
    POP DS
    POP BP
    RET
_createBarCode ENDP

PRAC3B ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3b.asm
