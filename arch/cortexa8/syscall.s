.text
.global syscall_setup
syscall_setup:
  STMFD sp!, {r0, lr}
  MOV r0, #0x18
  LDR r1, =syscall_handler
  STR r1, [r0]
  LDMFD sp!, {r0, pc}

syscall_handler:
  STMFD sp!, {r1-r12, lr}
  ADD r0, #40
  LDMFD sp!, {r1-r12, lr}
  B switch_to_usermode

.global switch_to_usermode
switch_to_usermode:
  STMFD sp!, {r0}
  MRS r0, cpsr          @ load CPSR into R0
  BIC r0, r0, #0x03     @ clear mode field
  MSR spsr, r0          @ store modified CPSR into SPSR
  LDMFD sp!, {r0}
  MOVS pc, lr           @ context switch and branch

.end
