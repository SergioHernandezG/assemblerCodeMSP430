;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
TA_CTL      .equ    TASSEL_2|ID_0|MC_1|TAIE ; 000000 10 00 01 000 1 = SMCLK,/8,UP,IE
TA_FREQ     .equ    0x0001                  ; clocks, F_DCO=1.1375 MHz
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------                                            ;-------------------------------------------------------------------------------
RESET:
START:      mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT:    mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
SetupP1:    bis.b   #001h,&P1DIR            ; P1.0 output
SetupC0:    mov.w   #CCIE,&CCTL0            ; CCR0 interrupt enabled
            mov.w   #0,&CCR0            	;
SetupTA:    mov.w   #TASSEL_2+MC_2,&TACTL   ; SMCLK, contmode
;-------------------------------------------------------------------------------                                            ;
Mainloop:   bis.w   #CPUOFF+GIE,SR          ; CPU off, interrupts enabled
            nop                             ; Required only for debugger                                          ;
;-------------------------------------------------------------------------------
; Timer A ISR
;-------------------------------------------------------------------------------
TA_ISR:     xor.b   #001h,&P1OUT            ; Toggle P1.0
            add.w   #40000,&CCR0            ; Add Offset to CCR0
            reti                            ;
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".int09"                ; Watchdog Vector
            .word   TA_ISR                  ; Watchdog ISR
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  START
            .end
