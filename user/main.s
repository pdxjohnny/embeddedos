.text
.global user_main
user_main:
  MOV r0, #0x02
  SWI 0x123456
  SUB pc, #8

.end
