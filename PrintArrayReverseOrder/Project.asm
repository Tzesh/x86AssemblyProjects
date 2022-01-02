ORG 100h

LEA SI, a ; get the address of array
LEA DI, b
MOV CX, length ; set the length of array for loop
MOV AH, 0Eh ; set display mode

m:
LODSB ; AL = DS:[SI]
PUSH AX ; AX to the stack
INT 10h ; display AX
loop m ; loop

; at the end of loop
; ceng will be displayed

MOV CX, length ; set cx again to the size

k:
POP AX ; get AX from the stack
STOSB ; DS:[SI] = AL
INT 10h ; display AX
loop k ; loop

; at the end of loop
; gnec will be displayed
; and our initial stack will be reversed as
; 'g' 'n' 'e' 'c'              

RET
a DB 'c','e','n','g' ; initial stack
b DB 'c','e','n','g' ; initial stack
length EQU 4 ; initial length