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

calculate_loop:
    mov cl, [si]           ; Зчитування поточного символу з рядка
    cmp cl, '$'            ; Перевірка на кінець рядка
    je calculate_done
    sub cl, '0'            ; Перетворення символу в число
    mul bx                 ; AX = AX * 10
    add ax, cx             ; Додавання поточної цифри
    inc si                 ; Перехід до наступного символу
    jmp calculate_loop     ; Повторення циклу