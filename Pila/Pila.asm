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

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer
;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main		mov.w	#0x0000,r6
			mov.w	#0x0005,r7
loop1		add.w	#0x0001,r6
			push	r6
			dec		r7
			jnz		loop1

			mov.w	#0x0005,r7
loop2		pop		r6
			dec		r7
			jnz		loop2

			mov.w	#0x0004,r4
			mov.w	#0x0005,r5
			mov.b	#0x0006,r6
			call	#subroutine1
			jmp		main

subroutine1	push.w	r4
			push.w	r5
			push.b	r6
			mov.w	#0x4444,r4
			mov.w	#0x5555,r5
			mov.w	#0x6666,r6
			pop		r6
			pop		r5
			pop		r4
			ret

                                            

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
            

