ORG 100h

#start=Emulation_Kit.exe#

MOV DX, offset MSG
MOV AH, 9
INT 21h
MOV DX, 2000h
MOV BX, 0

WAIT_FOR_KEY:
MOV     AH, 1 ; GETTING THE KEY VALUE WITH ECHO
INT     16h
JZ      WAIT_FOR_KEY

MOV     AH, 0 ; GETTING THE KEY VALUE
INT     16h

MOV     AH, 0Eh ; PRINT OUT
INT     10h

CMP     AL, 0Dh ; ENTER
JZ      JUMP_TO_NEXT

SUB AL, 41h
MOV BL, 05h
MUL BL
MOV BX, AX
PUSH BX

LEA BX, Limit
CMP [BX], 1
JE JUMP_TO_NEXT_WITH_LIMIT
DEC [BX]
JMP WAIT_FOR_KEY

JUMP_TO_NEXT_WITH_LIMIT:
DEC [BX]
JMP JUMP_TO_NEXT


JUMP_TO_NEXT:
LEA BX, Limit
MOV CL, [BX]
INC [BX]
MOV AH, 0
MOV AL, 7
SUB AL, CL
CMP AL, 0
JL EXIT
MOV CL, 5
MUL CL
MOV DX, 2000h
ADD DX, AX
POP BX
MOV SI, 0
MOV CX, 5

NEXT:
	MOV AL, Dots[BX][SI]
	OUT DX, AL
	INC SI
	INC DX

	CMP SI, 5
	LOOPNE NEXT
	
	JMP JUMP_TO_NEXT
RET

EXIT:
RET

Limit DB 8


Dots	DB	01111110b, 00010001b, 00010001b, 00010001b, 01111110b  ; A
	    DB	01111111b, 01001001b, 01001001b, 01001001b, 00110110b  ; B
	    DB	00111110b, 01000001b, 01000001b, 01000001b, 00100010b  ; C
	    DB	01111111b, 01000001b, 01000001b, 00100010b, 00011100b  ; D
	    DB	01111111b, 01001001b, 01001001b, 01001001b, 01000001b  ; E
	    DB	01111111b, 00001001b, 00001001b, 00001001b, 00000001b  ; F
	    DB	00111110b, 01000001b, 01001001b, 01001001b, 01111010b  ; G
	    DB	01111111b, 00001000b, 00001000b, 00001000b, 01111111b  ; H
	    DB	00000000b, 00000000b, 01111111b, 00000000b, 00000000b  ; I
	    DB	00100000b, 01000000b, 01000000b, 01000000b, 00111111b  ; J
	    DB	01111111b, 00001000b, 00010100b, 00100010b, 01000001b  ; K 
	    DB	01111111b, 01000000b, 01000000b, 01000000b, 01000000b  ; L
	    DB	01111111b, 00000010b, 00000100b, 00000010b, 01111111b  ; M
	    DB	01111111b, 00000010b, 00001000b, 00100000b, 01111111b  ; N 
	    DB	00111110b, 01000001b, 01000001b, 01000001b, 00111110b  ; O
	    DB	01111111b, 00001001b, 00001001b, 00001001b, 00000110b  ; P
	    DB	00111110b, 01000001b, 01000001b, 01100001b, 01111110b  ; Q     
	    DB	01111111b, 00001001b, 00001001b, 00001001b, 01110110b  ; R
	    DB	00100110b, 01001001b, 01001001b, 01001001b, 00110010b  ; S
	    DB	00000001b, 00000001b, 01111111b, 00000001b, 00000001b  ; T
	    DB	00111111b, 01000000b, 01000000b, 01000000b, 00111111b  ; U
	    DB	00011111b, 00100000b, 01000000b, 00100000b, 00011111b  ; V
	    DB	01111111b, 00100000b, 00010000b, 00100000b, 01111111b  ; W 
	    DB	01100011b, 00010100b, 00001000b, 00010100b, 01100011b  ; X 
	    DB	00000001b, 00000010b, 01111100b, 00000010b, 00000001b  ; Y 
	    DB	01100001b, 01010001b, 01001001b, 01000101b, 01000011b  ; Z

MSG  db "You can type 8 characters at most", 0Dh,0Ah
     db "You can either type all 8 characters then program will print them in dot matrix", 0Dh,0Ah
     db "Or you can hit the enter when you're done with typing", 0Dh,0Ah
     db "You may hear a beep", 0Dh,0Ah
     db "    when buffer is overflown.", 0Dh,0Ah, "$"