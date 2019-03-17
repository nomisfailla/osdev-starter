CC = gcc
LD = ld -m elf_i386
CFLAGS = -fno-builtin -m32 -fno-stack-protector
NASM = nasm -f elf

KERNEL_OBJS =  $(patsubst %.c,%.c.o,$(shell find ./src -name '*.c'))
KERNEL_OBJS += $(patsubst %.asm, %.asm.o,$(shell find ./src -name '*.asm'))


all: iso

kernel: link.ld ${KERNEL_OBJS}
	${LD} -T link.ld -o kernel ${KERNEL_OBJS}

%.c.o: %.c
	${CC} ${CFLAGS} -I./include -c -o $@ $<

%.asm.o: %.asm
	${NASM} -o $@ $<

iso: kernel
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp kernel iso/boot/kernel
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o release.iso iso
	find -name "*.o" -delete
	rm -rf iso
	rm -f kernel

clean:
	find -name "*.o" -delete
	rm -rf iso
	rm -f kernel
	rm -f release.iso

