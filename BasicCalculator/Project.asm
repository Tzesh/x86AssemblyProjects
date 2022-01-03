ORG 100h

#start=Emulation_Kit.exe#

FIRST_OPERAND:
MOV DX, offset FOMSG
MOV AH, 9
INT 21h
WAIT_FIRST_OPERAND:
MOV AH, 1
INT 16h
JZ WAIT_FIRST_OPERAND

MOV AH, 0
INT 16h

CMP AL, 0Dh
JE SET_FIRST_OPERAND

CMP AL, 30h
JL WAIT_FIRST_OPERAND

CMP AL, 3Ah
JNL WAIT_FIRST_OPERAND

MOV AH, 0Eh
INT 10h

SUB AL, 30h

MOV AH, 00h
PUSH AX

LEA BX, COUNT
INC [BX]

JMP WAIT_FIRST_OPERAND

SECOND_OPERAND:
MOV DX, offset SOMSG
MOV AH, 9
INT 21h
LEA BX, COUNT
MOV [BX], 00h
LEA BX, LIMIT
MOV [BX], 00h
WAIT_SECOND_OPERAND:
MOV AH, 1
INT 16h
JZ WAIT_SECOND_OPERAND

MOV AH, 0
INT 16h

CMP AL, 0Dh
JE SET_SECOND_OPERAND

CMP AL, 30h
JL WAIT_SECOND_OPERAND

CMP AL, 3Ah
JNL WAIT_SECOND_OPERAND

MOV AH, 0Eh
INT 10h

SUB AL, 30h

MOV AH, 00h
PUSH AX

LEA BX, COUNT
INC [BX]

JMP WAIT_SECOND_OPERAND

SET_FIRST_OPERAND:
LEA SI, COUNT
LODSB
MOV CL, AL
POP AX
LEA BX, FIRSTOPERAND
ADD [BX], AL
LEA BX, LIMIT
INC [BX]
MOV CH, [BX]
LEA BX, FIRSTOPERAND
FIRST_OPERAND_LOOP:
CMP CL, CH
JE SECOND_OPERAND
MOV AL, 0Ah
MOV AH, 00h
MOV DL, CH
DEC DL
CMP DL, 00h
JE FIRST_OPERAND_LOOP_CONTINUE
GET_POWER_FIRST_OPERAND:
MUL AL
DEC DL
CMP DL, 00h
JNE GET_POWER_FIRST_OPERAND
FIRST_OPERAND_LOOP_CONTINUE:
MOV CH, AL
POP AX
MUL CH
ADD [BX], AL
LEA BX, LIMIT
INC [BX]
MOV CH, [BX]
LEA BX, FIRSTOPERAND
JMP FIRST_OPERAND_LOOP

SET_SECOND_OPERAND:
LEA SI, COUNT
LODSB
MOV CL, AL
POP AX
LEA BX, SECONDOPERAND
ADD [BX], AL
LEA BX, LIMIT
INC [BX]
MOV CH, [BX]
LEA BX, SECONDOPERAND
SECOND_OPERAND_LOOP:
CMP CL, CH
JE OPERATOR
MOV AL, 0Ah
MOV AH, 00h
MOV DL, CH
DEC DL
CMP DL, 00h
JE SECOND_OPERAND_LOOP_CONTINUE
GET_POWER_SECOND_OPERAND:
MUL AL
DEC DL
CMP DL, 00h
JNE GET_POWER_SECOND_OPERAND
SECOND_OPERAND_LOOP_CONTINUE:
MOV CH, AL
POP AX
MUL CH
ADD [BX], AL
LEA BX, LIMIT
INC [BX]
MOV CH, [BX]
LEA BX, SECONDOPERAND
JMP SECOND_OPERAND_LOOP

OPERATOR:
MOV DX, offset OMSG
MOV AH, 9
INT 21h
WAIT_FOR_OPERATOR:
MOV AH, 1
INT 16h
JZ WAIT_FOR_OPERATOR

MOV AH, 0
INT 16h

CMP AL, 0Dh
JE SET_SECOND_OPERAND

MOV AH, 0Eh
INT 10h

;2B +
CMP AL, 2Bh
JE SUMMATION
;2D -
CMP AL, 2Dh
JE SUBSTITUTION
;2A *
CMP AL, 2Ah
JE MULTIPLICATION
;2F /
CMP AL, 2Fh
JE DIVISION

MOV DX, offset ERROR
MOV AH, 9
INT 21h
JMP OPERATOR

SUMMATION:
LEA SI, FIRSTOPERAND
LODSB
MOV CH, AL
LEA SI, SECONDOPERAND
LODSB
MOV CL, AL
MOV BH, 00h
MOV BL, 00h
ADD BL, CL
ADD BL, CH
CALL PRINT_LCD_DISPLAY_OUTPUT
RET

SUBSTITUTION:
LEA BX, OPERATORINDEX
MOV [BX], 1
LEA SI, FIRSTOPERAND
LODSB
MOV CH, AL
LEA SI, SECONDOPERAND
LODSB
MOV CL, AL
MOV BH, 00h
MOV BL, 00h
ADD BL, CH
SUB BL, CL
CALL PRINT_LCD_DISPLAY_OUTPUT
RET

MULTIPLICATION:
LEA BX, OPERATORINDEX
MOV [BX], 2
LEA SI, FIRSTOPERAND
LODSB
MOV CH, AL
LEA SI, SECONDOPERAND
LODSB
MOV CL, AL
MOV BH, 00h
MOV BL, 00h
MUL CH
MOV BX, AX
CALL PRINT_LCD_DISPLAY_OUTPUT
RET

DIVISION:
LEA BX, OPERATORINDEX
MOV [BX], 3
LEA SI, FIRSTOPERAND
LODSB
MOV CH, AL
LEA SI, SECONDOPERAND
LODSB
MOV CL, AL
MOV BH, 00h
MOV BL, 00h
MOV AH, 00h
MOV AL, CH
DIV CL
MOV BX, AX
CALL PRINT_LCD_DISPLAY_OUTPUT
RET

PRINT_LCD_DISPLAY_OUTPUT PROC
    MOV DX, 2040h
    MOV AL, CH
    PUSH CX
    PUSH BX
    MOV CX, 00h
    JMP GET_CHARACTERS_TO_STACK_FIRST_OPERAND
    PRINT_FIRST_OPERAND:
    POP AX
    MOV AL, AH
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERSTRINGS[SI]
    OUT DX, AL
    INC DX
    LOOP PRINT_FIRST_OPERAND
    LEA SI, OPERATORINDEX
    LODSB
    MOV AH, 00h
    MOV SI, AX
    MOV AL, OPERATORS[SI]
    OUT DX, AL
    INC DX
    POP BX
    POP CX
    MOV AL, CL
    PUSH CX
    PUSH BX
    MOV CX, 00h
    JMP GET_CHARACTERS_TO_STACK_SECOND_OPERAND
    PRINT_SECOND_OPERAND:
    POP AX
    MOV AL, AH
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERSTRINGS[SI]
    OUT DX, AL
    INC DX
    LOOP PRINT_SECOND_OPERAND
    POP BX
    POP CX
    MOV AL, OPERATORS[4]
    OUT DX, AL
    INC DX
    PUSH CX
    PUSH BX
    MOV CX, 00h
    MOV AL, BL
    JMP GET_CHARACTERS_TO_STACK_RESULT
    PRINT_RESULT:
    POP AX
    MOV AL, AH
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERSTRINGS[SI]
    OUT DX, AL
    INC DX
    LOOP PRINT_RESULT
    POP BX
    POP CX
    RET     
PRINT_LCD_DISPLAY_OUTPUT ENDP

GET_CHARACTERS_TO_STACK_FIRST_OPERAND:
MOV BL, 0Ah
MOV AH, 00h
DIV BL
PUSH AX
INC CX
CMP AL, 00h
JNE GET_CHARACTERS_TO_STACK_FIRST_OPERAND
JE PRINT_FIRST_OPERAND

GET_CHARACTERS_TO_STACK_SECOND_OPERAND:
MOV BL, 0Ah
MOV AH, 00h
DIV BL
PUSH AX
INC CX
CMP AL, 00h
JNE GET_CHARACTERS_TO_STACK_SECOND_OPERAND
JE PRINT_SECOND_OPERAND

GET_CHARACTERS_TO_STACK_RESULT:
MOV BL, 0Ah
MOV AH, 00h
DIV BL
PUSH AX
INC CX
CMP AL, 00h
JNE GET_CHARACTERS_TO_STACK_RESULT
JE PRINT_RESULT

  

EXIT:
RET

FIRSTOPERAND DB 00h
COUNT DB 00h
LIMIT DB 00h
SECONDOPERAND DB 00h
OPERATORINDEX DB 00h
NUMBERSTRINGS DB "0123456789"
OPERATORS DB "+", "-", "*", "/", "="
FOMSG DB "Enter first operand: ", "$"
SOMSG DB 0Dh, 0Ah, "Enter second operand: ", "$"
OMSG DB 0Dh, 0Ah, "Enter operator: ", "$"
ERROR DB 0Dh, 0Ah, "Unknown operator please enter operator: ", "$"