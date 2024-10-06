#include <stdio.h>

int main() {
    char letter = 'a'; // 从 'a' 开始
    for (int i = 0; i < 2; i++) {  // 外层循环控制行数
        for (int j = 0; j < 13; j++) {  // 内层循环控制每行打印的字母数
            printf("%c", letter);  // 打印当前字母
            letter++;         // 字母递增
        }
        printf('\n');  // 打印换行符
    }
    return 0;  // 程序正常退出
}