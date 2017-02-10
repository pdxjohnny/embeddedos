.text
.global user_main
user_main:
  LDR sp, =STACK
  ADD sp, #0x1000
  BL main
  SUB pc, #0x08

.data
STACK:  .byte 0x00
        .rept 0x1000
        .align 2
        .endr

.end
