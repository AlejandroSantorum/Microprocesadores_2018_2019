;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 4 Sistemas Basados en Microprocesadores
;**************************************************************************
CODIGO SEGMENT
ASSUME CS: CODIGO

;VARIABLES GLOBALES
;MODULE      DB 6
MTXCMP      DB "VWXYZ0123456789ABCDEFGHIJKLMNOPQRSTU"
TEMP        DB "PRUEBA", 13
TEMPC       DB "61 63 66 42 35 35", 13
CODED       DB 64*3 DUP(?), '$'
DECODED     DB 64 DUP(?), '$'
;CLR_PANT    DB 1BH,"[2","J$"

INICIO PROC

    MOV AX, CS
    MOV DS, AX
    MOV DX, OFFSET TEMP
    CALL POLICODE
    MOV DX, OFFSET TEMPC
    CALL POLIDECODE
    ; FIN DEL PROGRAMA
    MOV AX, 4C00H
    INT 21H

INICIO ENDP

;___________________________________
;  ENTRADA : AL CARACTER A CODIFICAR
;  SALIDA  : AX CARACTER CODIFICADO
;___________________________________
POLICHAR PROC FAR
    PUSH BX CX
    MOV AH, 0
    MOV BX, -1
    MOV CL, 6

    SIGUECOD:
    INC BX
    CMP AL, MTXCMP[BX]
    JNE SIGUECOD

    MOV AX, BX
    DIV CL
    ADD AX, 3131H

    POP CX BX
    RET
POLICHAR ENDP

;_____________________________________________________
;  ENTRADA : DS:DX DIRECCIÓN DE LA STRING A CODIFICAR
;  SALIDA  : NINGUNA.
;_____________________________________________________
POLICODE PROC FAR
    PUSH AX BX DX BP SI
    MOV BP, DX
    MOV SI, 0
    MOV BX, 0

    BUCLECOD:
    MOV AL, DS:[BP][SI]
    CALL POLICHAR
    MOV WORD PTR CODED[BX], AX
    INC BX
    INC BX
    MOV CODED[BX], ' '
    INC BX
    INC SI
    CMP BYTE PTR DS:[BP][SI], 13
    JNE BUCLECOD

    MOV CODED[BX-1], 10
    MOV CODED[BX], '$'
    MOV AH, 9H
    MOV DX, OFFSET CODED ; LEA DX, CODED
    INT 21H

    POP SI BP DX BX AX
    RET
POLICODE ENDP

;___________________________________
;  ENTRADA : AX CARACTER A DECODIFICAR
;  SALIDA  : AL CARACTER DECODIFICADO
;___________________________________
DECODECHAR PROC FAR
    PUSH BX

    MOV BX, 0
    SUB AX, 3131H

    ADD BL, AH
    MOV AH, 0
    ADD BX, AX ; BX = 6*AL + AX
    ADD BX, AX
    ADD BX, AX
    ADD BX, AX
    ADD BX, AX
    ADD BX, AX

    MOV AH, 0
    MOV AL, MTXCMP[BX]
    POP BX
    RET
DECODECHAR ENDP

;_____________________________________________________
;  ENTRADA : DS:DX DIRECCIÓN DE LA STRING A CODIFICAR
;  SALIDA  : NINGUNA.
;_____________________________________________________
POLIDECODE PROC FAR
    PUSH AX BX DX BP SI
    MOV BP, DX
    MOV SI, 0
    MOV BX, 0

    BUCLEDECOD:
    MOV AX, DS:[BP][SI]
    CALL DECODECHAR
    MOV DECODED[BX], AL
    INC BX
    ADD SI, 3
    CMP BYTE PTR DS:[BP][SI-1], 13
    JNE BUCLEDECOD

    MOV DECODED[BX], 10
    MOV DECODED[BX+1], '$'
    MOV AH, 9H
    MOV DX, OFFSET DECODED ; LEA DX, CODED
    INT 21H

    POP SI BP DX BX AX
    RET
POLIDECODE ENDP

CODIGO ENDS
END INICIO
