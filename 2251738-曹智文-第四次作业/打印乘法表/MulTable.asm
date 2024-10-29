.MODEL SMALL
.STACK 100H
.DATA
    msg db 'The 9mul9 table:', 0DH, 0AH, '$'
    newline db 0DH, 0AH, '$'

.CODE
    MAIN PROC
        ; 初始化数据段寄存器
        MOV AX, @DATA
        MOV DS, AX

        LEA DX, msg
        MOV AH, 09H        ; DOS 09H 功能：显示字符串
        INT 21H            ; 调用 DOS 中断

        MOV CX, 9          ; 外层循环，控制乘数 1-9
    OUTER_LOOP:
        MOV BX, 1          ; 初始化被乘数为 1

    INNER_LOOP:
        ; 显示乘数
        MOV AX,CX
        CALL PRINT_NUM 
      
        MOV AH, 02H        ; DOS 功能：显示字符
        MOV DL, '*'        ; 输出字符 *
        INT 21H

        ; 显示被乘数
        MOV AX,BX
        CALL PRINT_NUM  
   
        MOV AH, 02H        ; 显示字符
        MOV DL, '='        ; 输出字符 =
        INT 21H

        MOV AX, BX
        MUL CX             ; 执行乘法：AX = CX * BX
        ; 显示乘法结果
        CALL PRINT_NUM   
 
        ; 显示一个空格
        MOV AH, 02H
        MOV DL, ' '        ; 输出字符 ' '
        INT 21H

        INC BX
        CMP BX, CX
        JLE INNER_LOOP     ; 如果BX小于等于CX，继续内循环

        ; 输出换行符
        LEA DX, newline
        MOV AH, 09H
        INT 21H

        LOOP OUTER_LOOP    ; CX - 1，继续外循环

        ; 程序结束，返回 DOS
        MOV AH, 4CH       
        INT 21H

    MAIN ENDP

    ; 显示数字
    PRINT_NUM PROC
        PUSH AX            ; 保存 AX
        PUSH BX            ; 保存 BX
        PUSH CX            ; 保存 CX
        PUSH DX            ; 保存 DX
        MOV BX, 10         ; 除数为 10
        XOR CX, CX         ; 清零 CX，用于计数

    PRINT_LOOP:
        XOR DX, DX         ; 清零 DX
        DIV BX             ; AX / 10，商在 AX，余数在 DX
        PUSH DX            ; 余数入栈
        INC CX             ; 计数
        TEST AX, AX        ; 检查 AX 是否为 0
        JNZ PRINT_LOOP     ; 如果不为 0，继续循环

    PRINT_NUM_LOOP:
        POP DX             ; 弹出余数
        ADD DL, 30H        ; 转换为 ASCII
        MOV AH, 02H
        INT 21H            ; 显示字符
        LOOP PRINT_NUM_LOOP; 输出所有字符

        POP DX             ; 恢复 DX
        POP CX             ; 恢复 CX
        POP BX             ; 恢复 BX
        POP AX             ; 恢复 AX
        RET
    PRINT_NUM ENDP
END MAIN