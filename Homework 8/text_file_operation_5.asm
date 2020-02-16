bits 32 ; assembling for the 32 bits architecture

;Problem 5
;A text file is given. Read the content of the file, count the number of special characters and display the result on the screen. The name of text file is defined in the data segment.


;Nu am reusit sa rezolv problema legata de acest exercitiu.

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "file.txt", 0
    access_mode db "r", 0
    file_descriptor dd -1
    read_chars dd 0
    len equ 100
    buffer resb len
    nr dd 0
    min dw 65
    max dw 172
    format db "The file has %d special characters.", 0
    special dq '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '~', '`'
    len2 equ ($-special)

; our code starts here
segment code use32 class=code
    start:
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4*2    ;I opened the file
        
        cmp eax, 0
        je final    ;If eax is 0, it means that the file didn't open, so we jump to the end
        
        mov [file_descriptor], eax ;put eax in the file descriptor
        
        bucla:  ;a loop to continuously read 100 chars until the end of file
            push dword [file_descriptor]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4        ;read 100 chars
            
            cmp eax, 0  ;again, if it didn't open properly, jump to closing the file
            je close_file
            
            mov [read_chars], eax   ;put eax in read_chars
            
            mov esi, -1
            mov ecx, [nr]
            search_special:
                inc esi
                mov al, [buffer+esi]
                mov ecx, len
                std
                part2_search:
                    scasb
                    jne nfound
                    inc ecx
                    nfound:
                loop part2_search
            loop search_special
            mov [nr], ecx
            
            jmp bucla
        
        close_file:
            push dword [file_descriptor]
            call [fclose]
            add esp, 4
            
        mov edx, [nr]
        push dword edx
        push dword format
        call [printf]
        add esp, 4*2
        
        final:
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
