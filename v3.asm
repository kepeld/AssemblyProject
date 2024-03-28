.MODEL small
.STACK 100h
.DATA
    lineCounter dw 0
    maxLines equ 10000
    maxLineLength equ 255
    lineReadBuffer db maxLineLength+1 dup(?)
    keyBuffer db 16 dup(100 dup(?))
    valueBuffer dd 0
    keyOccurrences dw 100 dup(0)
    keySums dd 100 dup(0)
    keyAverages dw 100 dup(0)
    maxKeys equ 100
    
    .CODE
main PROC
    mov ax, @data
    mov ds, ax
    
readLine:
    mov ah, 0Ah
    lea dx, lineReadBuffer
    mov byte ptr [lineReadBuffer], maxLineLength
    int 21h
    
    cmp byte ptr [lineReadBuffer+1], 0
    jne processLine
    jmp finalize
        cmp [lineCounter], maxLines
    jne continue
    jmp finalize

    processLine:
    lea si, lineReadBuffer+2
    mov di, si
    mov cl, [lineReadBuffer+1]
    mov ch, 0
    add si, cx
    dec si
    cmp byte ptr [si], 0Dh
    jne skipRemoveNewline
    mov byte ptr [si], 0
skipRemoveNewline:

    cmp [lineCounter], maxLines
    jne continue
    jmp finalize

    continue:
    mov si, offset lineReadBuffer+2
    mov di, offset keyBuffer
    mov bx, 0
readKey:
    lodsb
    cmp al, ' '
    je endReadKey
    cmp al, 0
    je endReadKey
    stosb
    inc bx
    cmp bx, 16
    jb readKey
endReadKey:
    mov al, 0
    stosb
    
    inc si
    
    xor ax, ax
    mov bx, 10

    readValueLoop:
    mov cl, [si]
    cmp cl, 0
    je endReadValue
    cmp cl, ' '
    je endReadValue
    cmp cl, '0'
    jb invalidInput
    cmp cl, '9'
    ja invalidInput
    sub cl, '0'
    push ax
    mul bx
    pop cx
    add ax, cx
    inc si
    jmp readValueLoop

endReadValue:
    cmp ax, -10000
    jl invalidInput
    cmp ax, 10000
    jg invalidInput

    mov word ptr [valueBuffer], ax

    mov si, offset keyBuffer
    mov di, offset keyOccurrences
    mov cx, maxKeys
    mov bx, 0