ORG 100h
LEA SI, k
MOV AH, 00h
LODSB
MOV BL, 02h
DIV BL
CMP AH, 00h
JE print2
JMP check3

print2:
    LEA SI, MESSAGE2
    MOV CX, 32
    CALL print
    JMP check3

check3:
    LEA SI, k
    MOV AH, 00h
    LODSB
    MOV BL, 03h
    DIV BL
    CMP AH, 00h
    JE print3
    JMP check5
 
print3:
    LEA SI, MESSAGE3
    MOV CX, 32
    CALL print
    JMP check5 

check5: 
    LEA SI, k
    MOV AH, 00h
    LODSB
    MOV BL, 05h
    DIV BL
    CMP AH, 00h
    JE print5
    JMP check10

print5:
    LEA SI, MESSAGE5
    MOV CX, 32
    CALL print
    JMP check10

check10:
    LEA SI, k
    MOV AH, 00h
    LODSB
    MOV BL, 0Ah
    DIV BL
    CMP AH, 00h
    JE print10
    JMP finish
    
print10:
    LEA SI, MESSAGE10
    MOV CX, 33
    CALL print
    JMP finish

print PROC
    MOV AH, 0Eh
    GO: LODSB
        INT 10H
        LOOP GO
    RET
print ENDP

finish:
RET

k DB 10
MESSAGE2 DB 'The number can be divided by 2', 13, 10
MESSAGE3 DB 'The number can be divided by 3', 13, 10
MESSAGE5 DB 'The number can be divided by 5', 13, 10
MESSAGE10 DB 'The number can be divided by 10', 13, 10