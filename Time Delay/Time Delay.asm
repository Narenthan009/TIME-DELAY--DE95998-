
		#include<p18f4550.inc>

lp_cnt 		set 0x01
lp_cnt1		set 0x02

			org 0x00
			goto start
			org 0x08
			retfie
			org 0x18
			retfie


; Subroutine to create 98m second delay with 20 MHz crystal 

  

dup_nop 	macro kk 
			variable i 

i=0  
			while i < kk 
			nop 

i+=1 
			endw 
			endm 

  

delay98ms 	movlw D'250' ; 98ms delay interval 
			movwf lp_cnt1,A ; 20MHz crystal 
			again1 movlw D'250' 			
			movwf lp_cnt,A 			
			again dup_nop D'5' 			
			decfsz lp_cnt,F,A 			
			bra again 			
			decfsz lp_cnt1,F,A 			
			bra again1 			
			return 

start 		bra delay98ms

			end 


;------------------------------------------------------------------
; HOW TO SOLVE THE CALCULATION PART !!!!
;------------------------------------------------------------------

; 98m second time delay with 20 MHz crystal
; Frequency = 20MHz,which means in 1s,there is 20M oscillations.
; Period,T:the time taken for 1 complete oscillation.
; 1 oscillation takes (0.05 micro sec)
; 1 instruction cycle takes 4 oscillations. (0.2 micro sec)

; 1 sec ----> 20,000,000 oscillations (20M)
; 1 oscillation ----> ? seconds
; 1 oscillation ----> 1/20M seconds
; 1 oscillation ----> 0.05 micro seconds

; 1 instruction cycle ----> 4 oscillation
; 1 instruction cycle ----> ? seconds
; 1 instruction cycle ----> (0.05 micro x 4)
; 1 instruction cycle ----> 0.2 micro seconds

; 1 instruction cycle ----> nop ----> 4 oscillation
; 0.2 micro sec x ? = 98ms ----> ? = 490,000 (490K)
; 490,000/250 = 1960 (Max value for PIC18 is 255 loops)
; 1960/250 = 8
; 8-3 = 5  (Minus 3 dup_nop instructions)
; D'250', D'250', D'5' 