# Makefile for making CYOS
#
# Options and stoof
ASM = nasm
NFLAGS = -f bin
MOUNTSTAT = -t vfat
DDSTAT = status=noxfer conv=notrunc

BOOTSRC = src/boot.asm
BOOTOBJ = obj/boot.bin
K_SRC = src/kernel.asm							# Kernel source
K_OBJ = obj/kernel.bin							# Kernel binary
FLPDSK = CYOS.flp
HDRIVE = hard_drive
QEMUOPT = -boot order=a -fda $(FLPDSK)

all: $(FLPDSK)

$(FLPDSK): $(K_OBJ) $(BOOTOBJ)
	rm -f $(HDRIVE)
	mkdosfs -C $(FLPDSK) 1440
	cat $(BOOTOBJ) $(K_OBJ) >> $(HDRIVE)
	dd $(DDSTAT) if=$(HDRIVE) of=$(FLPDSK)

$(K_OBJ): $(K_SRC)
	$(ASM) $(NFLAGS) $(K_SRC) -o $(K_OBJ)

$(BOOTOBJ): $(BOOTSRC)
	$(ASM) $(NFLAGS) $(BOOTSRC) -o $@

clean:
	rm -f $(BOOTOBJ) $(K_OBJ)
	rm -f $(HDRIVE)
	rm -f $(FLPDSK)

run: $(FLPDSK)
	qemu-system-i386 $(QEMUOPT) &
