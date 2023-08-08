; Math/Boolean Calculator for 32-bit integers

INCLUDE Irvine32.inc

.data
MenuPrompt	BYTE "Boolean Calculator", 0dh, 0ah
			BYTE 0dh, 0ah
			BYTE "Enter an operation 1 - 7", 0dh, 0ah
			BYTE "1. x AND y"		,0dh, 0ah
			BYTE "2. x OR y"		,0dh, 0ah
			BYTE "3. x NOT"			,0dh, 0ah
			BYTE "4. x XOR y"		,0dh, 0ah
			BYTE "5. x ADD y"		,0dh, 0ah
			BYTE "6. x SUB y"		,0dh, 0ah
			BYTE "7. Exit program"	,0

prompt1 BYTE "Enter the first hexadecimal integer:	",0
prompt2 BYTE "Enter the second hexadecimal integer:	",0
result	BYTE "The result is:				",0


andPrompt	BYTE "x AND y selected	",0
orPrompt	BYTE "x OR y selected	",0
notPrompt	BYTE "NOT x selected	",0
xorPrompt	BYTE "x XOR y selected	",0
addPrompt	BYTE "x ADD y selected	",0
subPrompt	BYTE "x SUB y selected	",0

caseTable BYTE '1'
	DWORD AND_op
EntrySize = ($ - caseTable)
	BYTE '2'
	DWORD OR_op
	BYTE '3'
	DWORD NOT_op
	BYTE '4'
	DWORD XOR_op
	BYTE '5'
	DWORD ADD_op
	BYTE '6'
	DWORD SUB_op
	BYTE '7'
	DWORD exitProgram
NumberOfEntries = ($ - caseTable) / EntrySize


.code
main proc
	call Clrscr
Menu:
	mov edx, OFFSET MenuPrompt
	call WriteString
	call Crlf

getInput:
	call ReadChar

	cmp al, '7'
	ja getInput
	cmp al, '1'
	jb getInput

	call Crlf
	call selectProcedure
	jc quit

	call Crlf
	jmp Menu

quit: exit
main endp

; Procedure to select 1 - 7
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

; Procedures 1 - 7

; Procedure 1
AND_op proc

	pushad

	mov edx, OFFSET andPrompt
	call WriteString
	call Crlf
	
	mov edx, OFFSET prompt1
	call WriteString
	call ReadDec
	mov ebx, eax

	mov edx, OFFSET prompt2
	call WriteString
	call ReadDec

	and eax, ebx

	mov edx, OFFSET result
	call WriteString
	call WriteDec
	call Crlf

	popad
	ret

AND_op endp

; Procedure 2
OR_op proc

	pushad 

	mov edx, OFFSET orPrompt
	call WriteString
	call Crlf

	mov edx, OFFSET prompt1
	call WriteString
	call ReadDec
	mov ebx, eax

	mov edx, OFFSET prompt2
	call WriteString
	call ReadDec

	or eax, ebx

	mov edx, OFFSET result
	call WriteString
	call WriteDec
	call Crlf

	popad
	ret

OR_op endp

; Procedure 3
NOT_op proc
	
	pushad

	mov edx, OFFSET notPrompt
	call WriteString
	call Crlf

	mov edx, OFFSET prompt1
	call WriteString
	call ReadDec

	not eax

	mov edx, OFFSET result
	call WriteString
	call WriteDec
	call Crlf

	popad
	ret

NOT_op endp

; Procedure 4
XOR_op proc

	pushad

	mov edx, OFFSET xorPrompt
	call WriteString
	call Crlf

	mov edx, OFFSET prompt1
	call WriteString
	call ReadDec
	mov ebx, eax

	mov edx, OFFSET prompt2
	call WriteString
	call ReadDec

	xor eax, ebx

	mov edx, OFFSET result
	call WriteString
	call WriteDec
	call Crlf

	popad
	ret

XOR_op endp

; Procedure 5
ADD_op proc

	pushad 

	mov edx, OFFSET addPrompt
	call WriteString
	call Crlf

	mov edx, OFFSET prompt1
	call WriteString
	call ReadDec
	mov ebx, eax

	mov edx, OFFSET prompt2
	call WriteString
	call ReadDec

	add eax, ebx

	mov edx, OFFSET result
	call WriteString
	call WriteDec
	call Crlf

	popad
	ret

ADD_op endp

; Procedure 6
SUB_op proc

	pushad 

	mov edx, OFFSET subPrompt
	call WriteString
	call Crlf
	
	mov edx, OFFSET prompt1
	call WriteString
	call ReadDec
	mov ecx, eax

	mov edx, OFFSET prompt2
	call WriteString
	call ReadDec
	mov ebx, eax
	mov eax, ecx

	sub eax, ebx

	mov edx, OFFSET result
	call WriteString
	call WriteDec
	call Crlf

	popad
	ret

SUB_op endp

; Procedure 7
exitProgram proc

	stc
	ret

exitProgram endp
end main