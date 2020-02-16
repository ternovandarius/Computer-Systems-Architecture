bits 32 ; assembling for the 32 bits architecture
;Problem 26
;Se citeste de la tastatura un sir de numere in baza 10, cu semn. Sa se determine valoarea minima din sir si sa se afiseze in fisierul min.txt (fisierul va fi creat) valoarea minima, in baza 16.
; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fprintf, scanf, fopen, fclose, printf, find_if_lower              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll   ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)

segment data use32 class=data
    format1 db "Please enter a string of values. Entering 0 stops the program.", 0
    format2 db "%d",0
    format3 db "The lowest number is: %x", 0
    n dd 0
    lowest dd 32767
    access_mode db "w+",0
    file_name db "min.txt", 0
    file_descriptor dd -1
    

; our code starts here
segment code use32 class=code
    start:
        push dword format1      ;we print a message to the user
        call [printf]
        add esp, 4*1
        
        xor ebx, ebx
        read:
            push dword n        ;take the keyboard input as many times as desired until the user inputs 0
            push dword format2
            call [scanf]
            add esp, 4*2
            
            xor eax, eax
            mov eax, [n]
            cmp eax, 0          ;if the program read 0, we jump out of the read loop
            je stop_read
            
            mov ecx, [lowest]
            call find_if_lower  ;the program calls the function to check whether the number is lower
        loop read
            
        stop_read:
        
        mov [lowest], ebx       ;at the end of the loop, the lowest number will be in ebx
        
        push dword access_mode ;open the file, if it doesn't exist it creates it
        push dword file_name
        call [fopen]
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je final
        
        push dword [lowest]     ;print the number in the file
        push dword format3
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        push dword [file_descriptor]    ;close the file
        call [fclose]
        add esp, 4
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
