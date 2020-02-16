bits 32                         
segment code use32 public code
global find_if_lower

find_if_lower:
    cmp eax, ecx        ;ecx is the lowest value, while eax is the value read from the keyboard
    ja not_lower
    mov ebx, eax        ;if it didn't jump, then it is lower, so we move it to ebx in order to be able to move it to lowest later
    not_lower: