;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            .text
            .global  _main
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
;_main:
    ;    call    #start			; Mascara para el Push-Button, con este valor se comparará si el botón fue pulsado.
;******************** Checa el si el boton se encuentra pulsado *****************************
start:     mov.w    #0x0400,SP   ;
           mov.w    #0x5a80,&WDTCTL
           bis.b    #0x0f,&P1DIR
           bic.b    #0x0f,&P1OUT
           mov.w    #0,r15

mloop:     mov.b    #0x08,r4

dloop:     sub.w    #1,r15
           jne      dloop
           xor.b    r4,&P4OUT
           rrc.b    r4
           jnc      dloop
           jmp      mloop
;********************************************************************************************

;-----------------------------------------------------------------------------------
; The following lines define what happens when the reset button is pressed. Again these
; lines are a CCS convention and must always be included
;-----------------------------------------------------------------------------------
;-----------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
