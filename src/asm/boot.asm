[BITS 32]
ALIGN 4

global mboot
section .multiboot_header
mboot:
    dd  0xe85250d6                              ; Magic
    dd  0                                       ; Architecture
    dd  mboot_end-mboot                         ; Header length
    dd  -(0xe85250d6 + 0 + (mboot_end - mboot)) ; Checksum

    ; Multiboot tags.
    ; Read the multiboot spec for a list of valid tags.

    ; Framebuffer tag. Desipite the gfx mode being set in grub.cfg, this tag must be here to 
    ; indicate support for a graphics mode, otherwise GRUB will not set if for us.
    ; Note that GRUB will use the values defined in grub.cfg rather than these values.
    ; Uncommenting this will make the kernel boot into graphics mode.
    ; dw 5             ; Type  
    ; dw 0             ; Flags
    ; dd 20            ; Size of 20
    ; dd 800           ; Width
    ; dd 600           ; Height
    ; dd 24            ; BPP
    ; dd 0             ; Padding to bring the size to 20

    ; Terminating tag.
    dw 0             ; Type
    dw 0             ; Flags
    dd 8             ; Size of 8
mboot_end:

global start
start:
    mov esp, 0x7FFFF ; Stack pointer

    push eax         ; eax should contain the magic value '0x36d76289'
    push ebx         ; ebx contains the address of the multiboot info structure

    cli

    extern kmain
    call kmain
    jmp $

SECTION .bss
    resb 8192
