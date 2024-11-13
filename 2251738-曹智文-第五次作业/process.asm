.MODEL SMALL
.STACK 100h

TABLE SEGMENT
    db 21 DUP('year summ ne ??')
TABLE ENDS

.DATA
    years   db  '1975','1976','1977','1978','1979','1980','1981','1982','1983' 
            db '1984','1985','1986','1987','1988','1989','1990','1991','1992' 
            db  '1993','1994','1995'

    revenue dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
            dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    employees dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
            dw 11542,14430,15257,17800   

EXTERN PRINT_NUM: FAR
EXTERN PRINT_TAB: FAR
EXTERN PRINT_NEWLINE: FAR
PUBLIC PROCESS_DATA
PUBLIC PRINT_TABLE 

.CODE
PROCESS_DATA PROC
    MOV AX, TABLE
    MOV ES, AX
    MOV DI, 0           ; 初始化目标数据的索引          
    MOV BX, 0
    MOV CX, 21          ; 处理21年的数据

PROCESS_LOOP:
    MOV SI, OFFSET years
    MOV AX, BX
    ADD AX, AX
    ADD AX, AX
    ADD SI, AX             
    MOVSB
    MOVSB
    MOVSB
    MOVSB
    
    INC DI

    ; 将总收入写入table段
    MOV SI, OFFSET revenue
    MOV AX, BX
    ADD AX, AX
    ADD AX, AX
    ADD SI, AX
    MOV AX, [SI]  
    MOV DX, [SI + 2]
    MOV ES:[DI], AX
    MOV ES:[DI + 2], DX
    ADD DI, 5     

    ; 将雇员人数写入table段
    MOV SI, OFFSET employees
    MOV AX, BX
    ADD AX, AX
    ADD SI, AX
    MOV AX, [SI] 
    MOV ES:[DI], AX      
    ADD DI, 3   

    ; 计算人均收入，收入除以人数
    MOV SI, OFFSET revenue
    MOV AX, BX
    ADD AX, AX
    ADD AX, AX
    ADD SI, AX
    MOV AX, [SI]    
    MOV DX, [SI + 2]
    MOV SI, OFFSET employees 
    PUSH CX
    MOV CX, BX     
    ADD CX, CX
    ADD SI, CX   
    MOV CX, [SI] 
    DIV CX                     ; 人均收入 = 收入 / 雇员人数
    MOV ES:[DI], AX   
    ADD DI, 3       
    POP CX          

    INC BX
    LOOP PROCESS_LOOP           ; 继续处理下一个年份

    RET
PROCESS_DATA ENDP


PRINT_TABLE PROC
 ; 打印 TABLE 段内容
    MOV CX, 21
    MOV SI, 0                  
    MOV AX, TABLE
    MOV DS, AX                 ; DS 指向 TABLE 段
PRINT_RESULT:
    CALL PRINT_TAB
    
; 打印年份
    MOV BX, 4
PRINT_YEAR:
    MOV DL, [SI]
    MOV AH, 02H                
    INT 21H                    
    INC SI
    DEC BX
    JNZ PRINT_YEAR
    CALL PRINT_TAB
    CALL PRINT_TAB
    CALL PRINT_TAB

; 打印收入
    INC SI
    MOV AX, [SI]            ; 将 INCOMES 中的低 16 位加载到 AX
    MOV DX, [SI + 2]            ; 将 INCOMES 中的高 16 位加载到 DX
    ADD SI, 5               ; 增加 SI
    CALL PRINT_NUM
    CALL PRINT_TAB
    CALL PRINT_TAB

; 打印雇员人数
    MOV AX, [SI]            ; 将 EMPLOYEES 中的内容加载到 AX
    MOV DX, 0               ; 清空 DX 中的内容
    ADD SI, 3               ; 增加 SI
    CALL PRINT_NUM
    CALL PRINT_TAB
    CALL PRINT_TAB

; 打印平均工资
    MOV AX, [SI]            ; 将 AVERAGE 中的内容加载到 AX
    MOV DX, 0               ; 清空 DX 中的内容
    ADD SI, 3               
    CALL PRINT_NUM
    CALL PRINT_NEWLINE      ; 换行

    LOOP PRINT_RESULT      
    
    MOV AH, 04CH
    INT 21H
PRINT_TABLE ENDP

END 