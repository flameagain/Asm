#include <stdio.h>

int main() {
    char letter = 'a'; // �� 'a' ��ʼ
    for (int i = 0; i < 2; i++) {  // ���ѭ����������
        for (int j = 0; j < 13; j++) {  // �ڲ�ѭ������ÿ�д�ӡ����ĸ��
            printf("%c", letter);  // ��ӡ��ǰ��ĸ
            letter++;         // ��ĸ����
        }
        printf('\n');  // ��ӡ���з�
    }
    return 0;  // ���������˳�
}