bits 32 ; assembling for the 32 bits architecture

;Problem 12
;Given an array A of doublewords, build two arrays of bytes:  
; - array B1 contains as elements the lower part of the lower words from A
; - array B2 contains as elements the higher part of the higher words from A

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 12345678h, 1A2B3C4Dh, 2222AAAAh
    len equ ($-a)/4
    b1 times len db 0
    b2 times len db 0
    

; our code starts here
segment code use32 class=code
    start:
        mov esi, a
        cld     ;we want to go through the array from left to right
        mov ecx, len
        mov edi, b1     ;we first deal with the first array, b1
        jecxz sfarsit
        repeta:
            movsb
            lodsb
            lodsw       ;we put the lowest byte in the array, then lose the higher 3 ones
        loop repeta
        
        cld
        mov esi, a
        mov ecx, len
        mov edi, b2     ;we do everything again, but for the second array
        jecxz sfarsit
        repeta2:      ;we lose the lowest 3 bytes, then move the highest byte
            lodsw
            lodsb
            movsb
        loop repeta2
        sfarsit:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
