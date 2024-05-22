;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
			.cdecls C,LIST,"msp430.h"		; Cambiar de acuerdo a la variante del chip
			.text							; Marca el inicio del programa (si no se coloca el programa no funciona)
			.global _main 					; Define el punto de entrada   (si no se coloca el programa no funciona)
;-------------------------------------------------------------------------------
            .def    RESET                   ; Exporta la entrada al programa e indica al enlazador.
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
RESET	mov.w   #__STACK_END,SP         	; Inicia el apuntador de pila.
StopWDT	mov.w   #WDTPW|WDTHOLD,&WDTCTL  	; Detiene el Watchdog Timer
;-------------------------------------------------------------------------------
;main loop here
;-------------------------------------------------------------------------------
_main:
        clr.b   &P1OUT                      ; LIMPIANDO ENTRADAS
        mov.w   #0x7F, &P1DIR            	; Todo el puerto P1 como salidas (LEDs).
  		mov.b   #0x0000, &P2DIR             ;
  		mov.w   #0h,&P1OUT           	; Todo el puerto P2 como entradas (Push-Button).
  		mov.b   #001h, R15 					; Mascara para el Push-Button, con este valor se comparará si el botón fue pulsado.
;******************** Checa el si el boton se encuentra pulsado *****************************
loopm:	call    #Stptime                    ;se detiene un segundo aprox
        mov.w   #0h,r14                   ; inicializo r11=256 en decimal
		cmp.b   &P2IN, R15 					; Checa si el botón se encuentra pulsado (P2.0).
  		jnz     Ascendente 						; Si no se encuentra pulsado, se va la funcion Acendente
        call    #Descendente                      ;llama al funcion Descente
  		mov.b   #00h, &P1OUT 				; Limpia los LEDs.
		jmp     loopm 						; Regresa al lazo principal.
;**************acendete]
Ascendente:
        .bss    i,2                         ;inicializacion de i
        mov.w   r14,i                        ; i =0
for_ck: cmp.w   #10,i                     ;bucle for para incrmentar el valor de r14
        jge     for_done                   ;sale del for cuando la comparacin anterior es igual
        call    #BCD                       ;llama a la funcion BCD que es la que muestra el numero en el dispplay 7 segmentos
        inc.w   r14                         ;decrementa r11 uno en uno256,255,254
        call    #Stptime                    ;detiene el tiempo un segundo aprox
        cmp.b   &P2IN, R15                ; cuando el boton es pulsado sal ta a Descente sino termina el ciclos
        jz      Descendente
        add.w   #1,i
        jmp     for_ck
for_done:
       mov.w   #0h,r14  ;cuando termina reinicia los valores de r14 para empezar de new
       jmp Ascendente
;------------decendente
Descendente:
        mov.w  #0h,r12                      ;inicializo r12=10
while_loop:                                 ;bucle while para el decremento
       ; call    #BCD                        ; llamaa a la funcion BCD
        cmp.w   #-1,r14                      ; r14 si es igual a cero
        jeq     while_done                  ; salta a while _done si es igual la comaracion anterior
        call    #BCD                        ; llamaa a la funcion BCD
        dec.w   r14                         ;decrementa r11 uno en uno
       ; inc.w   r12                         ;dincrementa r12
        call    #Stptime                    ;detiene el tiempo un segundo aprox
        cmp.b   &P2IN, R15                  ; compara si e boton es pulsado
        jz      Ascendente                   ; si es verdadero va a la funcion Acendente
        jmp     while_loop
while_done:
       mov.w   #0h,r12
       mov.w   #9h,r14                     ; cuado termina y el cotador llega a cero reinicia el valor del registro r14
       jmp  Descendente                    ; salta a la funcion Descendente
;*****************BCD
BCD:                                     ; funcio para los casos
        mov.w    r14,r13                 ;
        cmp.w #0000h,r13                 ;si es cero
        jne   sw_01                      ;si no es cero salta sw_01 para comparar si es uno y si no sigue saltando a las sw_02 hasta encontrar el corecto
        mov.b   #003Fh,&P1OUT            ;muestra el valor 1 en el display siete segmentos
        jmp   sw_end                     ; salta a sw_end para salir del caso
sw_01:
       ; mov.w    r11,r13
        cmp.w #0001h,r13
        jne sw_02
       mov.b   #000Ch,&P1OUT
        jmp sw_end
sw_02:
        ;mov.w    r11,r13
        cmp.w #0002h,r13
        jne sw_03
       mov.b   #0005Bh,&P1OUT
        jmp sw_end
sw_03:
        cmp.w #0003h,r13
        jne sw_04
       mov.b   #005Eh,&P1OUT
        jmp sw_end
sw_04:
        cmp.w #0004h,r13
        jne sw_05
       mov.b   #006Ch,&P1OUT
        jmp sw_end
sw_05:
        cmp.w #0005h,r13
        jne sw_06
       mov.b   #0076h,&P1OUT
        jmp sw_end
sw_06:
        cmp.w #0006h,r13
        jne sw_07
       mov.b   #0067h,&P1OUT
        jmp sw_end
sw_07:
        cmp.w #0007h,r13
        jne sw_08
       mov.b   #005Ch,&P1OUT
        jmp sw_end
sw_08:
        cmp.w #0008h,r13
        jne sw_09
       mov.b   #007Fh,&P1OUT
        jmp sw_end
sw_09:
        cmp.w #0009h,r13
        jne default
       mov.b   #007Ch,&P1OUT
        jmp sw_end
default:
sw_end:
       ret                  ; regresa donde fue llamada la funcion
;------------
;*************************** Rutina de Delay*************************************************
Stptime:                                    ; esta funcion es un contador de tiempo se sale cuando alcannzo un segundo aprox
	    mov.w   #0060h, R11   				; 3 Ciclos  x 6 times  (0060 in hex = 96in Decimal)				; 3 Ciclos 6h
loop_a:	mov.w   #1000h, R10   				; 3 Ciclos  x 6 times  (1000 in hex = 4096 in Decimal)
loop_b: dec.w   R10            				; hace 393216 ciclos para dar un segundo aprox
		jnz     loop_b 						;
		dec.w   R11 						;
		jnz     loop_a 						;
		ret
;********************************************************************************************

;-----------------------------------------------------------------------------------
; The following lines define what happens when the reset button is pressed. Again these
; lines are a CCS convention and must always be included
;-----------------------------------------------------------------------------------
			.sect   ".reset"
.shortmain
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                	; MSP430 RESET Vector
            .short  RESET
