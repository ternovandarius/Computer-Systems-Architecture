bits 32 ; assembling for the 32 bits architecture


;Given the byte A and the word B, compute the doubleword C as follows:

;the bits 24-31 of C are the same as the bits of A

;the bits 15-23 of C are the invert of the bits of the lowest byte of B

;the bits 10-14 of C have the value 1

;the bits 2-9 of C are the same as the bits of the highest byte of B

;the bits 0-1 both contain the value of the sign bit of A


; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10001101b
    b dw 1001110011001101b
    c dd 0

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax ; we clean the registers for further use
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        
        mov eax, [a] ; we move a in eax (we will store the final result in eax)
        mov cl, 24
        shl eax, cl ; we move the a byte 24 bits to the left to get the desired position
        
        mov bl, byte[b] ; we add the lower byte of b to the ebx register, inverse it, then shift it 16 positions to the left (to get 24-16) and add it to eax - even though the problem said 24-15, it is impossible, so I left bit 15 as 0
        not bl
        mov cl, 16
        shl ebx, cl
        
        or eax, ebx
        or eax, 00000000000000000111110000000000b   ;we give bits 14-10 value 1
        xor ebx, ebx
        
        mov bl, byte[b+1];we move the higher byte of b to the ebx register, then shift it two positions to the left to get the desired position, then add it to eax
        mov cl, 2
        shl bl, cl
        or eax, ebx
        
        mov bl, [a]; finally, we repeat a process twice: moving a to bl, then shifting it 7, respectively 6 positions to the right in order to make bits 0-1 in eax the signed bit of a
        mov cl, 7
        shr bl, cl
        or eax, ebx
        
        mov bl, [a]
        mov cl, 6
        shr bl, cl
        or eax, ebx
        mov [c], eax
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
