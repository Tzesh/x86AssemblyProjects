ORG 100h

LEA BX, str1
MOV AX, 0

compare1:
    CMP [BX], 0
    JE done1
    INC AX
    INC BX
    JMP compare1

done1:
    MOV DX, AX
    JMP count2

count2:
    LEA BX, str2
    MOV AX, 0

compare2:
    CMP [BX], 0
    JE done2
    INC AX
    INC BX
    JMP compare2

done2:
    CMP DX, AX
    JL doesNotContain
    JMP search
        
search:
    LEA SI, str2
    LODSB
    MOV AH, AL
    LEA SI, str1
    JMP compareByChar

compareByChar:
    LODSB
    CMP AL, 0
    JE doesNotContain
    CMP AH, AL
    JE compareByWord
    JMP compareByChar

 
compareByWord:
    PUSH AX
    PUSH SI
    LEA BX, str2
    JMP compareAndLoop

compareAndLoop:
    LODSB
    CMP AL, 0
    JE controlBX
    INC BX
    CMP [BX], 0
    JE contains
    CMP AL, [BX]
    JE compareAndLoop
    JNE returnToCompareByChar

controlBX:
    INC BX
    CMP AL, [BX]
    JE contains
    JMP returnToCompareByChar

returnToCompareByChar:
    POP SI
    POP AX
    JMP compareByChar

contains:
    LEA SI, str1
    CALL print
    LEA SI, str4
    CALL print
    LEA SI, str2
    CALL print
    RET
        
doesNotContain:
    LEA SI, str1
    CALL print
    LEA SI, str3
    CALL print
    LEA SI, str2
    CALL print
    RET
    
print PROC
    MOV AH, 0Eh
    GO: LODSB
        CMP AL, 0
        JE end
        INT 10H
        LOOP GO
    RET
print ENDP

end:
RET

str1 db 'MICROCOMPUTERS', 0
str2 db 'MICRO', 0
str3 db ' DOES NOT CONTAIN ', 0
str4 db ' CONTAINS ', 0