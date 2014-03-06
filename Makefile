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
SOURCES = kernel.asm
OBJECTS = $(SOURCES:.asm=.bin)
FLPDSK = CYOS.flp
HDRIVE = hard_drive
QEMUOPT = -boot order=a -fda $(FLPDSK)

all: $(FLPDSK)

$(FLPDSK): $(OBJECTS) $(BOOTOBJ)
	rm -f $(HDRIVE)
	mkdosfs -C $(FLPDSK) 1440
	cat $(BOOTOBJ) $(OBJECTS) >> $(HDRIVE)
	dd $(DDSTAT) if=$(HDRIVE) of=$(FLPDSK)

$(OBJECTS): $(SOURCES)
	$(ASM) $(NFLAGS) $(@:.bin=.asm) -o $@

$(BOOTOBJ): $(BOOTSRC)
	$(ASM) $(NFLAGS) $(@:.bin=.asm) -o $@

clean:
	rm -f *.bin *.o
	rm -f $(HDRIVE)
	rm -f $(FLPDSK)

run: $(FLPDSK)
	qemu-system-i386 $(QEMUOPT) &
