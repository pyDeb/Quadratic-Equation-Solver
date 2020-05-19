INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib 
.386
.model flat,stdCALL
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	messageA BYTE "Enter coefficient of X^2 (a) ",0H
	messageB BYTE "Enter coefficient of X (b) ",0H
	messageC BYTE "Enter coefficient of X^0 (c) ",0H
	messageIMG BYTE "Both of the roots are imaginary", 0
	messageONLYROOT BYTE "The result of the only root is ", 0
	messageDOUBLEROOTONE BYTE "It has two roots. The first is ", 0
	messageDOUBLEROOTTWO BYTE "And the second is ", 0
	constantTwo DWORD 2
	constantFour DWORD 4
 	coeffA REAL4 ?
	coeffB REAL4 ?
	coeffC REAL4 ?
	productofFourAC REAL4 ?
	temp REAL4 ? ; temporary variable
	discriminantSQRT REAL4 ?
	coeffAPowerTwo REAL4 ? ; result of denominator
	
	
.code
main PROC
	mov edx, offset messageA
	call WriteString
	call ReadFloat
	mov edx, offset messageB
	call WriteString
	call ReadFloat
	mov edx, offset messageC
	call WriteString
	call ReadFloat

	fmul st(0), st(2)	
	fimul constantFour ;4ac
	fstp productofFourAC
	fstp coeffB
	fld coeffB
	fmul st(0), st(0) ; now b^2 is at the top of stack
	
	fld productofFourAC
	fsubp ; b^2 - 4ac
	fldz 
	fcomi st(0), st(1)
	ja noRealRoot
	jb doubleRoot
	
	
	;it only has one result
	fxch st(2) ; a at the top of the stack
	fimul constantTwo
	fld coeffB
	fchs
	
	fdiv st(0), st(1)
	
	mov edx, offset messageONLYROOT
	call WriteString
	call WriteFloat
	jmp finish
	

	noRealRoot:
		mov edx, offset messageIMG
		call WriteString
		jmp finish



	

	doubleRoot:
		faddp ; pop zero
		fsqrt
		fstp discriminantSQRT
		fld discriminantSQRT
		fld coeffB
		fchs
		faddp ; -b + sqrt(b^2 - 4ac)
		fstp temp ; a at the top of the stack
		fimul constantTwo 
		fstp coeffAPowerTwo
		fld temp
		fld coeffAPowerTwo
		fdivp
		mov edx, offset messageDOUBLEROOTONE
		call WriteString
		call WriteFloat
		fld coeffB
		fchs
		fld discriminantSQRT
		fsubp
		fld coeffAPowerTwo
		fdivp
		mov edx, offset messageDOUBLEROOTTWO
		call WriteString
		call WriteFloat


	

	finish: 
		exit
		main ENDP
		END main
