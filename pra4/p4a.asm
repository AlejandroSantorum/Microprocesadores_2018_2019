;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 4 Sistemas Basados en Microprocesadores
;**************************************************************************
EXTRA SEGMENT

EXTRA ENDS

CODIGO SEGMENT
ASSUME CS: CODIGO, ES:EXTRA
ORG 256
INICIO:
JMP INSTALADOR
;VARIABLES GLOBALES
;MODULE      DB 6
MTXCMP       DB "VWXYZ0123456789ABCDEFGHIJKLMNOPQRSTU"
CODED        DB 64*3 DUP(?), '$'
DECODED      DB 64 DUP(?), '$'
DRIVERSTAT   DB "DRIVER: $"
INSTALSTAT   DB "INSTALADO", 10, 13, "$"
UNINSTALSTAT DB "DESINSTALADO", 10, 13, "$"
INFORM       DB "NUMERO DE PAREJA: 16", 10, 13
             DB "PAREJA: RAFAEL SANCHEZ, ALEJANDRO SANTORUM", 10, 13
             DB "PARA INSTALAR EJECUTA CON /i Y PARA DESINSTALAR CON /d$"
;CLR_PANT    DB 1BH,"[2","J$"

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
    CMP BYTE PTR DS:[BP][SI], '$'
    JNE BUCLECOD

    ;MOV CODED[BX-1], 10
    ;MOV CODED[BX], '$'
    MOV AH, 9H
    LEA DX, CODED
    ;MOV DX, OFFSET CODED ; LEA DX, CODED
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
    CMP BYTE PTR DS:[BP][SI-1], '$'
    JNE BUCLEDECOD

    ;MOV DECODED[BX], 10
    ;MOV DECODED[BX+1], '$'
    MOV AH, 9H
    LEA DX, DECODED
    ;MOV DX, OFFSET DECODED ; LEA DX, CODED
    INT 21H

    POP SI BP DX BX AX
    RET
POLIDECODE ENDP

;_____________________________________________________
;   PROGRAMA PRINCIPAL DE LA RUTINA DE SERVICIO
;
;   ENTRADA: AH - ELIGE CODIFICACIÓN O DECODIFICACIÓN
;            DX - CADENA A CODIFICAR O DECODIFICAR
;_____________________________________________________
PROGRAMA PROC
    CMP AH, 10H
    JE CODIFICA
    CMP AH, 11H
    JNE FIN
    CALL POLIDECODE
    CODIFICA:
    CALL POLICODE
    FIN:
    IRET
PROGRAMA ENDP

INSTALADOR PROC

    CMP BYTE PTR DS:[80H], 0 ; COMPROBACIÓN PARAMETROS DE ENTRADA
    JE AYUDA
    MOV BL, DS:[83H]
    CMP BL, 'i'
    JE INSTALA
    CMP BL, 'd'
    JE DESINSTALA

    AYUDA:
    MOV AH, 9H
    MOV DX, OFFSET DRIVERSTAT
    INT 21H

    MOV BX, 0
    MOV ES, BX

    CMP WORD PTR ES:[57H*4+2], 0
    JNE INSTALLED
    MOV DX, OFFSET UNINSTALSTAT
    INT 21H
    JMP ELS
    INSTALLED:
    MOV DX, OFFSET INSTALSTAT
    INT 21H
    ELS:
    MOV DX, OFFSET INFORM
    INT 21H

    JMP FIN_DENSINSTALA

    INSTALA:
    MOV AX, 0
    MOV ES, AX

    CMP WORD PTR ES:[57H*4+2], 0 ; COMPRUEBA SI ESTÁ LIBRE
    JNE FIN_INSTALA

    MOV AX, OFFSET PROGRAMA
    MOV BX, CS
    CLI                 ; INSTALADOR
        MOV ES:[57H*4], AX  ; OFFSET MAIN
        MOV ES:[57H*4+2], BX ; OFFSET SEGMENTO DE CODIGO
    STI

    FIN_INSTALA:
    MOV DX, OFFSET INSTALADOR
    INT 27H

    DESINSTALA:
    MOV CX, 0
    MOV DS, CX

    CMP WORD PTR DS:[57H*4+2], 0       ; COMPRUEBA QUE HAY ALGO INSTALADO
    JE FIN_DENSINSTALA

    MOV ES, DS:[57H*4+2]
    MOV BX, ES:[2CH]
    ; FALTA COMPROBAR QUE EL PROGRAMA A DESINSTALAR ES EL QUE TOCA
    MOV AH, 49H
    INT 21H ;LIBERA SEGMENTO RSI
    MOV ES, BX
    INT 21H ; LIBERA SEGMENTO DE VARIABLES DE ENTORNO
    CLI
        MOV WORD PTR DS:[57H*4], 0
        MOV WORD PTR DS:[57H*4+2], 0
    STI
    FIN_DENSINSTALA:
    MOV AX, 4C00H
    INT 21H
INSTALADOR ENDP

CODIGO ENDS
END INICIO