;HUGO MARIO ROD´RIGUEZ MENDOZA
;2420191008
            .MODEL  SMALL               ;Define el tamano el codigo
            .STACK  64
;--------------------------------------------------
            .DATA                       ;Espacio de almacenamiento de datos
NAMEPAR     LABEL   BYTE                ;
MAXNLEN     DB      15                  ;CANTIDAD MAXIMA DE CARACTERES A INGRESAR
NAMELEN     DB      ?                   ;CARACTERES A INGRESADOS POR EL TECLADO
NAMEFLD     DB      15  DUP(' ')        ;Duplica en memoria 15 lo que esta dentro de las comillas     
PROMPT      DB      'PALABRA ',  '$'    ;
OUTPUT      DB      ' ','$'             ;CARACTERES A IMPRIMIR EN LA PANTALLA
FILA        DB      12                  ;VARIABLE QUE SIRVE PARA DETERMINAR LAS POSICIONES
                                        ;DE LOS CARECTERES EN LAS FILAS DE LA PANTALLA
CONTROL     DB      ?                   ;COONTROLA EL NUMERO DE ITERACCIONES QUE PUEDE
                                        ;REALIZAR EL CODIGO
COL         DB      40                  ;VARIABLE PARA GUIAR LA UBICACION DE LA COLUMNA
                                        ;A IMPRIMIR
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
            JMP     A20LOOP

            


A30:
            MOV     AX,4C00H
            INT     21H
BEGIN       ENDP
;                   EXHIBE INDICADOR 
;--------------------------------------------------
B10PRMP     PROC    NEAR            
            MOV     AH,09H             
            LEA     DX,PROMPT
            INT     21H
            RET
B10PRMP     ENDP
;                   ACEPTA LA ENTRADA TECLEADA
;__________________________________---

D10INPT     PROC    NEAR
            MOV     AH,0AH                           
            LEA     DX,NAMEPAR          
            INT     21H
            RET
D10INPT     ENDP
;                   Fijar campana y delimitador '$':
;--------------------------------------------------
E10CODE     PROC    NEAR           
            MOV     DH,NAMELEN     ;SE MUEVE EL VECTOR DE NAMELEN AL REGISTRO DH
                                   ;DH EQUIVALE A LAS FILAS Y DL SON COLUMNAS        
            SHR     DH,1           ;SE LE APLICA EL COMPLEMENTO A2 PARA ORDENAR EN LAS
                                   ;FILAS DE MANERA CENTRADA AUTOMATICAMENTE SIN IMPORTAR
                                   ;EL TAMANO DEL VECTOR
            NEG     DH
            ADD     DH,FILA
            MOV     DL,COL         ;MOVEMOS EL VALOR DE COL A DL PARA RECORDALE EN QUE 
                                   ;POSICION DEBE DE INICIAR
            CALL    Q20CURS        ;FIJA EL CURSOR EN LAS COORDENAS ESTABLECIDAS POR DH YDL
            LEA     SI,NAMEFLD     ;SE PASA LA DIRECCION DE LA VARIABLE NAMEFLD AL REGISTRO
                                   ;SI
            CALL    Q10CLR         ;LIMPIA PANTALLA    
            MOV     BL,NAMELEN     ;SE PROCEDE A CALCULAR LA LIMITACION DE ITERACCIONES
                                   ;PASAMOS EL VECTOR INTRODUCIDO POR EL USUARIOAL REGISTRO
                                   ;BL DESPUES DE ELLO LO QUE SE ENCUENTRA EN BL A LA
            MOV     CONTROL,BL     ;VARIABLE CONTROL
            INC     CONTROL 
            MOV     FILA,12        ;RECORDAMOS QUE EL VALOR INICIAL DE FILA SERA 12
PRUEBA:     
                                   ;INCREMENTAMOS FILA
            INC     FILA           ;VOLVEMOS A REALIZAR EL CALCULO DEL COMPLEMENTO A2
            MOV     DH,NAMELEN     ;PARA QUE ORGANICE, EN QUE DILA DEBE DE EMPEZAR A         
            SHR     DH,1           ;IMPRIMIR EL PRIMER CARACTER
            NEG     DH
            ADD     DH,FILA
           
            MOV     DL,COL         ;RECORDAMOS EL VALOR QUE DEBE TOMAR DL, ES 40
            CALL    Q20CURS        ;UBICAMOS CURSOR EN LAS COORDENASA ESPECIFICAS
            
            MOV     AL,[SI]        ;LO QUE SE ENCONTRABA EN EL REGISTRO SI PASA AL REGISTRO
                                   ;AL
            MOV     OUTPUT,AL      ;PASAMOS EL VALOR DE AL A LA VARIABLE OUTPUT
            MOV     AH,09H         ;DAMOS LA PRIMERA INSTRUCCION PARA LA INTERRUPCION 21
            LEA     DX,OUTPUT      ;SE PASA LOS VALORES QUE TIENE OUTPUT AL REGISTRO DX
                                   ;PARA MOSTRAR QUE SE IMPRIMIRA EN PANTALLA
            
            INT     21H            ;SE REALIZA LA INTERRUPCION 21

            INC     SI             ;INCREMENTA EN SI PARA PASAR AL SIGUIENTE CARACTER DE
                                   ;OUTPUT
            DEC     CONTROL        ;DECREMENTA EN UNO A CONTROL PARA REDUCIR LA CANTIDAD DE
                                   ;ITERACCIONES
            MOV     CH,0
            MOV     CL,CONTROL     ;SE MUEVE LO DE CONTROL A CX PARA LIMITAR LA CANTIDAD DE
                                   ;LOOPS
            
            LOOP    PRUEBA         ;REPITE EL PROCESO HASTA QUE CX LLEGUE A 0 SIENDO ESTE
                                   ;LA MISMA CANTIDAD DE CARACTERES QUE SE INGRESARON
           
            RET
E10CODE     ENDP


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
            
            
