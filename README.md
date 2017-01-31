# Embedded OS [![Build Status](https://travis-ci.org/pdxjohnny/embeddedos.svg?branch=master)](https://travis-ci.org/pdxjohnny/embeddedos)

This is an OS with a user mode and kernel mode which strives to use syscalls to
do work with memory mapped devices and keep most of the non hardware oriented
tasks in user mode.

## Architecture Overview

Directory structure

```
embeddedos
│
├── arch
│   └── arm
│       ├── cortex_a8
│       │   └── realview_pb_a8
│       │       └── linker.ld
│       ├── kstack.S
│       └── syscall.S
├── Dockerfile
├── include
│   ├── arm
│   │   └── cortex_a8
│   │       └── realview_pb_a8.h
│   ├── processor.h
│   └── README.md
├── kernel
│   └── arm
│       └── entry.S
├── LICENSE
├── Makefile
├── README.md
└── user
    └── arm
        └── entry.S
```

### arch/

Processor and architecture specific code should go in arch. These are things
like how you interact with a UART on a specific processor. Things which require
you to look at the processors data sheet should most likely go here.

### include/

Include should have a file for each microprocessor defining essentially what
you see in the processors data sheet. These files should be named after their
microprocessors and contain the information which would be found in those
processors data sheets, such as memory locations and constants that get written
to them.

### kernel/

The kernel should be written in an architecture and microprocessor independent
fashion. It contains scheduling, memory management and other universally
applicable code.

### user/

After initialization the kernel changes to user mode and executes the code at
`user_main`, which is responsible for setting up the user mode stack.
`user_main` should then jump to some architecture independent code which makes
use of the kernel though system calls to do work on devices.

## Dependencies

The first step is to install the necessary packages. These are the
arm-none-eabi tool chain and qemu with arm support.

#### Arch Linux

```
sudo pacman -S arm-none-eabi-gcc arm-none-eabi-binutils arm-none-eabi-gdb \
  arm-none-eabi-newlib qemu qemu-arch-extra
```

#### Ubuntu

```
sudo apt -y install \
    make \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    gdb-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    libnewlib-arm-none-eabi \
    qemu-system-arm
```

## GDB

In `.gdbinit` we have placed commands which gdb will run on startup. But to
make this work the `.gdbinit` file in our home directory needs to say its ok
for gdb to load this `.gdbinit` file. To do that we just add the directory to
the auto-load safe-path.

```
echo "set auto-load safe-path $PWD" >> ~/.gdbinit
```

## Building

The Makefile should have plenty of comments to help you understand what is
being done in it. It takes all the `.s` assembly files in the current directory
and compiles them into object files. Then it runs the linker to create the ELF
binary. All of this is done with arm-none-eabi-gcc rather than your regular
gcc for host programs.

```
make
```

Will rebuild all the modified `.s` files into their object file forms and
relink to the binary. Run `make clean all` if you are having really weird
errors. That usually fixes things.

## Running

To run you can do `qemu-arm ./main`. But hey why not put it in the Makefile
right.

```
make all qemu
```

Will rebuild any changed files and run the created binary in qemu.

## Debugging

Oh you ran the program and everything exploded? Time to debug.

```
make all gdb
```

Will rebuild all your source files and start the program in qemu with it as a
gdb target on port 1234, so make sure nothing else is using that port or change
it in the `.gdbinit` file and `Makefile`.

## Help nothing works

Comment with the problem so we can figure it out on here and everyone else can
see the solution.
