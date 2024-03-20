data segment
    numbers dw 1234, 5678, 9012, 3456, 7890 ; Масив 16-бітних чисел
    count   dw 5                                 ; Кількість чисел у масиві
    result  dw 0                                 ; Змінна для зберігання результату
data ends

; Код програми
code segment
    assume cs:code, ds:data

    start:
    mov ax, data
    mov ds, ax ; Встановлюємо сегмент даних

    xor dx, dx ; Очищаємо старший регістр DX
    mov ax, 0  ; Очищаємо регістр AX для накопичення суми

    mov cx, [count] ; Завантажуємо кількість чисел у лічильник CX
    mov bx, 0       ; Використовуємо BX для індексації масиву