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
PUBLIC _decodeBarCode
ASSUME CS: PRAC3A

_computeControlDigit PROC FAR
    PUSH BP
    MOV BP, SP

	; PRESERVANDO VALORES DE LOS REGISTROS
    PUSH DS
    PUSH BX
    PUSH CX

    MOV BX, [BP+6]
    MOV DS, [BP+8]

	; SUMANDO LOS NUMEROS DE POSICIONES IMPARES
    MOV AX, 0
    ADD AL, [BX]
    ADD AL, 2[BX]
    ADD AL, 4[BX]
    ADD AL, 6[BX]
    ADD AL, 8[BX]
    ADD AL, 10[BX]
    SUB AX, 120H

	; MULTIPLICANDO POR 3 LOS NUMEROS DE POSICIONES
	; PARES Y SUMANDOLOS A LO ANTERIOR
    ADD AL, 1[BX]
    ADD AL, 1[BX]
    ADD AL, 1[BX]
    SUB AX, 90H

    ADD AL, 3[BX]
    ADD AL, 3[BX]
    ADD AL, 3[BX]
    SUB AX, 90H

    ADD AL, 5[BX]
    ADD AL, 5[BX]
    ADD AL, 5[BX]
    SUB AX, 90H

    ADD AL, 7[BX]
    ADD AL, 7[BX]
    ADD AL, 7[BX]
    SUB AX, 90H

    ADD AL, 9[BX]
    ADD AL, 9[BX]
    ADD AL, 9[BX]
    SUB AX, 90H

    ADD AL, 11[BX]
    ADD AL, 11[BX]
    ADD AL, 11[BX]
    SUB AX, 90H

	; DIVIDIMOS AX POR 10
    PUSH DX
    MOV CX, 10
	DIV CX

    MOV AX, DX
	; SI AX ERA UN MULTIPLO DE 10, ENTONCES YA
	; TENEMOS UN 0 EN AX (EL DIGITO DE CONTROL)
	CMP AX, 0
	JE FIN
	; POR EL CONTRARIO, TENEMOS QUE CALCULAR
	; 10 - EL RESTO DE LA DIVISION Y GUARDARLO
	; EN AX
    SUB AX, 10
    NEG AX

    ADD AX, 30H

	FIN	:
    POP DX
    POP CX
    POP BX
    POP DS
    POP BP
    RET
_computeControlDigit ENDP

_decodeBarCode PROC FAR
    PUSH BP
    MOV BP, SP

; PRESERVANDO VALORES DE LOS REGISTROS
    PUSH DS
    PUSH BX

    MOV BX, 6[BP]
    MOV DS, 8[BP] ; COLOCAMOS EL SEGEMENTO EN LA DIRECCION DEL BARCODE

    PUSH DI
    PUSH CX
    MOV CX, 3 ; LONGITUD CODIGO PAIS
    CALL TONUM ; OBTENEMOS EL VALOR NUMERICO DEL CODIGO DE PAIS

    MOV BX, 10[BP] ; MOVEMOS EL DIRECCIONAMIENTO DE DATOS A LA VARIABLE
    MOV DS, 12[BP]

    MOV [BX], AX ; GUARDAMOS LA VARIABLE EN MEMORIA

    MOV BX, 6[BP]
    MOV DS, 8[BP]
    ADD BX, 3 ; SUMAR OFFSET DE TODO LO YA COPIADO
    MOV CX, 4 ; LONGITUD CODIGO DE EMPRESA
    CALL TONUM

    MOV BX, 14[BP]
    MOV DS, 16[BP]

    MOV [BX], AX

    MOV BX, 6[BP]
    MOV DS, 8[BP]
    ADD BX, 7 ; SUMAR OFFSET DE LO YA COPIADO
    ADD CX, 5 ; LONGITUD CODIGO PRODUCTO
    CALL TONUM

    MOV BX, 18[BP]
    MOV DS, 20[BP]

    MOV [BX], AX
    MOV 2[BX], DX

    MOV BX, 6[BP]
    MOV DS, 8[BP]
    ADD BX, 12 ; SUMAR OFFSET DE LO YA COPIADO

    MOV AL, [BX]

    MOV BX, 22[BP]
    MOV DS, 24[BP]

    MOV [BX], AL

    POP CX
    POP DI
    POP BX
    POP DS
    POP BP
    RET
_decodeBarCode ENDP



;_______________________________________________________________
; SUBRUTINA PARA TRANSFORMAR UN VALOR ASCII EN A NUMERICO
; ENTRADA = CX - LONGITUD DEL NUMERO EN CARACTERES
; SALIDA = DX:AX
;_______________________________________________________________
TONUM PROC NEAR
    MOV AX, 0
    MOV DX, 0
    SIGUETONUM:
    MOV DI, 10
    MUL DI
    MOV DI, [BX]
    AND DI, 00FFH
    ADD AX, DI
    SUB AX, 30H
    INC BX
    DEC CX
    JNZ SIGUETONUM

    RET
TONUM ENDP

PRAC3A ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3a.asm
