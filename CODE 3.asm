;HUGO MARIO RODRIGUEZ MENDOZA 
;2420191008
            .MODEL  SMALL               ;Define el tamano el codigo
            .STACK  64
;--------------------------------------------------
            .DATA                       ;Espacio de almacenamiento de datos
NAMEPAR     LABEL   BYTE
MAXNLEN     DB      15
NAMELEN     DB      ?
NAMEFLD     DB      15  DUP(' ')        ;Duplica en memoria 15 lo que esta dentro de las comillas     
PROMPT      DB      'PALABRA ',  '$'    ;SE PREGUNTA POR LA PALABRA QUE SE DESEA TECLEAR
CONTI       DB     'CONTINUAR?Y=YES,N=NO,' '$';SE PREGUNTA SI SE DESEA VOLVER A IMPRIMIR 
                                              ;ALGUNA PALABRA
OUTPUT      DB      ' ','$'                   ;LA SALIDA QUE IMPRIMIRA LA PALABRA TECLEADA
FILA        DB      12                        ;VARIABLE DE LA FILA
CONTROL     DB      ?                         ;CONTROL DE ITERACCIONES
COL         DB      40                        ;LA COLUMNA DEL CODIGO
;Guarda en memoria, el signo pesos es un delimitador
;--------------------------------------------------
            .CODE
BEGIN       PROC    FAR                 
            MOV     AX,@data
            MOV     DS,AX
            MOV     ES,AX
            CALL    Q10CLR
A20LOOP:
            MOV     DX,0000
            CALL    Q20CURS         
            CALL    B10PRMP
            CALL    D10INPT
            CALL    Q10CLR
           
            CMP     NAMELEN,00          
            JE      A30                 
            CALL    E10CODE
            CALL    Q20CURS
            CALL    ARROZ           ;SE LLAMA LA VARIABLE ARROZZ EN EL CUAL EXHIBE EL
                                    ;INDICADOR DE QUE SI SE DESEA CONTINUAR O NO
            
            CALL    D10INPT         ;INGRESA EL DATO QUE DIO EL USUARIO
            CMP     NAMEFLD,59H     ;SE COMPARA SI LO TECLEADO ES IGUAL A "Y" 
            JE      BEGIN           ;SI ES IGUAL SE DEVUELVE AL INICIO DEL CODIGO PARA
                                    ;VOLVER A EJECUTAR EL CODIGO
            CMP     NAMEFLD,4EH     ;SE COMPARA LO INGRESADO CON "N" 
            JE      A30             ;SI ES IGUAL SE SALE YA QUE EL USUARIO NO DESEA 
                                    ;CONTNUAR EN EL PORCESO Y ESTE SE SALE DEL DOS
           
            JMP     A20LOOP

            


A30:
            MOV     AX,4C00H
            INT     21H
BEGIN       ENDP
 
;----------------------EXHIBE INDICADOR----------------------------
ARROZ       PROC    NEAR
            MOV     AH,09H             
            LEA     DX,CONTI
            INT     21H
            RET
ARROZ       ENDP
;----------------------EXHIBE INDICADOR----------------------------
B10PRMP     PROC    NEAR            
            MOV     AH,09H             
            LEA     DX,PROMPT
            INT     21H
            RET
B10PRMP     ENDP
;                   Acepta entrada de nombre:
;--------------------------------------------------
D10INPT     PROC    NEAR
            MOV     AH,0AH                           
            LEA     DX,NAMEPAR          
            INT     21H
            RET
D10INPT     ENDP
;                   Fijar campana y delimitador '$':
;--------------------------------------------------
E10CODE     PROC    NEAR 
            MOV     DH,NAMELEN      ;SE REALIZA COMO EN EL PUNTO 2, EL COMPLEMENTO A2         
            SHR     DH,1             
            NEG     DH
            ADD     DH,FILA
            MOV     DL,COL          ;SE REALIZA EL VALOR EN EL QUE SE DEBERIA SITUAR 
                                    ;EL CURSOR
            CALL    Q20CURS         ;FIJA EL CURSOR EN LAS COORDENAS YA HECHAS CON LAS
                                    ;LINEAS DE CODIGO YA HECHA EN E10CODE
            LEA     SI,NAMEFLD      ;PASA LO DE NAMEFLD A SI
            CALL    Q10CLR          ;LIMPIA PANTALLA  
            MOV     BL,NAMELEN      ;PASA EL VECTOR DE NAMELEN A BL
            MOV     CONTROL,BL      ;PASA EL VECTOR DE BL A CONTROL
            INC     CONTROL         ;INCREMENTA CONTROL
            MOV     FILA,12         ;RECUERDA EL VALOR INICIAL DE FILA
PRUEBA:     

            INC     FILA            ;INCREMENTA FILA
            MOV     DH,NAMELEN      ;SE REALIZA EL COMPLEMENTO A2 PARA FIJAR 
                                    ;AUTOMATICAMENTE LA FILA DE INICIO      
            SHR     DH,1
            NEG     DH
            ADD     DH,FILA
           
            MOV     DL,COL          ;SE RECUERDA EL VALOR DE LA COLUMNA
            CALL    Q20CURS         ;FIJA EL CURSOR 
            
            MOV     AL,[SI]         ;PASA EL VALOR DEL VECTOR SI A AL
            MOV     OUTPUT,AL       ;PASA EL VECTOR DE AL A OUTPUT
            MOV     AH,09H          ;PROCEDIMIENTO PARA LA INTERRUPCION 21
            LEA     DX,OUTPUT       ;SE IMPRIME LO QUE SE ENCUENTRA EN OUTPUT
            
            INT     21H 

            INC     SI              ;INCREMENTE SI PARA PASAR AL SIGUIENTE CARACTER
            DEC     CONTROL         ;DECREMENTA CONTROL PARA IR DISMINUYENDO LA CANTIDAD DE
                                    ;DE ITERACCIONES
            MOV     CH,0            ;SE REDUCE CX PARA DISMINUIR LAS ITERACCIONES
            MOV     CL,CONTROL
            

            LOOP    PRUEBA          ;SE REPITE EL CICLO HASTA IMPRIMIR TODAS LAS PALABRAS
            
            
            
            
         
            
           
            RET
E10CODE     ENDP
;                   Centrar y exhibir nombre:
;--------------------------------------------------

;                   Despejar pantalla
;--------------------------------------------------
Q10CLR      PROC    NEAR
            MOV     AX,0600H
            MOV     BH,30
            MOV     CX,0000
            MOV     DX,184FH
            INT     10H
            RET
Q10CLR      ENDP
;                   Fijar hilera/columna de cursor
;--------------------------------------------------
Q20CURS     PROC    NEAR
            MOV     AH,02H
            MOV     BH,00
            INT     10H
            RET
Q20CURS     ENDP
          
;--------------------------------------------------                
            END     BEGIN