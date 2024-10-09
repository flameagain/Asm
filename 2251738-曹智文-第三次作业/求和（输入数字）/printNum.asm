.MODEL SMALL
.STACK 100H
.DATA
    errorMsg DB 'Error: Invalid input! Please enter a number.$'
    numStr DB 6 DUP(0)       ; 存储数字字符串
.CODE
MAIN PROC
    MOV AX, @DATA          ; 初始化数据段寄存器
    MOV DS, AX             ; 设置DS指向数据段

    CALL INPUT             ; 调用输入过程，读取用户输入的数字
    MOV AX,BX
    CALL SUM               ; 调用求和过程
    CALL OUTPUT            ; 调用输出过程，输出结果

    MOV AH,4CH             ; 正常退出
    INT 21H                ; 中断退出
 
INPUT PROC
    MOV BL,0 ;当前输入位之前的结果
    MOV CL,10 ;乘数10
L:
    MOV AH,1;输入一个字符
    INT 21H
    
    CMP AL, 0Dh          ; 判断是否为回车键
    JE OVER              ; 如果是回车键，跳转到 OVER
    
    SUB AL,48
    MOV DL,AL
    MOV DH,0;dl即dx，当前位
    MOV AL,BL 
    MUL CL ;al*cl->ax
    ADD AX,DX
    MOV BX,AX ;结果保存在BX中
    JMP L
 
OVER: 
    RET
    INPUT ENDP

SUM PROC
    MOV CX, AX         ; 设置循环次数为输入的数字
    MOV AX, 0            ; 初始化AX寄存器为0
S:
    ADD AX, CX           ; 将CX寄存器的值加到AX寄存器
    LOOP S              ; 循环CX次，CX减1直到0

    RET 
    SUM ENDP


OUTPUT PROC
    MOV BX,10       ; 设置除数为10，用于十进制输出
    MOV CX,0        
    
L1:
    XOR DX, DX            ; 清零DX以便进行除法
    DIV BX
    PUSH DX         ; AX / 10，商在AX，余数在DX
    INC CX          ; 输出字符计数加1
    TEST AX, AX        ; 检查商是否为0
    JNZ L1           ; 如果AX > 0，继续循环

    MOV DI,0

L2:
    POP DX
    ADD DL,'0'       ; 将数字转换为ASCII字符（加上48）
    MOV numStr[DI], DL       ; 存储字符到字符串
    INC DI
    DEC CX          ; 输出字符计数减1
    TEST CX, CX         ; 检查是否所有字符已输出
    JNZ L2           ; 如果还有字符未输出，继续循环
    
    MOV numStr[DI], '$'      ; 添加字符串结束符
    MOV DX, OFFSET numStr    ; 将结果字符串的地址放入DX
    MOV AH, 09H              ; DOS 功能：输出字符串
    INT 21H                  ; 调用DOS中断

    RET 
    OUTPUT ENDP


MAIN ENDP
END MAIN