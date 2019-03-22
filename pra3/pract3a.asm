PRAC3A SEGMENT BYTE PUBLIC 'CODE'
PUBLIC _computeControlDigit
ASSUME CS: PRAC3A

_computeControlDigit PROC FAR
    PUSH BP
    MOV BP, SP

    PUSH DS, BX, AX

    MOV BX, [BP+6]
    MOV DS, [BP+8]

    MOV AX, 0
    ADD AX, [BX]
    ADD AX, 2[BX]
    ADD AX, 4[BX]
    ADD AX, 6[BX]
    ADD AX, 8[BX]
    ADD AX, 10[BX]

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

    POP AX, BX, DS, BP
    RET
_computeControlDigit ENDP

PRAC3A ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3a.asm
