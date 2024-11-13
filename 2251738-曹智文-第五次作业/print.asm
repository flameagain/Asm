.MODEL SMALL
.DATA
PUBLIC PRINT_NUM
PUBLIC PRINT_TAB
PUBLIC PRINT_NEWLINE

.CODE
PRINT_NUM PROC
    ; 保存寄存器
    PUSH CX
    PUSH BX
    PUSH SI
    PUSH DI

    ; 设置固定宽度为 10
    MOV DI, 10           ; 固定宽度为 10
    MOV SI, 0            ; 用 SI 计算位数

CONVERT_LOOP:
    MOV CX, 10           ; 除数
    CALL DIVDW           ; 返回的 CX 为余数
    PUSH CX              ; 余数压栈
    INC SI               ; 增加计数器
    ; 判断是否处理完毕
    CMP AX, 0
    JNZ CONVERT_LOOP
    CMP DX, 0
    JNZ CONVERT_LOOP

	; 计算剩余空格数
    MOV BX, DI           ; 将宽度加载到 BX 中
    SUB BX, SI           ; 计算剩余空格数

    ; 打印数字
PRINT_DIGITS:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    DEC SI
    JNZ PRINT_DIGITS
    
    ; 打印剩余空格
PRINT_SPACES:
    CMP BX, 0
    JLE PRINT_DONE       ; 如果不需要空格，跳到结束
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    DEC BX
    JMP PRINT_SPACES

PRINT_DONE:
    ; 恢复寄存器
    POP DI
    POP SI
    POP BX
    POP CX

    RET
PRINT_NUM ENDP

; 输入为 DX:AX，其中 DX 为高 16 位，AX 为低 16 位, CX为除数
; 返回：DX:结果的高16位 AX:结果的低16位 CX:余数
DIVDW PROC
	PUSH BX	    
	PUSH AX
	;计算第一部分
	MOV AX,DX
	MOV DX,0
	DIV CX
	;计算第二部分
	POP BX
	PUSH AX
	MOV AX, BX
	DIV CX
	MOV CX, DX

	POP DX
	POP BX

    RET
DIVDW ENDP

PRINT_TAB PROC 
    PUSH DX
    PUSH AX
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    INT 21H
    INT 21H
    INT 21H
    POP AX
    POP DX
    RET
PRINT_TAB ENDP

PRINT_NEWLINE PROC 
    PUSH DX
    PUSH AX
    
    MOV DL, 13
    MOV AH, 02H
    INT 21H
    MOV DL, 10
    MOV AH, 02H
    INT 21H

    POP AX
    POP DX
    RET
PRINT_NEWLINE ENDP
END