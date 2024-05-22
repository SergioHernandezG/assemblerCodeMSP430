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

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
_main:
        clr.b   &P1OUT                      ; LIMPIANDO ENTRADAS
        mov.w   #0xFF, &P1DIR            	; Todo el puerto P1 como salidas (LEDs).
  		mov.b   #0x003F, &P2DIR             ;
  		mov.w   #0h,&P1OUT           	; Todo el puerto P2 como entradas (Push-Button).
  		mov.w   #0h,&P2OUT                 ;
;******************** Checa el si el boton se encuentra pulsado *****************************
loopm:	                                ;inicializo de registro
        mov.w   #0h,r4                  ; para las unidades del segundo
        mov.w   #0h,r5                  ;para las decenas del segundo
        mov.w   #0h,r6                  ;para las unidades del minuto
	    mov.w   #0h,r7                  ;para las decenas del minuto
	    mov.w   #0h,r8                  ;para las unidades del hora
	    mov.w   #0h,r9                  ;para las decenas del hora
	    mov.w   #0h,r12                 ;regitro para el mux
  		call    #Segundos			   ; llamando a la funcion segundos
  		mov.b   #00h, &P1OUT 				; Limpia los LEDs.
		jmp     loopm 						; Regresa al lazo principal.
;**************Segundos
Segundos:                           ;

        call    #Stptime                    ;detiene el tiempo un segundo aprox
        inc.w    r4
        cmp.b   #10, r4                ;
        jz      Seg
        jmp     Segundos
Seg:
       mov.w   #0h,r4  ;cuando termina reinicia los valores de r4 para empezar de new
       inc.w   r5
       cmp.w   #6,r5
       jge     Minutos
       jmp Segundos
;***********************minutos
Minutos:
       mov.w   #0,r5
        cmp.w   #9,r6                  ; r6 si es igual a 9
        jeq     min                  ;
        inc.w   r6                         ;
        jmp 	Segundos
min:
       mov.w   #0h,r6
       inc.w   r7
       cmp.w   #5,r7
       jge    Horas
       jmp 	Segundos
;********************
;******************** Horas
Horas:
         mov.w   #0,r7
        cmp.w   #1,r9
        jeq     hor1
        cmp.w   #9,r8                  ; r8 si es igual a 9
        jeq     hor                  ;
        inc.w   r8                         ;
        jmp 	Segundos
hor:
       mov.w   #0h,r8
       inc.w   r9
       cmp.w   #1,r9
       jge    rei
       jmp 	Segundos
hor1:
       mov.w   #0h,r8
       inc.w   r9
       cmp.w   #2,r9
       jge    rei
       jmp 	Segundos
rei:
     mov.w    #0,r9
     jmp    Segundos
;********************
BCD:                                     ; funcio para los casos
        cmp.w #0000h,r13                 ;si es cero
        jne   sw_01                      ;si no es cero salta sw_01 para comparar si es uno y si no sigue saltando a las sw_02 hasta encontrar el corecto
        ;mov.b   #003Fh,&P1OUT            ;muestra el valor 1 en el display siete segmentos
        mov.b   #007Eh,&P1OUT            ;muestra el valor 1 en el display siete segmentos
        jmp   sw_end                     ; salta a sw_end para salir del caso
sw_01:
        cmp.w #0001h,r13
        jne sw_02
       ;mov.b   #0024h,&P1OUT
       mov.b   #0030h,&P1OUT
        jmp sw_end
sw_02:
        cmp.w #0002h,r13
        jne sw_03
       ;mov.b   #0005Dh,&P1OUT
       mov.b   #006Dh,&P1OUT
        jmp sw_end
sw_03:
        cmp.w #0003h,r13
        jne sw_04
       ;mov.b   #0075h,&P1OUT
       mov.b   #0079h,&P1OUT
        jmp sw_end
sw_04:
        cmp.w #0004h,r13
        jne sw_05
      ; mov.b   #0066h,&P1OUT
       mov.b   #0033h,&P1OUT
        jmp sw_end
sw_05:
        cmp.w #0005h,r13
        jne sw_06
      ; mov.b   #0073h,&P1OUT
        mov.b   #005Bh,&P1OUT
        jmp sw_end
sw_06:
        cmp.w #0006h,r13
        jne sw_07
       ;mov.b   #007Ah,&P1OUT
       mov.b   #001Fh,&P1OUT
        jmp sw_end
sw_07:
        cmp.w #0007h,r13
        jne sw_08
       ;mov.b   #0065h,&P1OUT
       mov.b   #0071h,&P1OUT
        jmp sw_end
sw_08:
        cmp.w #0008h,r13
        jne sw_09
       ;mov.b   #007Fh,&P1OUT
       mov.b   #007Fh,&P1OUT
        jmp sw_end
sw_09:
        cmp.w #0009h,r13
        jne default
       ;mov.b   #0067h,&P1OUT
       mov.b   #0073h,&P1OUT
        jmp sw_end
default:
sw_end:
       ret                  ; regresa donde fue llamada la funcion
;------------
;*************************** Rutina de Delay*************************************************
Stptime:                                    ; esta funcion es un contador de tiempo se sale cuando alcannzo un segundo aprox	                                    ;
		mov.w   #0100h, R11   				; 3 Ciclos  x 6 times  (1000 in hex = 4096 in Decimal)
loop_b:
        mov.w   #06h, R10   				;
loop_c:
        call    #Mux
	    inc.w   r12                         ;
        dec.w   R10            				; hace 393216 ciclos para dar un segundo aprox
		jnz     loop_c 						;
		mov.w   #0,r12                      ;
		dec.w   R11            				; hace 393216 ciclos para dar un segundo aprox
		jnz     loop_b 						;
		ret
;********************************************************************************************
Mux:                                     ; funcio para los casos
        mov.b   #0h,&P2OUT            ;muestra el valor 1 en el display siete segmentos
        cmp.w #0000h,r12                 ;si es cero
        jne   sw_011                      ;si no es cero salta sw_01 para comparar si es uno y si no sigue saltando a las sw_02 hasta encontrar el corecto
        mov.w  r4,r13                    ;
        call    #BCD                       ;llama a la funcion BCD que es la que muestra el numero en el dispplay 7 segmentos
        ;mov.b   #003Eh,&P2OUT            ;muestra el valor 1 en el display siete segmentos
        mov.b   #1h,&P2OUT
        jmp   sww_end                     ; salta a sw_end para salir del caso
sw_011:
        cmp.w #0001h,r12
        jne sw_022
       mov.w  r5,r13
       call    #BCD
       ;mov.b   #003Dh,&P2OUT
       mov.b   #2h,&P2OUT
        jmp sww_end
sw_022:
        cmp.w #0002h,r12
        jne sw_033
       mov.w  r6,r13
       call    #BCD
       ;mov.b   #003Bh,&P2OUT
       mov.b   #4h,&P2OUT
        jmp sww_end
sw_033:
        cmp.w #0003h,r12
        jne sw_044
       mov.w  r7,r13
       call    #BCD
       ;mov.b   #0037h,&P2OUT
       mov.b   #8h,&P2OUT
        jmp sww_end
sw_044:
        cmp.w #0004h,r12
        jne sw_055
       mov.w  r8,r13
       call    #BCD
       ;mov.b   #002Fh,&P2OUT
       mov.b   #10h,&P2OUT
        jmp sww_end
sw_055:
        cmp.w #0005h,r12
        jne defaultt
       mov.w  r9,r13
       call    #BCD
       ;mov.b   #001Fh,&P2OUT
       mov.b   #20h,&P2OUT
        jmp sww_end
defaultt:
sww_end:
       ret                  ; regresa donde fue llamada la funcion
;*************************** Rutina *************************************************
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
            
