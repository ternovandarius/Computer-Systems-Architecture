bits 32 ; assembling for the 32 bits architecture

;Problem 5
;Two natural numbers a and b (a, b: dword, defined in the data segment) are given. Calculate a/b and display the quotient and the remainder in the following format: "Quotient = <quotient>, remainder = <remainder>". Example: for a = 23, b = 10 it will display: "Quotient = 2, remainder = 3".
;The values will be displayed in decimal format (base 10) with sign.



; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit
extern printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dq 23
    b dd 10
    format db "Quotient = %d, remainder = %d", 0

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax
        mov eax, [a]
        xor edx, edx
        mov edx, [a+4]  ;I moved the quad word a in eax and edx
        xor ebx, ebx
        mov ebx, [b]    ;I moved the doubleword b in ebx so I can divide by it
        div ebx
        push dword edx  ;push them onto the stack to call print
        push dword eax
        push dword format
        call [printf]   ;call print
        add esp, 4*3    ;return stack to initial position
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
