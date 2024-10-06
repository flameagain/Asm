czwSEG SEGMENT
    MSG2 DB "a"
    NEWLINE DB 0DH, 0AH, '$'   
czwSEG ENDS

ASSUME CS:czwSEG

czwSEG SEGMENT
czw:
    MOV AX,czwSEG
    MOV DS,AX

    MOV CX, 2        ; 外层循环，控制行数，共两行
RowLoop:
    MOV BX, CX       ; 将外层循环的计数值保存到 BX 寄存器

    MOV CX, 13       ; 内层循环，控制每行打印 13 个字母
    MOV AH, 2        ; 设置中断功能号，显示字符
ColLoop:
    MOV AL, [MSG2]   ; 从 MSG2 加载当前字母
    MOV DL, AL       ; 把当前字母放到 DL
    INT 21H          ; 调用中断 21H，显示字符
    INC AL           ; 字符递增
    MOV [MSG2], AL   ; 更新 MSG2，保存递增后的字母
    LOOP ColLoop     ; 内层循环结束，CX减1，若不为0跳回ColLoop

    ; 打印换行符
    MOV DX, OFFSET NEWLINE  ; 加载换行符地址
    MOV AH, 09H             ; 设置 DOS 中断功能号 09H (显示字符串)
    INT 21H                 ; 调用中断 21H，显示换行符

    MOV CX, BX       ; 恢复外层循环的计数值
    LOOP RowLoop     ; 外层循环控制，CX减1，若不为0跳回RowLoop

    MOV AX,4C00H
    INT 21H   
czwSEG ENDS

END czw  