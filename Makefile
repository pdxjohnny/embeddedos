# The name of the output binary
SRC=main
# This sets the compiler to use. Most people use gcc clang is also another
# common compiler. It becomes the variable which can be accessed with $(CC)
ARCH:=cortexa8
AS=arm-none-eabi-as
LINKER=arm-none-eabi-ld
OBJCOPY=arm-none-eabi-objcopy
# Assembler flags
ASFLAGS=-g -mcpu=cortex-a8
# These are linker flags only needed if using external libraries but we are not
# in this
LDFLAGS=-T linker.ld
# This says to grab all the files with the c extension in this directory and
# make them the array called SRC_SOURCES
SRC_SOURCES=$(wildcard *.s) $(wildcard arch/$(ARCH)/*.s)
# This makes an array of all the c files but replaces .c with .o
SRC_OBJECTS=$(SRC_SOURCES:.s=.o)

# When you run make then all is the default command to run. So running `make` is
# the same as running `make all`
all: $(SRC)

# This says to build $(SRC) then all the o files need to be present / up to
# date first. The way they get up to date is by compiling the c files in to
# their respective o files
$(SRC): $(SRC_OBJECTS)
	@# The $@ variable gets replaced with $(SRC)
	$(LINKER) $(LDFLAGS) $(SRC_OBJECTS) -o $@.elf
	@# Make the elf a binary
	$(OBJCOPY) -O binary $@.elf $@.bin

# This is the action that is run to create all the .o files, object files.
# Every c file in the array SRC_SOURCES is compiled to its object file for
# before being linked together
%.o:%.s
	$(AS) $(ASFLAGS) $< -o $@

# Clean deletes everything that gets created when you run the build. This means
# all the .o files and the binary named $(SRC)
clean:
	rm -f $(SRC) *.o *.tar.xz *.core *.elf *.bin

# This creates the tar file for submission
tar:
	tar czvf $(SRC).tar.xz $(SRC_SOURCES) Makefile

# Run the binary in qemu
qemu:
	qemu-system-arm -M realview-pb-a8 -m 128M -nographic -s -S -kernel $(SRC).bin

# Run the binary in qemu with gdb server then launch gdb
gdb:
	qemu-system-arm -M realview-pb-a8 -m 128M -nographic -s -S -kernel $(SRC).bin &
	arm-none-eabi-gdb
	killall qemu-system-arm
