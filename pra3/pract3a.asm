;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 3 Sistemas Basados en Microprocesadores
;**************************************************************************
;**************************************************************************
PRAC3A SEGMENT BYTE PUBLIC 'CODE'
PUBLIC _computeControlDigit
ASSUME CS: PRAC3A

_computeControlDigit PROC FAR
    PUSH BP
    MOV BP, SP
	
	; PRESERVANDO VALORES DE LOS REGISTROS
    PUSH DS, BX, AX
	
    MOV BX, [BP+6]
    MOV DS, [BP+8]
	
	; SUMANDO LOS NUMEROS DE POSICIONES IMPARES
    MOV AX, 0
    ADD AX, [BX]
    ADD AX, 2[BX]
    ADD AX, 4[BX]
    ADD AX, 6[BX]
    ADD AX, 8[BX]
    ADD AX, 10[BX]
	
	; MULTIPLICANDO POR 3 LOS NUMEROS DE POSICIONES
	; PARES Y SUMANDOLOS A LO ANTERIOR
    ADD AX, 1[BX]
    ADD AX, 1[BX]
    ADD AX, 1[BX]

    ADD AX, 3[BX]
    ADD AX, 3[BX]
    ADD AX, 3[BX]

    ADD AX, 5[BX]
    ADD AX, 5[BX]
    ADD AX, 5[BX]

    ADD AX, 7[BX]
    ADD AX, 7[BX]
    ADD AX, 7[BX]

    ADD AX, 9[BX]
    ADD AX, 9[BX]
    ADD AX, 9[BX]

    ADD AX, 11[BX]
    ADD AX, 11[BX]
    ADD AX, 11[BX]
	
	; DIVIDIMOS AX POR 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	SUB AX, 10
	
	; SI AX ERA UN MULTIPLO DE 10, ENTONCES YA
	; TENEMOS UN 0 EN AX (EL DIGITO DE CONTROL)
	CMP AX, 0
	JZ FIN:
	; POR EL CONTRARIO, TENEMOS QUE CALCULAR
	; 10 - EL RESTO DE LA DIVISION Y GUARDARLO
	; EN AX
	XCHG AX, BX ; ax <-> bx (swap)
	MOV AX, 10  ; ax <- 10
	SUB AX, BX  ; ax := 10 - (RESTO DIV /10)
	
	FIN					;;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    POP AX, BX, DS, BP ;;;; <== CREO QUE NO HAY QUE PRESERVAR AX, PORQUE AHÍ ES POR DONDE SE DEVUELVE EL DIGITO DE CONTROL
    RET					;;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
_computeControlDigit ENDP

PRAC3A ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3a.asm
