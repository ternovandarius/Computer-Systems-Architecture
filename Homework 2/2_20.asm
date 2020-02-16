bits 32 ; assembling for the 32 bits architecture

;a, b, c, d - byte      (a+a)-(c+b+d)

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 5
    b db 3
    c db 2
    d db 1

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax
        xor ebx, ebx
        mov al, [a]     ;mutam a in al
        add al, [a]     ;adaugam a la al
        mov bl, [c]     ;mutam c in bl
        add bl, [b]     ;adaugam b
        add bl, [d]     ;si d
        sub al, bl      ;scadem bl din al, iar rezultatul il gasim in al
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
