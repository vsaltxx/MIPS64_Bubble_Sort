; Autor reseni: 					vsaltxx		
; Pocet cyklu k serazeni puvodniho retezce:		4348
; Pocet cyklu razeni sestupne serazeneho retezce:	4396
; Pocet cyklu razeni vzestupne serazeneho retezce: 	4348
; Pocet cyklu razeni retezce s vasim loginem:		
; Implementovany radici algoritmus: 			Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:         .asciiz "vitejte-v-inp-2023"   ; puvodni uvitaci retezec
; login:         .asciiz "vvttpnjiiee3220---"  	; sestupne serazeny retezec
; login:         .asciiz "---0223eeiijnpttvv"  	; vzestupne serazeny retezec
 login:          .asciiz "vsaltxx"            	; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text
main:

;---------------------------------------------------------------------------       
;--------- LENGTH ----------------------------------------------------------
;---------------------------------------------------------------------------

        	daddi $t0, r0, login 		; load address of login into $t0
        	daddi $t1, $t1, 0		; $t1 is the counter. set it to 0
        	
   count_chr:
   
   		lb $t2, 0($t0)			; Load the first byte from address in $t0
   		beqz $t2, bubble_sort		; if $t2 = 0 then go to label end
   		
   		daddi $t0, $t0, 1		; else increment the address
   		daddi $t1, $t1, 1 		; and increment the counter of course
   		b count_chr			; finally loop
   
     		; --- the length of the login is now stored in $t1 ---
        		       
        
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;--------- BUBBLE SORT -----------------------------------------------------
;---------------------------------------------------------------------------
  
  bubble_sort:
  
  	daddi $s0, r0, 0				; i
		
	daddi r4, r0, login
  	
      while_loop:
      	
      	daddi  $s1, r0, 1				; j
      	daddi   $t0, r0, login   			; load address of login into $t0	     	           
      	
          	for_loop:
          	
          		lb $t2, 0($t0)			; load the first char a[i-1] of the string to the $t2
          		lb $t3, 1($t0)			; next char a[i] to the $t3
          		
        		dsub $t4, $t3, $t2  		; $t4 = a[j] - a[j-1] --> if $t4 > 0 --> a[j] > a[j - 1] --> no swap
      		bgez $t4, no_swap
        		
        		; --- SWAP ---
        	
        		sb $t3, 0($t0)
        		sb $t2, 1($t0)
        		        		
        	
        	no_swap:
        	
        		daddi $t0, $t0, 1		; increment the address 
        		daddi $s1, $s1, 1		; j++

        		daddi $t5, r0, 1
			dsub $t5, $t1, $t5 		; $t5 = length - 1
      		dsub $t4, $t5, $s0			; $t4 = length - i - 1
      		dsub $t4, $t4, $s1			; j < length - i - 1

          		bgez $t4, for_loop  		; continue looping
      		
      		daddi $s0, $s0, 1			; i++      		
        		dsub $t4, $t1, $s0  		; $t4 = length - i --> for j := 0 to length
      		      		
         		bgez $t4, while_loop		; if $t4 > 0 --> continue looping
        	
        	        		       		        
        jal     print_string    ; vypis pomoci print_string - viz nize

        syscall 0   ; halt


print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address



