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
MTXCMP      DB "VWXYZ0123456789ABCDEFGHIJKLMNOPQRSTU"
MTXOUT      DB "  | 1 | 2 | 3 | 4 | 5 | 6 |", 13, 10
            DB "1 | V | W | X | Y | Z | 0 |", 13, 10
            DB "2 | 1 | 2 | 3 | 4 | 5 | 6 |", 13, 10
            DB "3 | 7 | 8 | 9 | A | B | C |", 13, 10
            DB "4 | D | E | F | G | H | I |", 13, 10
            DB "5 | J | K | L | M | N | O |", 13, 10
            DB "6 | P | Q | R | S | T | U |", 13, 10, "$"
TEMP        DB "PRUEBA"
;CLR_PANT    DB 1BH,"[2","J$"

INICIO PROC



INICIO ENDP

POLICODE PROC FAR

POLICODE ENDP

CODIGO ENDS
END INICIO
