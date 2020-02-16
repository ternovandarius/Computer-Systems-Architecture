bits 32 ; assembling for the 32 bits architecture

;signed
;a-byte, b-word, c-dword, d-qword
;(c+c+c)-b+(d-a)

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 5
    b dw 6
    c dd 7
    d dq 8

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax; we clear the registers for further use
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        mov eax, [c];we move c to eax
        add eax, [c];then we add it two times to get (c+c+c)
        add eax, [c]
        mov ebx, eax;we move eax to ebx so we can use eax for conversions
        xor eax, eax;we clear eax
        mov ax, [b];we move b to ax
        cwd;then we convert it to word
        sub ebx, eax;we subtract it from ebx to get (c+c+c)-b
        mov eax, ebx;we move the value to eax to convert it
        cdq;we convert it to qword so we can work with d
        xor ebx, ebx
        mov ebx, dword[d];we move d to ebx and ecx
        mov ecx, dword[d+4]
        add ebx, eax;we add the two parts to obtain (c+c+c)-b+d
        adc ecx, edx
        xor eax, eax;we clear the registers
        xor edx, edx
        mov al, [a];we move a to al
        cbw
        cwd
        cdq;convert it to qword
        sub ebx, eax;then subtract it from the value to get the final value: (c+c+c)-b+(d-a)
        sbb ecx, edx
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
