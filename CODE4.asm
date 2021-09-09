;HUGO MARIO RODRIGUEZ MENDOZA
;2420191008
        .MODEL  SMALL
        ORG     100H
        .DATA
ENTRADA LABEL   BYTE
MAXNLEN DB      4
ENTRLEN DB      ?
ENTRFLD DB      5   DUP(' ')
MSJMIN  DB      'Ingrese un valor minimo: ', '$'
MSJMAX  DB      'Ingrese un valor maximo: ', '$'
MIN     DB      ?               
MAX     DB      ?
COL     DB      00              
ROW     DB      00
MODE    DB      ?
VAR_CX  DW      ?
CIEN    DB      100
DIEZ    DB      10
;               Procedimiento principal:
;               ------------------------
        .CODE
MAIN    PROC    NEAR
        CALL    C10CLR
        MOV     ROW,00
        MOV     COL,00
        CALL    D10SET
        CALL    B10MSJ
        CALL    TECLAIN
        CALL    CICLO
        LEA     SI,ENTRFLD
        CALL    CONVERS
        CALL    COMPARA
        CALL    CICLO
        DEC     VAR_CX
        LEA     SI,ENTRFLD
        MOV     AH,00
        MOV     AL,[SI]
        CALL    PRESUMA
        MOV     MIN,AL
        MOV     ROW,02
        MOV     COL,00
        CALL    D10SET
        CALL    B10MSJ2
        CALL    TECLAIN
        CALL    CICLO
        LEA     SI,ENTRFLD
        CALL    CONVERS
        CALL    COMPARA
        CALL    CICLO
        DEC     VAR_CX
        LEA     SI,ENTRFLD
        MOV     AH,00
        MOV     AL,[SI]
        CALL    PRESUMA
        MOV     MAX,AL
        MOV     ROW,04
        MOV     COL,24
A20:
        CALL    D10SET
        CALL    E10DISP
        MOV     DL,MAX
        CMP     MIN,DL          
        JE      A30             
        INC     MIN             
        ADD     COL,02          
        CMP     COL,56          
        JNE     A20             
        INC     ROW             
        MOV     COL,24          
        JMP     A20             
A30:
        CALL    F10READ
        CALL    G10MODE
        MOV     AX,4C00H        
        INT     21H
MAIN    ENDP
;               Limpia la pantalla y crea una ventana
;               -------------------------------------
C10CLR  PROC    NEAR
        MOV     AH,08H          
        INT     10H
        MOV     BH,AH
        MOV     AX,0600H
        MOV     CX,0000
        MOV     DX,184FH
        INT     10H
        MOV     AX,0610H        
        MOV     BH,23H          
        MOV     CX,0418H        
        MOV     DX,1336H        
        INT     10H
        RET
C10CLR  ENDP
;               Coloca el cursor en el renglon y columna:
;               -----------------------------------------
D10SET  PROC    NEAR            
        MOV     AH,02H
        MOV     BH,00
        MOV     DH,ROW          
        MOV     DL,COL          
        INT     10H
        RET
D10SET  ENDP
;               Despliega caracteres ASCII:
;               ---------------------------
E10DISP PROC    NEAR
        MOV     AH,0AH          
        MOV     AL,MIN          
        MOV     BH,00
        MOV     CX,01
        INT     10H
        RET
E10DISP ENDP
;               Obliga a detenerse, obtiene un caracter del teclado
;               ---------------------------------------------------
F10READ PROC    NEAR
        MOV     AH,10H
        INT     16H
        RET
F10READ ENDP
;               Restaura el modo de video original
;               ----------------------------------
G10MODE PROC    NEAR
        MOV     AH,00H
        MOV     AL,MODE
        INT     10H
        RET
G10MODE ENDP
;               Pide el rango minimo
;               --------------------
B10MSJ  PROC    NEAR
        MOV     AH,09H          
        LEA     DX,MSJMIN
        INT     21H
        RET
B10MSJ  ENDP
;               Pide el rango minimo
;               --------------------
B10MSJ2 PROC    NEAR
        MOV     AH,09H          
        LEA     DX,MSJMAX
        INT     21H
        RET
B10MSJ2 ENDP
;               Entrada por teclado
;               -------------------
TECLAIN PROC    NEAR
        MOV     AH,0AH                       
        LEA     DX,ENTRADA          
        INT     21H
        RET
TECLAIN ENDP
;               VAR_CX
;               ------
CICLO   PROC    NEAR
        MOV     BH,00
        MOV     BL,ENTRLEN
        MOV     VAR_CX,BX
        RET
CICLO   ENDP
;               Conversion de los rangos
;               ------------------------
CONVERS PROC    NEAR
        MOV     AH,00
        MOV     AL,[SI]
        SUB     AX,30H
        MOV     [SI],AL
        INC     SI
        MOV     CX,VAR_CX
        DEC     VAR_CX
        LOOP    CONVERS
        RET
CONVERS ENDP
;               Comparaciones
;               -------------
COMPARA PROC    NEAR
        CMP     ENTRLEN,03
        JE      3CIFRAS
        CMP     ENTRLEN,02
        JE      2CIFRAS
        CMP     ENTRLEN,01
        JB      A30
        RET
COMPARA ENDP
;               Multiplicacion 2 cifras
;               -----------------------
2CIFRAS PROC    NEAR
        LEA     SI,ENTRFLD     
        MOV     AH,00
        MOV     AL,[SI]
        MUL     DIEZ
        MOV     [SI],AL     
        RET
2CIFRAS ENDP
;               Multiplicacion 2 cifras
;               -----------------------
CIFRA2  PROC    NEAR
        INC     SI     
        MOV     AH,00
        MOV     AL,[SI]
        MUL     DIEZ
        MOV     [SI],AL     
        RET
CIFRA2  ENDP
;               Multiplicacion 3 cifras
;               -----------------------
3CIFRAS PROC    NEAR
        LEA     SI,ENTRFLD
        MOV     AH,00
        MOV     AL,[SI]
        MUL     CIEN
        MOV     [SI],AL
        JMP     CIFRA2
        RET
3CIFRAS ENDP
;               Presuma
;               -------
PRESUMA PROC    NEAR
        CMP     ENTRLEN,1
        JNE     SUMA
        RET
PRESUMA ENDP
;               Suma cifras
;               -----------
SUMA    PROC    NEAR
        INC     SI
        ADD     AL,[SI]
        MOV     CX,VAR_CX
        DEC     VAR_CX
        LOOP    SUMA
        RET
SUMA    ENDP
        END     MAIN