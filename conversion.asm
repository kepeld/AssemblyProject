.MODEL small
.STACK 100h

.DATA
numberString DB '12345', '$'
result DW 0

.CODE
start:
    mov ax, @data
    mov ds, ax

    xor ax, ax             ; Ініціалізація акумулятора
    mov bx, 10             ; Основа числа
    lea si, numberString
