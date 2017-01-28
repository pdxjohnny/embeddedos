target remote 127.0.0.1:1234
layout asm
focus cmd
file main.elf
break *_start
continue
