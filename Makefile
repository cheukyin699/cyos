# Makefile for making CYOS
#
# Options and stoof
ASM = nasm
CC = gcc
CFLAGS = -c -std=gnu99 -ffreestanding -O2 -Wall -Wextra
NFLAGS = -f bin
MOUNTSTAT = -t vfat
DDSTAT = status=noxfer conv=notrunc

BOOTSRC = boot.asm
BOOTOBJ = boot.bin
CSRC = kernel.c
COBJ = kernel.o
SOURCES = kernel.asm
OBJECTS = $(SOURCES:.asm=.bin)
FLPDSK = CYOS.flp
HDRIVE = hard_drive
QEMUOPT = -boot order=a -fda $(FLPDSK)

all: $(FLPDSK)

$(FLPDSK): $(OBJECTS) $(BOOTOBJ) $(COBJ)
	rm -f $(HDRIVE)
	mkdosfs -C $(FLPDSK) 1440
	cat $(BOOTOBJ) $(OBJECTS) >> $(HDRIVE)
	dd $(DDSTAT) if=$(HDRIVE) of=$(FLPDSK)

$(COBJ): $(CSRC)
	$(CC) -o $(COBJ) $(CSRC) $(CFLAGS)
	$(CC) $(COBJ) kernel.bin -o kernel.b

$(OBJECTS): $(SOURCES)
	$(ASM) -f elf $(@:.bin=.asm) -o $@

$(BOOTOBJ): $(BOOTSRC)
	$(ASM) $(NFLAGS) $(@:.bin=.asm) -o $@

clean:
	rm -f *.bin *.o
	rm -f $(HDRIVE)
	rm -f $(FLPDSK)

run: $(FLPDSK)
	qemu-system-i386 $(QEMUOPT) &
