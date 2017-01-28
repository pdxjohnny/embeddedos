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
  LDMFD sp!, {r1-r12, pc}

.end
