;**************************************************************************
;   Autores:
;       Rafael Sanchez Sanchez - rafael.sanchezs@estudiante.uam.es
;       Alejandro Santorum Varela - alejandro.santorum@estudiante.uam.es
;   Pareja: 16
;   Practica 4 Sistemas Basados en Microprocesadores
;**************************************************************************
DATOS SEGMENT
    INIC   DB "Por favor, introduzca un comando (cod, decod, quit):", 13, 10, "$"
    CODM   DB "Introduce cadena a codificar (MAYUSCULAS): $"
    DECODM DB "Introduce cadena a decodificar (codificacion Polibio): $"
    ERROR  DB 13,"Introduzca un comando valido.",13,10, "$"
    DECOD  DB "decod", 13
    COD    DB "cod", 13
    QUIT   DB "quit", 13
    INTRO  DB 64, 0, 64 DUP(?)
    LINEFD DB 13, 10, "$"
    NOTINS DB "EL DRIVER SE ENCUENTRA DESINSTALADO$"
DATOS ENDS

CODIGO SEGMENT
ASSUME CS: CODIGO, DS:DATOS
;___________________________________
; COMPARA DOS CADENAS
; ENTRADAS: DS:BX, DS:BP
; SALIDA:  ZF AS USUAL
;___________________________________
STRCMP PROC FAR
    PUSH DI AX
    MOV DI, 0

    WHILESTR:
    MOV AL, DS:[BX][DI]
    CMP DS:[BP][DI], AL
    JNE NOTSTR

    CMP AL, 13
    TEST AX, 0
    JE FINSTR

    INC DI
    JMP WHILESTR

    NOTSTR:
    OR DI, 1
    FINSTR:
    POP AX DI
    RET
STRCMP ENDP

GETS PROC FAR
    PUSH DX AX
    MOV AH, 0AH
    LEA DX, INTRO
    INT 21H
    POP AX DX
    RET
GETS ENDP

PRINTF PROC FAR
    PUSH AX
    MOV AH, 09H
    INT 21H
    POP AX
    RET
PRINTF ENDP

PARSE$ PROC FAR
    PUSH DI
    MOV DI, 0

    PARSE:
    CMP BYTE PTR DS:[BX][DI], 13
    JE FINPARSE
    INC DI
    JMP PARSE

    FINPARSE:
    MOV BYTE PTR DS:[BX][DI], '$'
    POP DI
    RET
PARSE$ ENDP

INICIO PROC
    MOV CX, 1
    MOV AX, DATOS
    MOV DS, AX

    MOV BX, 0
    MOV ES, BX
    CMP WORD PTR ES:[57H*4+2], 0
    JE NOTINSTALLED_

    JMP STARTL

    NOTINSTALLED_:
    JMP NOTINSTALLED

    TRYAGAIN:
    LEA DX, ERROR
    CALL PRINTF

    STARTL:
    LEA DX, INIC
    CALL PRINTF

    CALL GETS
    LEA BX, INTRO
    ADD BX, 2
    LEA BP, COD
    CALL STRCMP
    JE CODL

    LEA BP, DECOD
    CALL STRCMP
    JE DECODL

    LEA BP, QUIT
    CALL STRCMP
    JNE TRYAGAIN

    JMP FIN

    CODL:
    LEA DX, CODM
    CALL PRINTF

    CALL GETS
    LEA DX, LINEFD
    CALL PRINTF
    LEA BX, INTRO
    ADD BX, 2
    LEA BP, DECOD
    CALL STRCMP
    JE DECODL

    LEA BP, QUIT
    CALL STRCMP
    JE FIN

    CALL PARSE$
    MOV DX, BX
    MOV AH, 10H
    INT 57H

    LEA DX, LINEFD
    CALL PRINTF
    JMP CODL

    DECODL:
    LEA DX, DECODM
    CALL PRINTF

    CALL GETS
    LEA DX, LINEFD
    CALL PRINTF
    LEA BX, INTRO
    ADD BX, 2
    LEA BP, COD
    CALL STRCMP
    JE CODL

    LEA BP, QUIT
    CALL STRCMP
    JE FIN

    CALL PARSE$
    MOV DX, BX
    MOV AH, 11H
    INT 57H

    LEA DX, LINEFD
    CALL PRINTF
    JMP DECODL

    NOTINSTALLED:
    LEA DX, NOTINS
    CALL PRINTF

    FIN:
    MOV AX, 4C00H
    INT 21H
INICIO ENDP

CODIGO ENDS
END INICIO
