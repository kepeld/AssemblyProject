data segment
    numbers dw 1234, 5678, 9012, 3456, 7890 ; Масив 16-бітних чисел
    count   dw 5                                 ; Кількість чисел у масиві
    result  dw 0                                 ; Змінна для зберігання результату
data ends

; Код програми
code segment
    assume cs:code, ds:data