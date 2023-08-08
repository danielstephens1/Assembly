; A Simple Baseball Game

INCLUDE Irvine32.inc

.data
MenuPrompt	BYTE "		   M E N U", 0dh, 0ah
			BYTE 0dh, 0ah
			BYTE "		Play New Game (p)"	,0dh, 0ah
			BYTE "		Quit (q)"				,0dh, 0ah
			BYTE						0dh, 0ah
			BYTE "		Choose? "				,0


gamePrompt		BYTE "Type 3 numbers:"	,0
playPrompt		BYTE "p"				,0
quitPrompt		BYTE "q"				,0
strikePrompt	BYTE " strike(s) and "	,0
ballPrompt		BYTE " ball(s)"			,0
strikeoutP		BYTE "Strike out!!"		,0
winPrompt1		BYTE "It takes "		,0
winPrompt2		BYTE " times."			,0


caseTable BYTE 'p'
	DWORD play
EntrySize = ($ - caseTable)
	BYTE 'q'
	DWORD exitProgram
NumberOfEntries = ($ - caseTable) / EntrySize

comNum1			DWORD ?
comNum2			DWORD ?
comNum3			DWORD ?

guess1			DWORD ?
guess2			DWORD ?
guess3			DWORD ?
	
tryCount		DWORD 0
strikeCount		DWORD 0
ballCount		DWORD 0



.code
main proc
	call Clrscr
Menu:
	mov edx, OFFSET MenuPrompt
	call WriteString

getInput:
	call ReadChar

	cmp al, 'q'
	ja getInput
	cmp al, 'p'
	jb getInput

	call selectProcedure
	jc quit

	jmp Menu

quit: exit
main endp

;##########################################################
; Procedure to select p or q
selectProcedure proc
	push ebx
	push ecx
	mov ebx, OFFSET caseTable
	mov ecx, NumberOfEntries

L1:
	cmp al, [ebx]
	jne L2
	call NEAR PTR [ebx + 1]
	jmp L3

L2:
	add ebx, EntrySize
	loop L1

L3:
	pop ecx
	pop ebx

	ret

selectProcedure endp

; Procedures p and q
;##########################################################
; Procedure p
play proc
	
	mov edx, OFFSET playPrompt
	call WriteString
	call Crlf
	call Crlf

randomInt:
	call Randomize
	mov eax, 10

	call Randomize
	mov ecx, 3

again:
	mov eax, 10
	call RandomRange
	push eax
	
	loop again
	call Crlf

	pop eax
	mov comNum1, eax
	pop eax
	mov comNum2, eax
	pop eax
	mov comNum3, eax

guessInput:
	mov edx, OFFSET gamePrompt
	call WriteString
	call Crlf

	call ReadDec
	mov guess1, eax
	
	call ReadDec
	mov guess2, eax
	
	call ReadDec
	mov guess3, eax
	call Crlf

	add tryCount, 1



; guess #1
sCheck1:
	mov eax, guess1
	cmp eax, comNum1
	je strikeCounter1
;check for ball
fBCheck1:
	cmp eax, comNum2
	je fballCounter
fBCheck2:
	cmp eax, comNum3
	je fballCounter

; guess #2
sCheck2:
	mov eax, guess2
	cmp eax, comNum2
	je strikeCounter2
;check for ball
sBCheck1:
	cmp eax, comNum1
	je sballCounter
sBCheck2:
	cmp eax, comNum3
	je sballCounter


; guess #3
sCheck3:
	mov eax, guess3
	cmp eax, comNum3
	je strikeCounter3
;check for ball
tBCheck1:
	cmp eax, comNum1
	je tballCounter
tBCheck2:
	cmp eax, comNum2
	je tballCounter

	jmp winCheck

;first ball counter
fballCounter:
	add ballCount, 1
	jmp sCheck2

;second ball counter
sballCounter:
	add ballCount, 1
	jmp sCheck3

;third ball counter
tballCounter:
	add ballCount, 1
	jmp winCheck


strikeCounter1:
	add strikeCount, 1
	jmp sCheck2

strikeCounter2:
	add strikeCount, 1
	jmp sCheck3

strikeCounter3:
	add strikeCount, 1
	jmp winCheck


winCheck:

	mov eax, strikeCount
	
	cmp eax, 3
	je winMessage

	call WriteDec
	mov edx, OFFSET strikePrompt
	call WriteString
	mov eax, ballCount
	call WriteDec
	mov edx, OFFSET ballPrompt
	call WriteString
	call Crlf

	mov strikeCount, 0
	mov ballCount, 0

	jmp guessInput

	

winMessage:

	mov edx, OFFSET strikeoutP
	call WriteString
	call Crlf

	mov edx, OFFSET winPrompt1
	call WriteString
	mov eax, tryCount
	call WriteDec
	mov edx, OFFSET winPrompt2
	call WriteString
	call Crlf

	mov strikeCount, 0
	mov ballCount, 0	
	mov tryCount, 0
	ret



play endp
;##########################################################

; Procedure q
exitProgram proc
	
	mov edx, OFFSET quitPrompt
	call WriteString
	call Crlf

	stc
	ret


exitProgram endp
end main

