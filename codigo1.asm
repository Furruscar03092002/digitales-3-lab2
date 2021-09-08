;HUGO MARIO RODRIGUEZ MENDOZA
;2420191008
TITLE       P10BIOAS
            .MODEL SMALL
            
            ORG     100H
;BEGIN:      JMP     SHORT MAIN
            .DATA
CTR         DB      30H         ;SE INICIALIZA LA VARIABLE EN 30H YA QUE ES EL PRIMER
                                ;CARACTER ASCII A IMPRIMIR  
COL         DB      24          ;SE INICIA DESDE LA COLUMNA NUMERO 24
ROW         DB      04          ;SE INICIA LA VARIABLE EN 04 YA QUE SERIA EL VALOR QUE TOMA
                                ;COMO FILA
MODE        DB      ? 
        
;PROCEDIMIENTO PRINCIPAL
            .CODE
            MOV     AX,@data
            MOV     DS,AX
            mov     ES,AX
           
MAIN        PROC    NEAR
            CALL    B10MODE
            CALL    C10CLR
A20:
            CALL    D10SET
            CALL    E10DISP
            
            CMP     CTR,39H ;COMPARA EL VALOR DE CTR CON 39H EL CUAL ES EL CARACTER 9
                            ;SI ES IGUAL ESTE SALTARA A LA ETIQUETA A21 PARA QUE PASE A LA
            JE      A21     ;SIGUIENTE FILA.
  
            
            
            INC     CTR     ;SE INCREMENTA EL VALOR DE CTR PARA QUE VAYA CAMBIANDO AL
                            ;CODIGO ASCII 
            ADD     COL,02  ;este es el espacio que hay entre cada caracter
            CMP     COL,56  ;SE VAN AUMENTANDO LAS COLUMNAS CON LA LETRA Y EL ESPACIADO
                            ;CUANDO LLEGUE A 56 QUE SERIA LOS 10 CARACTERES ASCII SE HACE
                            ;LA COMPARACION SI LLEGO AL VALOR PEDIDO
            JNE     A20     ;REPITE EL CICLO SI SE CUMPLE LA COMPARACION, SI NO ESTE
                            ;CONTINUARA A LA ETIQUETA 21
A21:        
            MOV     CTR,30H ;   
            INC     ROW     ;INCREMENTA EN 1 LA FILA 
            MOV     COL,24  ;se reseteo la variable 
            CMP     ROW,0EH ;SE COMPARA EL VALOR QUE TIENE FILA, SI ESTE ALCANZA HASTA
                            ;10 QUE ES EL NUMERO DE FILAS QUE SE NECESITAN, SI SE LLEGA
            JE      A30     ;ESTE SALTARA A LA ETIQUETA A30 QUE ES PARA SALIR DEL DOS

            JMP    A20
A30:
            CALL    P10READ
            CALL    G10MODE
            MOV     AX,4C00H
            INT     21H
MAIN        ENDP
;OBTENER Y DESIGNAR EL MODO DE VIDEO
B10MODE     PROC    NEAR
            MOV     AH,0FH
            INT     10H
            MOV     MODE,AL
            MOV     AH,00H
            MOV     AL,03
            INT     10H
            RET
B10MODE     ENDP
;LIMPIA LA PANTALLA Y CREA UNA VENTANA
C10CLR      PROC    NEAR
            MOV     AH,08H
            INT     10H
            MOV     BH,AH
            MOV     AX,0600H
            MOV     CX,0000
            MOV     DX,184FH
            INT     10H
            MOV     AX,0610H
            MOV     BH,24H ;en este el 2 cambia el color del fondo
                           ; y el 4 cambio el color de la letra
            MOV     CX,0418H
            MOV     DX,0D2BH
            INT     10H
            RET
C10CLR      ENDP
;COLOCA EL CURSOR EN EL RENGLON Y COLUMNA
D10SET      PROC    NEAR
            MOV     AH,02H
            MOV     BH,00
            MOV     DH,ROW
            MOV     DL,COL
            INT     10H
            RET
D10SET      ENDP
;DESPLIEGA CARACTERES ASCII
E10DISP     PROC    NEAR
            MOV     AH,0AH
            MOV     AL,CTR
            MOV     BH,00
            MOV     CX,01
            INT     10H
            RET
E10DISP     ENDP
;OBLIGA DETENRSE, OBTIENE UN CARACTER DEL TECLADO
P10READ     PROC    NEAR
            MOV     AH,10H
            INT     16H
            RET
P10READ     ENDP
;RESTAURA EL MODO VIDEO ORIGINAL
G10MODE     PROC    NEAR
            MOV     AH,00H
            MOV     AL,MODE
            INT     10H
            RET
G10MODE     ENDP
            END     MAIN
     