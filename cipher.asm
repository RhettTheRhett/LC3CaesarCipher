.ORIG x3000

BR start  ; Branch to the start routine.

newln:   .STRINGZ "\n"
msg0:    .stringz "Welcome!\n"
msg1:    .STRINGZ "If you want to encrypt your message, type: E\nIf you want to decrypt your message, type: D\n"
msg2:    .STRINGZ "Enter the shift you want (1 - 9).\n"
msg3:    .STRINGZ "Please enter a message that is no more than 20 lower case characters; when done press Enter.\n"

; Prints out the instructions to the user and reads some user input.
start:
  LEA R0, msg0      ; Load address of message0 into R0.
  PUTS              ; Print welcome message.
  
  LEA R0, msg1      ; Load address of message1 into R0.
  PUTS 

  IN                ; Read user input into R0.
  ADD R3, R0, #0    ; Copy R0 to R3 (stored for later use).

  LEA R0, newln     ; Load address of newline into R0.
  PUTS              ; Print newline.

  LEA R0, msg2      ; Load address of message2 into R0.
  PUTS              ; Print message2.

  IN                ; Read user input into R0.
  LEA R0, newln     ; Load address of newline into R0.
  LEA R1, neg48     ; Load address of neg48 into R1.
  LDR R1, R1, #0    ; Load contents of neg48 into R1 (R1 now holds -48).
  ADD R2, R0, R1    ; Subtract 48 from the ASCII value and store in R2.

  PUTS              ; Print newline.

  LEA R0, msg3      ; Load address of message3 into R0.
  PUTS              ; Print message3.

  LEA R4, array     ; Load starting point address of array.
  AND R1, R1, #0    ; Initialize R1 to zero.


input:
  IN                ; Read in a single character to R0.
  ADD R5, R0, #-10  ; Subtract 10 because enter key is 10.
  BRz checkChar     ; If zero, branch to checkChar routine.
  STR R0, R4, #0    ; Store char in array.
  ADD R4, R4, #1    ; Increment index of array.
  ADD R1, R1, #1    ; Increment input counter.
  BR input          ; Unconditional branch to input.

checkChar:
  LEA R6, neg69     ; Load address of neg69 into R6.
  LDR R6, R6, #0    ; Load contents of neg69 into R6 (R6 now holds -69).
  ADD R0, R3, R6    ; Add -69 to the value in R3, to check if it's 'E'.
  BRz encrypt       ; If zero, branch to encrypt.
  LEA R6, neg68     ; Load address of neg68 into R6.
  LDR R6, R6, #0    ; Load contents of neg68 into R6 (R6 now holds -68).
  ADD R0, R3, R6    ; Add -68 to the value in R3, to check if it's 'D'.
  BRz decrypt       ; If zero, branch to decrypt.

encrypt:
  LEA R4, array     ; Load (starting) address of array into R4.
  ADD R5, R1, #0    ; Copy # of characters in message to R5, to use as counter.

encryptLoop:
  LDR R0, R4, #0    ; Load contents at array index into R0.
  ADD R0, R0, R2    ; Add the shift value to the character.
  STR R0, R4, #0    ; Store the encrypted char in the array (overwrite).
  ADD R4, R4, #1    ; Increment array index.
  ADD R5, R5, #-1   ; Decrement counter.
  BRp encryptLoop   ; If positive, loop.
  BR output         ; Else done. Branch to output.

decrypt:
  LEA R4, array     ; Load (starting) address of array into R4.
  ADD R5, R1, #0    ; Copy # of characters in message to R5, to use as counter.

decryptLoop:
  LDR R0, R4, #0    ; Load contents at array index into R0.
  NOT R2, R2        ; Invert the shift value (to subtract during decryption).
  ADD R2, R2, #1    ; Add 1 to make it negative (for subtraction).
  ADD R0, R0, R2    ; Subtract the shift value from the character.
  STR R0, R4, #0    ; Store the decrypted char in the array (overwrite).
  ADD R4, R4, #1    ; Increment array index.
  ADD R5, R5, #-1   ; Decrement counter.
  BRp decryptLoop   ; If positive, loop.
  BR output         ; Else done. Branch to output.

output:
  LEA R4, array     ; Load (starting) address of array.

outputLoop:
  LDR R0, R4, #0    ; Load contents of address at array index into R0.
  OUT               ; Print character.
  ADD R4, R4, #1    ; Increment array index.
  ADD R1, R1, #-1   ; Decrease counter.
  BRp outputLoop    ; If positive, loop.

HALT               ; Halt execution.

array:  .BLKW 20    ; Array of size 20 for storing input message.
neg48:  .FILL #-48  ; Constant for converting numbers from ASCII to decimal.
neg69:  .FILL #-69  ; Constant for the inverse of 'E'.
neg68:  .FILL #-68  ; Constant for the inverse of 'D'.
pos20:  .FILL #20   ; Constant used as loop counter.

.END