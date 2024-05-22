;   Description: A hi/low transition on P1.3 will trigger P1_ISR which,
;   toggles P1.0. Normal mode is LPM4 ~ 0.1uA.
;   Internal pullup enabled on P1.3.
;   ACLK = n/a, MCLK = SMCLK = default DCO
;ISR POR MEDIO DEL P1.3 EN MODO LPM4
;--------------------------------------------------------------------------
;            -----------------
;        /|\|              XIN|-
;         | |                 |
;         --|RST          XOUT|-
;     /|\   |                 |
;      --o--|P1.3         P1.0|-->LED
;     \|/
;  ACLK = n/a, MCLK = SMCLK = default DCO
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; DIRECTIVA DE INICIO DE INSTRUCCIONES DE ENSAMBLADOR
;-------------------------------------------------------------------------------
; Main loop
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
;-------------------------------------------------------------------------------
SetupP1     bis.b   #01h,&P1DIR            ; P1.0 output, else input
            bic.b   #01h,&P1OUT            ; P1.0 set, else reset
;-------------------------------------------------------------------------------
            bis.b   #08h,&P1REN            ; P1.3 pullup
            bis.b   #08h,&P1IE             ; P1.3 Interrupt enabled
            bic.b   #08h,&P1IES            ; P1.3 hi/low edge
            bic.b   #08h,&P1IFG            ; P1.3 IFG Cleared
;-------------------------------------------------------------------------------                                            ;
Mainloop    bis.w   #LPM4|GIE,SR            ; LPM4, enable interrupts
            nop                             ; Required only for debugger
            ; (should never get here!)
;-------------------------------------------------------------------------------
; Port 1 ISR
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
P1_ISR;     Toggle P1.0 Output
;-------------------------------------------------------------------------------
            xor.b   #01h,&P1OUT            ; P1.0 = toggle
            bic.b   #08h,&P1IFG            ; P1.3 IFG Cleared
            reti                           ; Return from ISR
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET                   ;
            .sect   ".int02"                ; P1.x Vector
            .short  P1_ISR                  ;
            .end
;-------------------------------------------------------------------------------



            
