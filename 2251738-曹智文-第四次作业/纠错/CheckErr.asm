.MODEL SMALL
.STACK 100h
.DATA
    table  db 7,2,3,4,5,6,7,8,9             ;9*9表数据
	  db 2,4,7,8,10,12,14,16,18
	  db 3,6,9,12,15,18,21,24,27
	  db 4,8,12,16,7,24,28,32,36
	  db 5,10,15,20,25,30,35,40,45
	  db 6,12,18,24,30,7,42,48,54
	  db 7,14,21,28,35,42,49,56,63
	  db 8,16,24,32,40,48,56,7,72
	  db 9,18,27,36,45,54,63,72,81

    msg DB 'x y', '$'  
    incorrectPos DB 300 dup(' ')  ; 存储不正确位置的信息
    errorMsg DB 'error'
    NEWLINE DB 0DH, 0AH, '$'   ; 回车换行符，0DH 是回车，0AH 是换行
    overMsg DB 'accomplish!' , '$'  
.CODE
    MAIN PROC
        ; 初始化数据段寄存器
        MOV AX, @DATA
        MOV DS, AX

        LEA DX, msg
        MOV AH, 09H        ; DOS 09H 功能：显示字符串
        INT 21H            ; 调用 DOS 中断

        MOV DX, OFFSET NEWLINE  ; 加载换行符地址
        MOV AH, 09H             
        INT 21H    

        MOV si, 0          ; SI用于指向表格数据

        MOV CX, 1          ; 初始行数为 1
    OUTER_LOOP:
        MOV BX, 1          ; 初始列数为 1

    INNER_LOOP:
        MOV AX, BX
        MUL CX  
        CMP AL, [table + si]  ; 检测当前值是否正确
        JNE Error             ; 不正确则跳至Error
        JMP Next_Col

    Error:
        PUSH BX            ; 保存 BX
        PUSH CX            ; 保存 CX
        MOV di, 0 
        ADD CX, '0' 
        MOV [incorrectPos + di], CL
        ADD di, 1
        MOV [incorrectPos + di], ' '
        ADD di, 1
        ADD BX, '0'
        MOV [incorrectPos + di], BL
        ADD di, 1
        MOV [incorrectPos + di], ' '
        ADD di, 1
        MOV [incorrectPos + di], '$'  
        MOV DX, OFFSET incorrectPos
        MOV AH, 09h
        INT 21h

        LEA DX, errorMsg
        MOV AH, 09H       
        INT 21H           

        MOV DX, OFFSET NEWLINE  ; 加载换行符地址
        MOV AH, 09H             
        INT 21H                 


        POP CX             ; 恢复 CX
        POP BX             ; 恢复 BX

    Next_Col:
        ADD si, 1
        INC BX
        CMP BX, 10
        JL INNER_LOOP     ; 如果BX小于等于10，继续内循环

        INC CX
        CMP CX, 10
        JL OUTER_LOOP    ; 如果CX小于等于10，继续外循环
       
        LEA DX, overMsg
        MOV AH, 09H        ; DOS 09H 功能：显示字符串
        INT 21H            ; 调用 DOS 中断

        ; 程序结束，返回 DOS
        MOV AH, 4CH       
        INT 21H

    MAIN ENDP

END MAIN
