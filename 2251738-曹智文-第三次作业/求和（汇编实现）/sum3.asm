.MODEL SMALL
.STACK 100H
.DATA
    numStr DB 6 DUP(0)       ; 存储数字字符串

.CODE
MAIN PROC
    MOV AX, @DATA        ; 初始化数据段寄存器
    MOV DS, AX           ; 设置DS指向数据段

    MOV CX, 100          ; 设置循环次数为100
    MOV AX, 0            ; 初始化AX寄存器为0
SumToStack:
    POP AX
    ADD AX, CX           ; 将CX寄存器的值加到AX寄存器
    PUSH AX
    LOOP SumToStack   ; 循环CX次，CX减1直到0

    CALL ConvertToStr    ; 结果转化为字符串

    ; 输出结果
    MOV DX, OFFSET numStr    ; 将结果字符串的地址放入DX
    MOV AH, 09H              ; DOS 功能：输出字符串
    INT 21H                  ; 调用DOS中断
   
    MOV AX, 4C00H        ; 正常退出
    INT 21H              ; 中断退出
MAIN ENDP

ConvertToStr PROC


    MOV BX, 10               ; 基数为 10
    MOV CX, 0                ; 字符计数器

convert_loop:
    XOR DX, DX               ; 清零 DX
    DIV BX                   ; AX / 10，商在 AX，余数在 DX
    PUSH DX                  ; 保存余数
    INC CX                   ; 计数
    TEST AX, AX              ; 检查 AX 是否为 0
    JNZ convert_loop         ; 如果不为 0，继续循环

    
    MOV DI, 0                ; 初始化DI 用于字符索引

; 从栈中弹出余数并转换为字符
print_loop:
    POP DX                   ; 弹出余数
    ADD DL, '0'              ; 转换为字符
    MOV numStr[DI], DL     ; 存储字符到字符串
    INC DI                   ; 增加字符索引
    DEC CX                   ; 减少计数
    TEST CX, CX              ; 检查 CX 是否为 0
    JNZ print_loop           ; 如果CX不为0，说明还有字符，继续

    MOV numStr[DI], '$'      ; 添加字符串结束符
    RET
ConvertToStr ENDP

END MAIN




