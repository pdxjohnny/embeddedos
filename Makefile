# The name of the output binary
NAME=embeddedos
# Version
VERSION=0.0.1
RELEASE=$(NAME)-$(RELEASE)
# Set the architecture, variant, and microprocessor you are building for
ARCH:=arm
CPU:=cortex_a8
UP:=realview_pb_a8
# The compiler uses dashes instead of underscores for the mcpu selection
MCPU=$(subst _,-,$(CPU))
# QEMU uses machine names with dashes which won't work with the preprocessor so
# we need to define the QEMU machine separately
UP_QEMU=$(subst _,-,$(UP))
# Set up compilers and linkers based on architecture
CC=gcc
LINKER=ld
OBJCOPY=objcopy
DEBUGGER=gdb
ifeq ($(ARCH),arm)
	CC=arm-none-eabi-gcc
	LINKER=arm-none-eabi-ld
	OBJCOPY=arm-none-eabi-objcopy
	DEBUGGER=arm-none-eabi-gdb
endif
# Compiler flags
CFLAGS=-g -DARCH=$(ARCH) -DCPU=$(CPU) -DUP=$(UP) -D$(UP)=$(UP)
CFLAGS+=-nostdinc -nostdinc++ -I ./include -L./include
ifeq ($(ARCH),arm)
	CFLAGS += -mcpu=$(MCPU)
endif
# Linker scripts are processor specific
LDFLAGS=-T arch/$(ARCH)/$(CPU)/$(UP)/linker.ld
# This says to grab all the files with the S extension in this directory and
# make them the array called ASM_SOURCES
ASM_SOURCES=$(wildcard user/*.S) $(wildcard user/$(ARCH)/*.S)
ASM_SOURCES+=$(wildcard kernel/*.S) $(wildcard kernel/$(ARCH)/*.S)
ASM_SOURCES+=$(wildcard arch/$(ARCH)/*.S) $(wildcard arch/$(ARCH)/$(CPU)/*.S)
ASM_SOURCES+=$(wildcard arch/$(ARCH)/$(CPU)/$(UP)/*.S)
# This makes an array of all the c files but replaces .S with .o
ASM_OBJECTS=$(ASM_SOURCES:.S=.o)

# When you run make then all is the default command to run. So running `make` is
# the same as running `make all`
all: $(NAME)

# This says to build $(NAME) then all the o files need to be present / up to
# date first. The way they get up to date is by compiling the c files in to
# their respective o files
$(NAME): $(ASM_OBJECTS)
	@# The $@ variable gets replaced with $(NAME)
	$(LINKER) $(LDFLAGS) $(ASM_OBJECTS) -o $@.elf
	@# Make the elf a binary
	$(OBJCOPY) -O binary $@.elf $@.bin

# This is the action that is run to create all the .o files, object files.
# Every S file in the array ASM_SOURCES is compiled to its object file for
# before being linked together
%.o:%.S
	$(CC) $(CFLAGS) -c $< -o $@

# Clean deletes everything that gets created when you run the build. This means
# all the .o files and the binary named $(NAME)
clean:
	rm -f $(NAME) $(ASM_OBJECTS) *.xz *.gz *.core *.elf *.bin

# This creates the tar file from the latest git commit
tar:
	git archive --format=tar.gz --prefix=$(RELEASE)/ HEAD > $(RELEASE).tar.gz

# Run the binary in qemu
qemu:
	qemu-system-$(ARCH) -M $(UP_QEMU) -m 128M -nographic -s -S -kernel $(NAME).bin

# Run the binary in qemu with gdb server then launch gdb
gdb:
	qemu-system-$(ARCH) -M $(UP_QEMU) -m 128M -nographic -s -S -kernel $(NAME).bin &
	$(DEBUGGER) $(NAME).elf
	killall qemu-system-$(ARCH)
