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

    findKeyIndex:
    push si
    push di
    mov ax, si
    repe cmpsb
    je foundKeyIndex
    pop di
    pop si
    add di, 2
    inc bx
    loop findKeyIndex
foundKeyIndex:
    pop di
    pop si
        
    add word ptr [di], 1
    mov di, offset keySums
    mov ax, bx
    mov cx, 4
    mul cx
    add di, ax
    add [di], dx
        
    inc [lineCounter]
    jmp readLine
        
invalidInput:
    mov ah, 09h
    int 21h
    jmp readLine

    finalize:
    call calculateAverages
    call sortKeys
    call printSortedKeys
    
    mov ah, 09h
    int 21h
        
finish:
    mov ax, 4C00h
    int 21h
        
calculateAverages PROC
    mov si, offset keyOccurrences
    mov di, offset keySums
    mov bx, offset keyAverages
    mov cx, maxKeys
    
calculateLoop:
    cmp word ptr [si], 0
    je skipCalculate
        
    mov ax, [di]
    mov dx, [di+2]
    div word ptr [si]
    mov [bx], ax
        
skipCalculate:
    add si, 2
    add di, 4
    add bx, 2
    loop calculateLoop
    
    ret
calculateAverages ENDP

sortKeys PROC
    mov cx, maxKeys - 1
    
outerLoop:
    push cx
    mov bx, offset keyBuffer
    mov si, offset keyAverages
        
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jge skipSwap
            
    push bx
    push si
    call swapKeys
    pop si
    pop bx
            
    mov dx, [si]
    xchg dx, [si+2]
    mov [si], dx
            
skipSwap:
    add bx, 16
    add si, 2
    loop innerLoop
        
    pop cx
    loop outerLoop
    
    ret
sortKeys ENDP

swapKeys PROC
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    
    mov si, [bp+8]
    mov di, [bp+8]
    add di, 16
    mov cx, 8
    
swapLoop:
    mov ax, [si]
    xchg ax, [di]
    mov [si], ax
    add si, 2
    add di, 2
    loop swapLoop
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4
swapKeys ENDP