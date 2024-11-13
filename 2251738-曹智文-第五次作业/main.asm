.MODEL SMALL 
.STACK 100H

.DATA
EXTERN PROCESS_DATA: FAR
EXTERN PRINT_TABLE: FAR

.CODE
MAIN PROC
    ; 初始化段寄存器
    MOV AX, @DATA
    MOV DS, AX

    CALL PROCESS_DATA           ; 调用数据处理模块

    CALL PRINT_TABLE            ; 调用打印表格模块

    ; 正常结束程序
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN