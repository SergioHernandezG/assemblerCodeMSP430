;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .def    RESET                   ; DEFINICION DEL RESET
;-------------------------------------------------------------------------------
WDT_CPS     .equ    1200000/500             ; NUMERO DE CICLOS DEL WDT (CICLOS WDT/SEC)
;-------------------------------------------------------------------------------
;SECCIÓN DE DATOS
;-------------------------------------------------------------------------------
           .bss     WDT_dcnt,2              ; CONTADOR PARA EL WDT
           .bss     switches,2              ; VARIABLE PARA INTERRUPTORES
;-------------------------------------------------------------------------------
;SECCIÓN DE CÓDIGO
;-------------------------------------------------------------------------------
            .text                           ; DIRECTIVA DE INICIO DE INSTRUCCIONES DE ENSAMBLADOR
;-------------------------------------------------------------------------------
; Main loop
;-------------------------------------------------------------------------------
RESET:      mov.w   #__STACK_END,SP         ; INICIO DE PILA
            mov.w   #WDT_MDLY_8,&WDTCTL     ; WDT SMCLK, 8 ms (@1 Mhz)
            bis.b   #WDTIE,&IE1             ; HABILITA LAS INTERRUPCIONES
            clr.w   WDT_dcnt                ; LIMPIA EL REGISTRO ASOCIADO AL WDT
;-------------------------------------------------------------------------------
            bis.b   #0x0f,&P1DIR            ; CONFIGURA P2.0-3 COMO SALIDAS
            clr.b	&P1OUT
            bic.b   #0x01,&P2DIR            ; CONFIGURA P1.0-3 COMO ENTRADAS
            bis.b   #0x01,&P2OUT            ; HABILITA LAS RESISTENCIAS DE PULL-UP
            bis.b   #0x01,&P2REN            ;
            bis.b   #0x01,&P2IES            ; TRANSICION DE ALTO A BAJO PARA CAUSAR LA INTERRUPCION
            bis.b   #0x01,&P2IE             ; HABILITA LA INTERRUPCION POR PUERTO
            mov.w   #0,r6
;-------------------------------------------------------------------------------
mainloop:   bis.w   #LPM0|GIE,SR            ; HABILITA LAS INTERRUPCIONES Y MANDA A DORMIR
           ; mov.b   r6,&P1OUT   						; Si no se encuentra pulsado, se va la funcion Acendente
            jmp     mainloop
                        ; HABILITA LAS INTERRUPCIONES Y MANDA A DORMIR
            						; Regresa al lazo principal.
;**************acendete]


;-------------------------------------------------------------------------------
; Port 1 ISR
;-------------------------------------------------------------------------------
DEBOUNCE   .equ     5                       ; CUENTA PARA EL ANTIRREBOTE (~40 ms)
;-------------------------------------------------------------------------------
P1_ISR:    bic.b    #0x0f,&P2IFG            ; DESHABILITA LAS INTERRUPCIONES
           mov.w    #DEBOUNCE,WDT_dcnt      ; CARGA PARA EL CONTEO DEL ANTIRREBOTE

           reti
;-------------------------------------------------------------------------------
; Watchdog ISR
;-------------------------------------------------------------------------------
WDT_ISR:
           cmp.w   #1h,&P2IN
           jz      boto
           ;mov.b   &P2IN,&P1OUT
           cmp.w   #0,WDT_dcnt             ; SE PULSO ALGUNA TECLA PARA REALIZAR EL DEBOUNCING?
              jeq   WDT_02                  ; NO
              mov.b   &P2IN,&P1OUT
             ; inc.w  r6
            sub.w   #1,WDT_dcnt             ; SI, DECREMENTA EL CONTADOR, 0?
              jne   WDT_02                  ; NO
            ;  inc.w  r6
            ;mov.b   &P2IN,switches          ; SI, LEE LOS INTERRUPTORES
            ;xor.b   #0x0f,switches          ;
            ;and.b   #0x0f,switches          ; MASCARA DE LOS 4 BITS BAJOS
            bic.b   #LPM0,0(SP)             ; DESPIERTA DE MODO DE BAJO CONSUMO
;-------------------------------------------------------------------------------
WDT_02:     reti                            ; REGRESA DE LA INTERRUPCION

boto:   mov.b   &P2IN,&P1OUT
        reti
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".int03"
            .word   P1_ISR                  ; Port 1 ISR
            .sect   ".int10"
            .word   WDT_ISR                 ; Watchdog ISR
            .sect   ".reset"
            .word   RESET                   ; RESET ISR
            .end
;-------------------------------------------------------------------------------



