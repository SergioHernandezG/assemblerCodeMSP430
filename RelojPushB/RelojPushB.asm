;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
TA_CTL      .equ    TASSEL_2|ID_3|MC_1|TAIE ; SMCLK,/8,UP,IE
TA_FREQ     .equ    0x0100                 ; FRECUENCIA DEL timerA
WDT_CPS     .equ    1200000/500
;WDT_CPS     .equ    1200000/33350         ;65535          ;1200000/7692           ; WDT clocks/second
;-------------------------------------------------------------------------------
WDT_EVENT   .equ    0x0001                  ; EVENTO DEL WDT
TA_EVENT    .equ    0x0002                  ; EVENTO DEL timerA
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
;-------------------------------------------------------------------------------
;SECCIÓN DE DATOS
;-------------------------------------------------------------------------------
            .bss    WDTSecCnt,2             ; CONTADOR PARA EL WDT
            .bss    sys_event,2             ; VARIABLE PARA EVENTOS
            .bss     WDT_dcnt,2              ; CONTADOR PARA EL WDT
            .bss     switches,2              ; VARIABLE PARA INTERRUPTORES
;-------------------------------------------------------------------------------
;SECCIÓN DE CÓDIGO                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.

;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
RESET:
START:      mov.w   #__STACK_END,SP         ; INICIO DE LA PILA
StopWDT:    mov.w   #WDTPW+WDTHOLD,&WDTCTL  ; Stop WDT
            mov.w   #WDT_MDLY_8,&WDTCTL     ; WDT SMCLK, 8 ms (@1 Mhz)
            bis.b   #WDTIE,&IE1             ; HABILITA LAS INTERRUPCIONES
            clr.w   WDT_dcnt                ; LIMPIA EL REGISTRO ASOCIADO AL WDT
;-------------------------------------------------------------------------------
            clr.w   &TAR                    ; LIMPIA EL REGISTRO DEL TIMER_A
            mov.w   #TA_CTL,&TACTL          ; SE CARGA EL VALOR DE TA_CTL EN EL REGISTRO TACTL (timerA control register)
            mov.w   #TA_FREQ,&TACCR0        ; SE CARGA EL VALOR DE TTA_FREQ EN EL REGISTRO TACCR0 (interval frequency)
            clr.b   &P1OUT                      ; LIMPIANDO ENTRADAS
            mov.w   #0xFF, &P1DIR            	; Todo el puerto P1 como salidas (LEDs).
  		    mov.b   #0x003F, &P2DIR             ;
  		    mov.w   #0h,&P1OUT           	; Todo el puerto P2 como entradas (Push-Button).
  		    mov.w   #0h,&P2OUT
            clr.w   &sys_event              ; LIMPIA EL REGISTRO DE EVENTOS
;-------------------------------------------------------------------------------
            bic.b   #0x80,&P1DIR            ; CONFIGURA P1.0-3 COMO ENTRADAS
            bis.b   #0x80,&P1OUT            ; HABILITA LAS RESISTENCIAS DE PULL-UP
            bis.b   #0x80,&P1REN            ;
            bis.b   #0x80,&P1IES            ; TRANSICION DE ALTO A BAJO PARA CAUSAR LA INTERRUPCION
            bis.b   #0x80,&P1IE             ; HABILITA LA INTERRUPCION POR PUERTO
;-------------------------------------------------------------------------------
            mov.w   #0h,r4                  ; para las unidades del segundo
            mov.w   #0h,r5                  ;para las decenas del segundo
            mov.w   #0h,r6                  ;para las unidades del minuto
	        mov.w   #0h,r7                  ;para las decenas del minuto
	        mov.w   #1h,r8                  ;para las unidades del hora
	        mov.w   #0h,r9                  ;para las decenas del hora
	        mov.w   #0h,r10
	        mov.w   #0h,r11
            mov.w   #0h,r12                 ;
;-------------------------------------------------------------------------------
; Event Loop
;-------------------------------------------------------------------------------
loop:       bic.w   #GIE,SR                 ; DESABILITA LAS INTERRUPCIONES
            cmp.w   #0,&sys_event           ; VERIFICA SI HAY ALGUNA INTERRUPCION PENDIENTE
              jne   loop01                  ; SI
            bis.w   #GIE|LPM0,SR            ; NO, MODO LPM0 DE BAJO CONSUMO (SLEEP) se apaga el CPU
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
loop01:     cmp.w   #TA_EVENT,&sys_event    ; EL EVENTO ES DEL TIMER_A?
              jne   loop02                  ; NO
            bic.w   #TA_EVENT,&sys_event    ; SI, LIMPIA EL EVENTO
            ;---Elege el diplay a encender
            mov.b   #0h,&P2OUT              ;apaga los displays
            cmp.w #100h,r10
            jz  Segundos
            cmp.w   #0h,r12                 ;compara que dispay debe encender
            jz   sw_000                      ;Si,salta
            cmp.w #1h,r12                    ;No, compara de nuevo
            jz sw_011
            cmp.w   #2h,r12
            jz   sw_022
            cmp.w #3h,r12
            jz sw_033
            cmp.w   #4h,r12
            jz   sw_044
            cmp.w #5h,r12
            jz sw_055

sw_000:                                  ;Display uno para las unidades del segundo
        inc.w   r12
        inc.w   r10                     ; incrementa r12 para avanzar de display una afuerad de Display uno
        mov.w  r4,r13                    ; move dato del segundo actual a r13
        call    #BCD                       ;llama a la funcion BCD que es la que muestra el numero en el dispplay 7 segmentos
        mov.b   #0x0001,&P2OUT           ; pin a seleccionado
        jmp   loop                     ; salta a loop para regresar al menu principal
sw_011:                               ; Display 2 decenas de segundo
       inc.w   r12
       inc.w   r10
       mov.w  r5,r13
       call    #BCD
        mov.b   #2h,&P2OUT
        jmp loop
sw_022:                                  ;Display 3 unidadnes de minutos
       inc.w   r12
       inc.w   r10
       mov.w  r6,r13
       call    #BCD
       mov.b   #4h,&P2OUT
        jmp loop
sw_033:                                          ;Display cuatro decenas de minuto
       inc.w   r12
       inc.w   r10
       mov.w  r7,r13
       call    #BCD
       mov.b   #8h,&P2OUT
        jmp loop
sw_044:                                        ;Display 5 unidades de hora
       inc.w   r12
       inc.w   r10
       mov.w  r8,r13
       call    #BCD
       mov.b   #10h,&P2OUT
        jmp loop
sw_055:                                         ; Display 6 decenas de hora
        mov.w  #0,r12
        inc.w   r10
        mov.w  r9,r13
        call    #BCD
        mov.b   #20h,&P2OUT
        jmp loop
Segundos:
           inc.w    r4           ; incremta el unidades segundo
           mov.w   #0h,r10
           cmp.b   #10, r4        ; unidades de seg igual 10?         ;
           jz      Seg            ; Si, salta a seg que es decenas de segundo
           jmp    loop            ;No, salta menu princial "loop"
Seg:
          mov.w   #0h,r4  ;cuando termina reinicia los valores de r4 para empezar de new
          inc.w   r5
          cmp.w   #6,r5
          jge     Minutos
          jmp loop
Minutos:
          mov.w   #0,r5
          cmp.w   #9,r6                  ; r6  es igual a 9
          jeq     min
          inc.w   r6
        jmp 	loop
min:
          mov.w   #0h,r6
         inc.w   r7
         cmp.w   #6,r7
         jge    Horas
        jmp 	loop
Horas:
         mov.w   #0,r7
        cmp.w   #1,r9
        jeq     hor1
        cmp.w   #9,r8                  ; r8 es igual a 9
        jeq     hor                  ;
        inc.w   r8                         ;
        jmp 	loop
hor:
       mov.w   #0h,r8
       inc.w   r9
       jmp 	loop
hor1:
       mov.w   #0h,r7
       inc.w   r8
       cmp.w   #3,r8
       jge    rei
       jmp 	loop
rei:
     mov.w    #0,r9
     mov.w    #1,r8
     jmp      loop

;-----------------------------------------------------
loop02:     cmp.w   #WDT_EVENT,&sys_event   ; EL EVENTO ES DEL WDT?
              jne   loop03                  ; NO
           bic.w   #WDT_EVENT,&sys_event   ; SI, LIMPIAR EVENTO
      ;-------------conteo del reloj para 12 horas
          ; cmp.w   #0h,r11
            ;jz  MoSeg
           cmp.w   #0h,r11;#10h,r11                 ;compara que dispay debe encender
            jz   MoMin                      ;Si,salta
           cmp.w #100h,r11                    ;No, compara de nuevo
            jz MoHor
;MoSeg:
           ;inc.w    r4
          ;cmp.w    #10,r4
          ; jeq      Seg
MoMin:
           inc.w    r6
           cmp.w    #10,r6
           jeq      min
MoHor:
           inc.w    r8
           cmp.w    #1,r9
           jeq      hor1
           cmp.w    #10,r8
           jeq      hor
;-------------------------------------------------------------------------------
loop03:
;           << PROCESOS DE OTROS EVENTOS ACÁ>>
          ;mov.w    #0,r12
           jmp loop                 ; LAZO INFINITO
;-------------------------------------------------------------------------------
; Port 1 ISR
;-------------------------------------------------------------------------------
DEBOUNCE   .equ     5                       ; CUENTA PARA EL ANTIRREBOTE (~40 ms)
;-------------------------------------------------------------------------------
P1_ISR:    bic.b    #0x80,&P1IFG            ; DESHABILITA LAS INTERRUPCIONES
          ; inc.w    r11
           mov.w    #DEBOUNCE,WDT_dcnt      ; CARGA PARA EL CONTEO DEL ANTIRREBOTE
           reti
;-------------------------------------------------------------------------------
; Watchdog ISR
;-------------------------------------------------------------------------------
WDT_ISR:    cmp.w   #0,WDT_dcnt             ; SE PULSO ALGUNA TECLA PARA REALIZAR EL DEBOUNCING?
              jeq   WDT_02                  ; NO
            sub.w   #1,WDT_dcnt             ; SI, DECREMENTA EL CONTADOR, 0?
              jne   WDT_02                  ; NO
            ;mov.b   &P1IN,switches          ; SI, LEE LOS INTERRUPTORES
            ;xor.b   #0x0f,switches          ;
            ;and.b   #0x0f,switches          ; MASCARA DE LOS 4 BITS BAJOS
            bis.w   #WDT_EVENT,&sys_event   ; AGENDA EL EVENTO DEL WDT
            bic.w   #GIE|LPM0,0(SP)         ; DESPIERTA EL PROCESADOR
           ; bic.b   #LPM0,0(SP)             ; DESPIERTA DE MODO DE BAJO CONSUMO
;-------------------------------------------------------------------------------
WDT_02:
               inc.w   r11
               reti                            ; REGRESA DE LA INTERRUPCION
;-------------------------------------------------------------------------------
; Watchdog ISR
;-------------------------------------------------------------------------------
;WDT_ISR:    dec.w   &WDTSecCnt              ; SE TEMPORIZO UN SEGUNDO?
              ;jne   WDT_02                  ; NO
           ; mov.w   #WDT_CPS,&WDTSecCnt     ; SI, REINICIA EL CONTADOR
            ;bis.w   #WDT_EVENT,&sys_event   ; AGENDA EL EVENTO DEL WDT
           ; bic.w   #GIE|LPM0,0(SP)         ; DESPIERTA EL PROCESADOR  125 segundos despierta se va la main
;WDT_02:     reti                            ; SALE DE LA WDT_ISR
;-------------------------------------------------------------------------------
; Timer A ISR
;-------------------------------------------------------------------------------
TA_ISR:     bic.w   #TAIFG,&TACTL           ; DESHABILITA LA BANDERA DE INTERRUPCIÓN POR TIMER_A
            bis.w   #TA_EVENT,&sys_event    ; AGENDA EL EVENTO DEL TIMER_A
            bic.w   #GIE|LPM0,0(SP)         ; DESPIERTA EL PROCESADOR
            reti
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;********************
BCD:                                     ; funcio para los casos
        cmp.w #0000h,r13                 ;si es cero
        jne   sw_01                      ;si no es cero salta sw_01 para comparar si es uno y si no sigue saltando a las sw_02 hasta encontrar el corecto
        ;mov.b   #0001h,&P1OUT            ;muestra el valor 1 en el display siete segmentos anado
        mov.b   #007Eh,&P1OUT            ;muestra el valor 1 en el display siete segmentos catodo
        jmp   sw_end                     ; salta a sw_end para salir del caso
sw_01:
        cmp.w #0001h,r13
        jne sw_02
       ;mov.b   #004Fh,&P1OUT
       mov.b   #0030h,&P1OUT
        jmp sw_end
sw_02:
        cmp.w #0002h,r13
        jne sw_03
       ;mov.b   #0012h,&P1OUT
       mov.b   #006Dh,&P1OUT
        jmp sw_end
sw_03:
        cmp.w #0003h,r13
        jne sw_04
       ;mov.b   #0006h,&P1OUT
       mov.b   #0079h,&P1OUT
        jmp sw_end
sw_04:
        cmp.w #0004h,r13
        jne sw_05
       ;mov.b   #004Ch,&P1OUT
       mov.b   #0033h,&P1OUT
        jmp sw_end
sw_05:
        cmp.w #0005h,r13
        jne sw_06
       ;mov.b   #0024h,&P1OUT
        mov.b   #005Bh,&P1OUT
        jmp sw_end
sw_06:
        cmp.w #0006h,r13
        jne sw_07
       ;mov.b   #0020h,&P1OUT
       mov.b   #001Fh,&P1OUT
        jmp sw_end
sw_07:
        cmp.w #0007h,r13
        jne sw_08
       ;mov.b   #000Fh,&P1OUT
       mov.b   #0071h,&P1OUT
        jmp sw_end
sw_08:
        cmp.w #0008h,r13
        jne sw_09
       ;mov.b   #0000h,&P1OUT
       mov.b   #007Fh,&P1OUT
        jmp sw_end
sw_09:
        cmp.w #0009h,r13
        jne default
       ;mov.b   #000Ch,&P1OUT
       mov.b   #0073h,&P1OUT
        jmp sw_end
default:
sw_end:
       ret                  ; regresa donde fue llamada la funcion
;------------

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".int02"
            .word   P1_ISR                  ; Port 1 ISR
            .sect   ".int08"                ; VECTOR DEL TIMER_A
            .word   TA_ISR                  ; TIMER_A ISR
            .sect   ".int10"                ; VECTOR DEL WDT
            .word   WDT_ISR                 ; WDT ISR
            .sect   ".reset"                ; VECTOR DE PUC
            .word   START                   ; RESET ISR
            .end

