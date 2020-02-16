bits 32 ; assembling for the 32 bits architecture

;a,b,c - byte, d - word     (50-b-c)*2+a*a+d

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10
    b db 15
    c db 12
    d dw 20

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax
        xor ebx, ebx
        mov ax, 50      ;in ax mutam 50
        sub ax, [b]     ;si scadem b
        sub ax, [c]     ;si c
        mov bl, 2       ;in bl mutam 2
        mul bl          ;pentru a putea inmulti ax
        mov bx, ax      ;rezultatul il mutam in bx pt a elibera ax
        mov al, [a]     ;mutam a in al
        xor ecx, ecx
        mov cl, [a]     ;mutam a in cl
        mul cl          ;inmultim a*a
        add eax, ebx    ;adaugam ebx la eax
        add eax, [d]    ;adaugam d la eax
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
