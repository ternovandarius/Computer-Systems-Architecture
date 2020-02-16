bits 32 ; assembling for the 32 bits architecture

;A character string S is given. Obtain the string D that contains all capital letters of the string S. 
;Problem 8

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 'a', 'A', 'b', 'B', '2', '%', 'x', 'M'
    l equ $-s
    d times l db 0
    MIN equ 65
    MAX equ 90
    
; our code starts here
segment code use32 class=code
    start:
        mov ecx, l;we move l in ecx to know the number of times the program needs to repeat the loop
        mov esi, 0;esi is a simple variable we will use to go through the characters in the strings
        mov edi, 0;edi is a variable for the positions of the string d
        jecxz Exit;if ecx is zero, it jumps to Exit so that the program terminates
        
        Repeta:
                mov al, [s+esi];we move in al the character
                cmp al, MIN;we compare al to 65, the ASCII code for 'A'
                jb First;if al is lower than 65, it can't be a capital letter, so it jumps to First, skipping the step where we add the character to the desired string
                
                cmp al, MAX;same for higher than 90, the ASCII code for 'Z'
                jae Second
                mov [d+edi], al;if it doesn't jump, we add it to the string
                inc edi;we increase edi's value by 1
                
                Second:
                First:
                inc esi;we increase esi's value by 1 to move to the next character
        loop Repeta
        
        Exit:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
