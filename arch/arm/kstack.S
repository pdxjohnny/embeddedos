#include <processor.h>

.text
.global kstack_setup
kstack_setup:
  LDR sp, =_DATA_END_
  MOV pc, lr

.end
