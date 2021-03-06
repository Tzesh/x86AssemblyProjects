ORG 100h

#start=Emulation_Kit.exe#

INITIALIZE:
MOV DX, offset MSG
MOV AH, 9
INT 21h
JMP DRAW_MAZE

DRAW_MAZE:
MOV DX, 2000h
JMP NEXT

NEXT:
MOV AL, MAZE[BX]
OUT DX, AL
INC DX
INC BX

CMP BX, 40
JL NEXT
JE WAIT_FOR_KEY

WAIT_FOR_KEY:
LEA SI, X_COORDINATE
LODSB
MOV BH, 00h
MOV BL, AL
MOV DH, 00h
MOV DL, AL
ADD DX, CONSTANT
LEA SI, CURSOR
LODSB
OR AL, MAZE[BX]
OUT DX, AL
MOV AL, MAZE[BX]
OUT DX, AL
MOV AH, 1
INT 16h
JZ WAIT_FOR_KEY

MOV AH, 0
INT 16h

CMP AL, 00h
JNE WAIT_FOR_KEY

; '->' AH : 4Dh
CMP AH, 4Dh
JE GO_RIGHT
; '<-' AH : 4Bh
CMP AH, 4Bh
JE GO_LEFT
; '^'  AH : 48h
CMP AH, 48h
JE GO_UP
; '!^' AH : 50h
CMP AH, 50h
JE GO_DOWN

JMP WAIT_FOR_KEY

GO_RIGHT:
LEA SI, X_COORDINATE
LODSB
INC AL
CMP AL, 27h
JG WAIT_FOR_KEY
MOV AH, 00h
MOV BX, AX
MOV CH, MAZE[BX]
LEA BX, CURSOR
MOV CL, [BX]
MOV BL, CH
OR BL, CL
CMP BL, CH
JNG WAIT_FOR_KEY
LEA BX, X_COORDINATE
INC [BX]
JMP WAIT_FOR_KEY 

GO_LEFT:
LEA SI, X_COORDINATE
LODSB
DEC AL
CMP AL, 00h
JL WAIT_FOR_KEY
MOV AH, 00h
MOV BX, AX
MOV CH, MAZE[BX]
LEA BX, CURSOR
MOV CL, [BX]
MOV BL, CH
OR BL, CL
CMP BL, CH
JNG WAIT_FOR_KEY
LEA BX, X_COORDINATE
DEC [BX]
JMP WAIT_FOR_KEY

GO_UP:
LEA SI, X_COORDINATE
LODSB
MOV AH, 00h
MOV BX, AX
MOV CH, MAZE[BX]
LEA BX, CURSOR
MOV CL, [BX]
CMP CL, 0000001B
JE WAIT_FOR_KEY
SHR CL, 1
MOV BL, CH
OR BL, CL
CMP BL, CH
JNG WAIT_FOR_KEY
LEA BX, CURSOR
MOV [BX], CL
JMP WAIT_FOR_KEY

GO_DOWN:
LEA SI, X_COORDINATE
LODSB
MOV AH, 00h
MOV BX, AX
MOV CH, MAZE[BX]
LEA BX, CURSOR
MOV CL, [BX]
CMP CL, 1000000B
JE WAIT_FOR_KEY
SHL CL, 1
MOV BL, CH
OR BL, CL
CMP BL, CH
JNG WAIT_FOR_KEY
LEA BX, CURSOR
MOV [BX], CL
JMP WAIT_FOR_KEY

CONSTANT EQU 2000h

CURSOR DB 0001000B

X_COORDINATE DB 0 ; Min: 0 - Max: 27

MSG  DB "You can use arrow keys to move on the maze", 0Dh,0Ah
     DB "You can only move on unswitched leds", 0Dh,0Ah, "$"

MAZE DB 0000000B, 0000000B, 0000000B, 0000000B, 0000000B, 1110111B, 1000001B, 1111001B, 1111011B, 1000001B, 1011111B, 1011111B, 1010001B, 1010101B, 1000101B, 1111101B, 1000101B, 1010001B, 1010101B, 1010101B, 1100011B, 1000001B, 1011101B, 1011101B, 1011101B, 1001001B, 1000101B, 1011101B, 1100001B, 1101111B, 1000001B, 1010101B, 1010101B, 1010101B, 1111101b, 0000000B, 0000000B, 0000000B, 0000000B, 0000000B