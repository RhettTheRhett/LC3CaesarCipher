;=========================================================
; Program: Caesar Cipher (Encrypt/Decrypt)
; Author:  Rhett Palmer
; Purpose: Prompts the user for encrypt or decrypt choice,
;          a shift value (1–9), and a message of up to 20
;          lowercase letters. Performs Caesar cipher and
;          prints result.
;=========================================================

.ORIG x3000

; ----------------------
; Strings 
; ----------------------
newln:   .STRINGZ "\n"
msg0:    .STRINGZ "Welcome!\n"
msg1:    .STRINGZ "If you want to encrypt your message, type: E or e\nIf you want to decrypt your message, type: D or d\n"
msg2:    .STRINGZ "Enter the shift you want (1 - 9).\n"
msg3:    .STRINGZ "Please enter a message that is no more than 20 lower case characters; when done press Enter.\n"

; ----------------------
; Program starts here
; ----------------------
start:
  ; Print welcome message
  LEA R0, msg0
  PUTS

  ; Print encrypt/decrypt instructions
  LEA R0, msg1
  PUTS

  ; Read encrypt/decrypt choice
  IN
  ADD R3, R0, #0      ; Save user choice in R3

  ; Print newline
  LEA R0, newln
  PUTS

  ; Ask for shift amount
  LEA R0, msg2
  PUTS

  ; Read shift (ASCII digit)
  IN
  LD R1, neg48        ; R1 = -48
  ADD R2, R0, R1      ; Convert ASCII to decimal shift (store in R2)

  ; Print newline
  LEA R0, newln
  PUTS

  ; Ask for message
  LEA R0, msg3
  PUTS

  ; Setup for message input
  LEA R4, array       ; R4 = start of array
  AND R1, R1, #0      ; R1 = 0 (character counter)

; ----------------------
; Input loop
; ----------------------
inputLoop:
  IN                  ; Get char
  ADD R5, R0, #-10    ; Compare with Enter (x0A)
  BRz checkChar       ; If Enter, branch to checkChar
  STR R0, R4, #0      ; Store character in array
  ADD R4, R4, #1      ; Advance pointer
  ADD R1, R1, #1      ; Count characters
  BR inputLoop        ; Repeat

; ----------------------
; Check if encrypt or decrypt
; ----------------------
checkChar:
  LD R6, neg69        ; Load -69 ('E')
  ADD R0, R3, R6
  BRz encrypt

  LD R6, neg101       ; Load -101 ('e')
  ADD R0, R3, R6
  BRz encrypt

  LD R6, neg68        ; Load -68 ('D')
  ADD R0, R3, R6
  BRz decrypt

  LD R6, neg100       ; Load -100 ('d')
  ADD R0, R3, R6
  BRz decrypt

; ----------------------
; Encrypt loop
; ----------------------
encrypt:
  LEA R4, array       ; Reset pointer
  ADD R5, R1, #0      ; Copy character count

encryptLoop:
  LDR R0, R4, #0      ; Load char
  ADD R0, R0, R2      ; Add shift
  STR R0, R4, #0      ; Store back
  ADD R4, R4, #1      ; Next char
  ADD R5, R5, #-1     ; Decrement counter
  BRp encryptLoop
  BR output           ; Done → print

; ----------------------
; Decrypt loop
; ----------------------
decrypt:
  LEA R4, array       ; Reset pointer
  ADD R5, R1, #0      ; Copy character count

decryptLoop:
  LDR R0, R4, #0      ; Load char
  NOT R6, R2          ; R6 = -R2
  ADD R6, R6, #1
  ADD R0, R0, R6      ; Subtract shift
  STR R0, R4, #0      ; Store back
  ADD R4, R4, #1      ; Next char
  ADD R5, R5, #-1     ; Decrement counter
  BRp decryptLoop
  BR output           ; Done → print

; ----------------------
; Output loop
; ----------------------
output:
  LEA R4, array       ; Reset pointer

outputLoop:
  LDR R0, R4, #0      ; Load char
  OUT                 ; Print it
  ADD R4, R4, #1      ; Next char
  ADD R1, R1, #-1     ; Decrement counter
  BRp outputLoop
  HALT

; ----------------------
; Data
; ----------------------
array:   .BLKW 20     ; Reserve 20 words for input
shiftVal:.BLKW 1      ; Not used, but could store shift

neg48:   .FILL #-48   ; ASCII offset for digits
neg69:   .FILL #-69   ; For 'E'
neg101:  .FILL #-101  ; For 'e'
neg68:   .FILL #-68   ; For 'D'
neg100:  .FILL #-100  ; For 'd'

.END
