#include <processor.h>

.text
.global kstack_setup
kstack_setup:
  LDR sp, =KSTACK_END
  MOV pc, lr

.data
KSTACK: .rept 0x1000
        .word 0x00
        .endr
KSTACK_END: .word 0x00

.end
