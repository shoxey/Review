TITLE Boolean Calculator

; This program functions as a simple boolean : Justin D

INCLUDE Irvine32.inc

.data
msgMenu BYTE "---- Boolean Calculator ----",0dh,0ah
	BYTE 0dh,0ah
	BYTE "1. x AND y"     ,0dh,0ah
	BYTE "2. x OR y"      ,0dh,0ah
	BYTE "3. NOT x"       ,0dh,0ah
	BYTE "4. x XOR y"     ,0dh,0ah
	BYTE "5. Exit program",0

msgAND BYTE "Boolean AND",0
msgOR  BYTE "Boolean OR",0
msgNOT BYTE "Boolean NOT",0
msgXOR BYTE "Boolean XOR",0

msgInteger1 BYTE "Enter the first 32-bit hexadecimal integer:  ",0
msgInteger2 BYTE "Enter the second 32-bit hexadecimal integer: ",0
msgResult   BYTE "The 32-bit hexadecimal result is:            ",0

caseTable BYTE '1'			; lookup value
	DWORD AND_op			; address of procedure
EntrySize = ($ - caseTable )
	BYTE '2'
	DWORD OR_op
	BYTE '3'
	DWORD NOT_op
	BYTE '4'
	DWORD XOR_op
	BYTE '5'
	DWORD ExitProgram
NumberOfEntries = ($ - caseTable) / EntrySize

.code
main PROC
	call Clrscr				; clears console window

Menu:
	mov edx, OFFSET msgMenu		; menus choice
	call WriteString			
	call Crlf				; next output line

L1:	call ReadChar			; wait for input and return char
	cmp al, '5'				
	ja L1					; jump if above 5, goes back
	cmp al, '1'
	jb L1					; jump if below 1, goes back

	call Crlf				
	call ChooseProcedure		
	jc quit				; jump if carry = 1, then exit

	call Crlf
	jmp Menu				; display menu again

quit: exit
main ENDP

ChooseProcedure PROC

	push ebx				
	push ecx				

	mov ebx, OFFSET caseTable	
	mov ecx, NumberOfEntries	; loop 

L1:	cmp al, [ebx]			
	jne L2				; if no, continue
	call NEAR PTR [ebx + 1]		
	jmp L3

L2:	add ebx, EntrySize		; point to the next entry
	loop L1				

L3:	pop ecx				
	pop ebx				

	ret					; return from procedure

ChooseProcedure ENDP

AND_op PROC

	pushad				

	mov edx, OFFSET msgAND		; name of the operation
	call WriteString			; display message
	call Crlf
	call Crlf

	mov edx, OFFSET msgInteger1	; ask for first integer
	call WriteString
	call ReadHex			
	mov ebx, eax			

	mov edx, OFFSET msgInteger2	; ask for second integer
	call WriteString
	call ReadHex			

	and eax, ebx			

	mov edx, OFFSET msgResult	; result
	call WriteString			; display result
	call WriteHex			; display hex to window
	call Crlf

	popad					; save and restore registers
	ret					; return from procedure

AND_op ENDP

OR_op PROC

	pushad				; push all registers onto stack

	mov edx, OFFSET msgOR		; name of the operation
	call WriteString			
	call Crlf
	call Crlf

	mov edx, OFFSET msgInteger1	; ask for first integer
	call WriteString
	call ReadHex			; get hexadecimal integer
	mov ebx, eax		

	mov edx, OFFSET msgInteger2	; ask for second integer
	call WriteString
	call ReadHex			; get hex integer

	or eax, ebx				; integer1 OR integer2

	mov edx, OFFSET msgResult	; resulting operation
	call WriteString
	call WriteHex			; display hex to the window
	call Crlf

	popad					
	ret					; return from procedure
OR_op ENDP

NOT_op PROC

	pushad				; push all registers onto stack

	mov edx, OFFSET msgNOT		; name of the operation
	call WriteString			; display message
	call Crlf
	call Crlf

	mov edx, OFFSET msgInteger1	; ask for integer
	call WriteString
	call ReadHex			; get hex integer

	not eax				

	mov edx, OFFSET msgResult	; result of operation
	call WriteString
	call WriteHex			
	call Crlf

	popad					
	ret					

NOT_op ENDP

XOR_op PROC

	pushad				

	mov edx, OFFSET msgXOR		
	call WriteString			
	call Crlf
	call Crlf

	mov edx, OFFSET msgInteger1	
	call WriteString
	call ReadHex			
	mov ebx, eax			

	mov edx, OFFSET msgInteger2	
	call WriteString
	call ReadHex			

	xor eax, ebx			

	mov edx, OFFSET msgResult	
	call WriteString
	call WriteHex			
	call Crlf

	popad					
	ret					

XOR_op ENDP

ExitProgram PROC

	stc					
	ret					; return from procedure

ExitProgram ENDP

END main
