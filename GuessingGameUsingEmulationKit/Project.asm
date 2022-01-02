ORG 100h

#start=Emulation_Kit.exe#

SET_ASCII_LCD_DISPLAY:
MOV DX, 2040h
LEA SI, YOUWINMSG
FIRST_MSG:
LODSB
CMP AL, 0
JNE PRINT_FIRST_MSG
MOV DX, 2050h
LEA SI, TOTALGUESSMSG
SECOND_MSG:
LODSB
CMP AL, 0
JNE PRINT_SECOND_MSG
JMP SET_SEVEN_SEGMENT_DISPLAY

PRINT_FIRST_MSG:
OUT DX, AL
INC DX
JMP FIRST_MSG


PRINT_SECOND_MSG:
OUT DX, AL
INC DX
JMP SECOND_MSG

SET_SEVEN_SEGMENT_DISPLAY:
MOV DX, 2030h
LEA SI, U
LODSB
OUT DX, AL

MOV DX, 2035h
LEA SI, C
LODSB
OUT DX, AL

MOV DX, 2031h
LEA SI, DASH
LODSB
OUT DX, AL
MOV DX, 2036h
OUT DX, AL
MOV DX, offset FIRSTMSG
MOV AH, 9
INT 21h
JMP WAIT_FOR_KEY

PRINT_OUT_MSG:
MOV DX, offset MSG
MOV AH, 9
INT 21h
JMP WAIT_FOR_KEY

WAIT_FOR_KEY:
MOV AH, 1
INT 16h
JZ  WAIT_FOR_KEY

MOV AH, 0
INT 16h

MOV AH, 0Eh
INT 10h

CMP AL, 30h
JL ERROR_AND_WAIT

CMP AL, 3Ah
JNL ERROR_AND_WAIT

MOV AH, 00
PUSH AX
INT 1Ah

MOV AH, 00
MOV AL, DL
MOV BL, 0Ah
DIV BL
MOV AL, AH
MOV BL, AL
CALL PRINT_C_NUMBER
POP AX
SUB AL, 30h
PUSH AX
PUSH BX
CALL PRINT_U_NUMBER
POP BX
POP AX
CMP BL, AL
JE INCREMENT_TRUE_GUESS
LEA BX, TOTALGUESS
INC [BX]
CALL PRINT_LCD_DISPLAY_OUTPUT
JMP PRINT_OUT_MSG

ERROR_AND_WAIT:
MOV DX, offset ERROR
MOV AH, 9
INT 21H
JMP WAIT_FOR_KEY

PRINT_C_NUMBER PROC
    PUSH AX
    MOV DX, 2037h
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERS[SI]
    OUT DX, AL
    POP AX
    RET
PRINT_C_NUMBER ENDP

PRINT_U_NUMBER PROC
    PUSH AX
    MOV DX, 2032h
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERS[SI]
    OUT DX, AL
    POP AX
    RET
PRINT_U_NUMBER ENDP

PRINT_LCD_DISPLAY_OUTPUT PROC
    MOV DX, 205Dh
    LEA SI, TOTALGUESS
    LODSB
    MOV CX, 00h
    JMP GET_CHARACTERS_TO_STACK_OF_TOTAL_GUESS
    PRINT_CHARACTERS_OF_TOTAL_GUESS:
    POP AX
    MOV AL, AH
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERSTRINGS[SI]
    OUT DX, AL
    INC DX
    LOOP PRINT_CHARACTERS_OF_TOTAL_GUESS
    MOV DX, 2049h
    LEA SI, TRUEGUESS
    LODSB
    JMP GET_CHARACTERS_TO_STACK_OF_TRUE_GUESS
    PRINT_CHARACTERS_OF_TRUE_GUESS:
    POP AX
    MOV AL, AH
    MOV AH, 00h
    MOV SI, AX
    MOV AL, NUMBERSTRINGS[SI]
    OUT DX, AL
    INC DX
    LOOP PRINT_CHARACTERS_OF_TRUE_GUESS
    RET     
PRINT_LCD_DISPLAY_OUTPUT ENDP

GET_CHARACTERS_TO_STACK_OF_TOTAL_GUESS:
MOV BL, 0Ah
MOV AH, 00h
DIV BL
PUSH AX
INC CX
CMP AL, 00h
JNE GET_CHARACTERS_TO_STACK_OF_TOTAL_GUESS
JE PRINT_CHARACTERS_OF_TOTAL_GUESS

GET_CHARACTERS_TO_STACK_OF_TRUE_GUESS:
MOV BL, 0Ah
MOV AH, 00h
DIV BL
PUSH AX
INC CX
CMP AL, 00h
JNE GET_CHARACTERS_TO_STACK_OF_TRUE_GUESS
JE PRINT_CHARACTERS_OF_TRUE_GUESS
    
INCREMENT_TRUE_GUESS:
LEA BX, TOTALGUESS
INC [BX]
LEA BX, TRUEGUESS
INC [BX]
CALL PRINT_LCD_DISPLAY_OUTPUT
JMP PRINT_OUT_MSG
    
EXIT:
RET

TOTALGUESS DB 0 ; 205Dh

TRUEGUESS DB 0 ; 2040h

NUMBERSTRINGS DB "0123456789"

DASH DB 01000000b

U DB 00111110b

C DB 00111001b

NUMBERS	DB 00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b

YOUWINMSG DB "YOU WIN : 0", 0
TOTALGUESSMSG DB "TOTAL GUESS : 0", 0
FIRSTMSG DB "Enter a number between 0-9: ", "$"
MSG DB 0Dh, 0Ah, "Enter a number between 0-9: ", "$"
ERROR DB 0Dh, 0Ah, "Your input is not correct please enter a number between 0-9: ", "$"