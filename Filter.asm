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
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
ARY1	.set	0x0200

		clr.w	R5
		clr.w	R6
		clr.w	R7

RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

Setup		mov.w	#ARY1, R5
			call	#ArraySetup1
			call	#ChipFilter

Mainloop jmp Mainloop

ArraySetup1		mov.w	#10, 0(R5)
 				mov.w	#37, 2(R5)
				mov.w	#17, 4(R5)
				mov.w	#75, 6(R5)
				mov.w	#67, 8(R5)
				mov.w	#23, 10(R5)
				mov.w	#36, 12(R5)
				mov.w	#7, 14(R5)
				mov.w	#44, 16(R5)
				mov.w	#8, 18(R5)
				mov.w	#74, 20(R5)
				mov.w	#18, 22(R5)

				ret

ChipFilter	push	R5
			push	R6
			push	R7
			mov.w	@R5+,	R6	;Store number of elements in R6 for counter, increment R5 to max
			mov.w	@R5+,	R7	;store max value in R7, increment R5 to start the array

Loop	cmp.w	@R5+, R7   ;compare first element of the array to the max value
		jhs	Skip	;if max (R7) is higher or same, jump to skip
		mov.w	R7,	-2(R5)

Skip	dec.w	R6
		jnz	Loop
		pop	R7
		pop	R6
		pop	R5

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
            
