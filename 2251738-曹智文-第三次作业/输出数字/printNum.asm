.MODEL SMALL
.STACK 100H
.DATA
    errorMsg DB 'Error: Invalid input! Please enter a number.$'
.CODE
MAIN PROC
    MOV AX, @DATA          ; 初始化数据段寄存器
    MOV DS, AX             ; 设置DS指向数据段

    CALL INPUT             ; 调用输入过程，读取用户输入的数字
    MOV AX,BX
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
    
OUTPUT PROC
    MOV CL,10       ; 设置除数为10，用于十进制输出
    MOV BL,0       
L1:
    DIV CL
    PUSH AX         ; AX / 10，商在AX，余数在DX
    ADD BL,1        ; 输出字符计数加1
    MOV AH,0        ; 清零AH，准备输出字符
    
    CMP AX,0        ; 检查商是否为0
    JA L1           ; 如果AX > 0，继续循环
L2:
    POP DX
    MOV DL,DH
    ADD DL,48       ; 将数字转换为ASCII字符（加上48）
    MOV AH,2
    INT 21H
    DEC BL          ; 输出字符计数减1
    
    CMP BL,0        ; 检查是否所有字符已输出
    JA L2           ; 如果还有字符未输出，继续循环
    
    RET 
    OUTPUT ENDP

MAIN ENDP
END MAIN