czwSEG SEGMENT
    MSG2 DB "a"
    NEWLINE DB 0DH, 0AH, '$'   ; 回车换行符，0DH 是回车，0AH 是换行
czwSEG ENDS

ASSUME CS:czwSEG

czwSEG SEGMENT
czw:
    MOV AX,czwSEG
    MOV DS,AX

    MOV BX, 2        ; 外层循环计数器，设置为 2（两行）
RowLoop:
    MOV CX, 13       ; 内层循环计数器，设置为 13（每行打印 13 个字母）
    MOV AH, 2        ; 设置中断功能号，显示字符
ColLoop:
    MOV AL, [MSG2]   ; 从 MSG2 加载当前字母
    MOV DL, AL       ; 把当前字母放到 DL
    INT 21H          ; 调用中断 21H，显示字符
    INC AL           ; 字符递增
    MOV [MSG2], AL   ; 更新 MSG2，保存递增后的字母

    DEC CX           ; 内层循环计数减 1
    JNZ ColLoop      ; 如果 CX 不为 0，跳回 ColLoop

    ; 打印换行符
    MOV DX, OFFSET NEWLINE  ; 加载换行符地址
    MOV AH, 09H             ; 设置 DOS 中断功能号 09H (显示字符串)
    INT 21H                 ; 调用中断 21H，显示换行符

    DEC BX                  ; 外层循环计数减 1
    JNZ RowLoop             ; 如果 BX 不为 0，跳回 RowLoop

    MOV AX, 4C00H           ; 正常退出程序
    INT 21H
czwSEG ENDS

END czw