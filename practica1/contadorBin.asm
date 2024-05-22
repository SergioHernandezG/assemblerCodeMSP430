;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            .text
            .global _main
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------                ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
_main:
        clr.b   &P1OUT                      ; LIMPIANDO ENTRADAS
        mov.w   #0xFF, &P1DIR            	; Todo el puerto P1 como salidas (LEDs).
  		clr.b   &P2DIR                      ;todo el P2 como entrada
  		mov.w   #0000h,&P2OUT               ; Todo el puerto P2 como entradas (Push-Button).
  		mov.b   #001h, R14 					; Mascara para el Push-Button, con este valor se comparará si el botón fue pulsado.
;******************** Checa el si el boton se encuentra pulsado *****************************
loopm:	call    #Stptime                    ;llamando a la funcio Stptime para hacer 393216 ciclos que es aprox de un segundo
        mov.w   #0h,r13                   ; inicializo r13=0 en hex
		cmp.b   &P2IN, R14 					; Checa si el botón se encuentra pulsado (P2.0).
        jnz      Acendente                   ;si no es pulsado se va a contar Ascendentemente, llama la funion Acendente
        call    #Descendente                  ;llama a funcion Decendente
		jmp     loopm 						; Regresa al lazo principal.
;**************acendete]
Acendente:
        .bss    i,2                         ;inicializacion de i
        mov.w   r13,i                        ; i =0,
for_ck: cmp.w   #255,i                      ;compara si i es igual a 255, bucle for para incrementar
        jge     for_done                    ; si son iguales salta for_done y si no sigue
        inc.w   r13                         ;decrementa r13 uno en uno
        mov.b   r13,&P1OUT                  ;muestra el valor de r13 en los puesrtos P1
        call    #Stptime                    ;detiene el tiempo un segundo aprox
        cmp.b   &P2IN, R14                  ;compara si boton es presionado
        jz      Descendente                 ;si es pulsado se va a Descendente
        add.w   #1,i                        ; si no es pulsado sigue
        jmp     for_ck                      ;salta a for_ck
for_done:
      mov.w   #0h,r13                   ; inicializo r13=0 en decimal cuando termina el for
      jmp     loopm                     ;salta a loopm
;------------decendente
Descendente:
while_loop:                             ; bucle whila para decrementar
        cmp.w   #0,r13                      ;compara si cero igual r13
        jeq     while_done                  ; salata a While_done si son iguales
        dec.w   r13                         ;decrementa r13 uno en uno
        mov.b   r13,&P1OUT                  ;muestra el valor de r13 en los puertos P1
        call    #Stptime                    ;detiene el tiempo un segundo aprox
        cmp.b   &P2IN, R14                  ;compara si boton es pulsado
        jz      Acendente                   ; si boton presionado va la funcion Acendente
        jmp     while_loop                  ; si no salta a while_loop
while_done:
       mov.w   #00FFh,r13                   ; inicializo r11=FF en hexadecimal
       jmp     Descendente                       ;salta a descendete
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
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
