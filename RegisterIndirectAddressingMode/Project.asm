; Write a program that writes 5 numbers to memory by using
; Register Indirect Addressing. Store your numbers at
; memory addresses from 2000h to 2004h

; If we want to store 5 numbers into memory by using register indirect addressing
; Then we should pass our values firstly to registers afterwards to memory

org 100h

; We know that physical address on memory calculated by: DS (Segment Address) * 10H + Offset Address
; Since we must address these values into in order 2000H to 2004H then we should change DS as 0100H
; And set Offset Address as 1000H for initial MOV operation
MOV AX, 0100H
MOV DS, AX

; For instance memory physical address = (0100H * 10H) + 1000H = 2000H for [DX]
MOV AL, 01H
MOV AH, 02H

; For register indirect addressing we should use BP, BX, DI, and SI registers to hold memory Offset Address
MOV BX, 1000H
MOV [BX], AX

; Same thing applies here
MOV AL, 03H
MOV AH, 04H
MOV BX, 1002H
MOV [BX], AX

; And as a final step we must move 05H into 2004H = (0100H * 10H) + 1004H
MOV AL, 05H
MOV BX, 1004H
MOV [BX], AL

ret