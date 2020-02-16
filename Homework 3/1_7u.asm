bits 32 ; assembling for the 32 bits architecture

;unsigned
;a-byte, b-word, c-double word, d-qword
;c-(d+d+d)+(a-b)

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 5
    b dw 4
    c dd 10
    d dq 3

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax ; I clean up the registers so I can use them without any residual values remaining
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        mov eax, dword [d]; d is a qword, so we need to store it in eax and edx
        mov edx, dword [d+4];we move the second part of d in edx due to its size
        add eax, dword [d];in eax, we add the first part of d, thus getting d+d
        adc edx, dword [d+4];in edx, we add the second part, continuing the operation
        add eax, dword [d];we repeat the operation to get d+d+d
        adc edx, dword [d+4]
        mov ebx, [c];we move c in ebx
        mov ecx, 0;because we need to subtract a qword from a dword, we move 0 to ecx to convert c to qword
        sub ebx, eax; we subtract the first part of d from c
        sbb ecx, edx;we subtract the second part of d from c
        xor eax, eax;we "clean up" eax for further use
        mov al, [a];we move a to al
        mov ah, 0;we convert a to word
        sub ax, [b];we subtract b, a word, from ax, so we have (a-b)
        mov edx, 0;we move 0 to edx, to convert ax to a qword (knowing the higher part of eax is 0 due to xor eax, eax)
        add ebx, eax; we add (a-b)
        adc ecx, edx; so that we have the complete form of the operation
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
