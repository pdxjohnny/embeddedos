.equ STACK_SIZE, 0x1000

.text
.global kstack_setup
kstack_setup:
  LDR sp, =STACK
  ADD sp, #STACK_SIZE
  MOV pc, lr

.data
STACK:
  .rept STACK_SIZE
  .byte 0x00
  .endr

.END
