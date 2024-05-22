;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            .text                           ; Assemble into program memory.
            .global _main
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
_main:
                                            
            clr.b &P1OUT     					; Asegura que los LEDs se apaguen al iniciar el programa
			mov.b #0x47, &P1DIR     			; Mueve el valor de #01000001b a P1DIR; para controlar los leds
;-------------------------------------------------------------------------------------
            mov.w #3,r4                         ; r4=3
            sub.w #4,r4                         ; r4=r4-4=-1
            mov.b sr, &P1OUT                    ; indicando la bandera de negativo con un led
            mov.w #0xFFFF,r4                    ;
            add.w #1,r4                         ;
            mov.b sr,&P1OUT                     ;
            mov.w #0,r4                         ;
            add.w #0,r4                         ;
            mov.b sr,&P1OUT                     ;
            mov.w #0x4000,r4                    ;
            add.w #0x4000,r4                    ;
            mov.b sr,&P1OUT                     ;
            clr.b &P1OUT                        ;
infloop:
			jmp infloop
;-------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------
; The following lines define what happens when the reset button is pressed. Again these
; lines are a CCS convention and must always be included
;-----------------------------------------------------------------------------------
			.sect   ".reset"
.short_main
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
            
