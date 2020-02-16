bits 32 ; assembling for the 32 bits architecture

;signed
;a, b-byte; c-word; e-doubleword; x-qword
;(a-2)/(b+c)+a*c+e-x

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 20
    b db 5
    c dw 4
    e dd 15
    x dq 21

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax;cleaning up the registers for further use
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        mov al, [a];we move a to al
        sub al, 2;then we subtract 2 from al, to get a-2
        cbw;we convert a to a word, represented on ax
        cwd;we convert a to a dword, represented on dx:ax
        push dx
        push ax
        pop ebx; we add dx and ax to the stack, to transfer them to one register, ebx
        xor eax, eax
        mov al, [b];we move b to al
        cbw;convert b to word so we can add c
        add ax, [c];add c to b, so we get (b+c)
        mov cx, ax;we move it to cx so we can divide by it
        mov eax, ebx;we move ebx to eax so it can be divided
        idiv ecx;we use the signed division operation
        xor ebx, ebx;then we clean up ebx, ecx
        xor ecx, ecx
        mov ebx, eax;we move the result back to ebx, so we can use eax for the upcoming multiplication
        mov al, [a];we move a to al
        cbw;we convert it to word
        imul word[c];we multiply it by c
        add eax, ebx; we add the two values together, which will then be stored in eax
        add eax, [e];we add e to eax
        cdq; we convert it to a qword, which will be stored in eax and edx
        sub eax, dword[x];we add x in two parts: the first one in eax
        sbb edx, dword[x+4];the second one in edx
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
