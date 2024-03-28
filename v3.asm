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