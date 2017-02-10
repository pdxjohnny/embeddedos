#include <processor.h>

.text
.global syscall_handler
syscall_handler:
  @ Save all registers
  STMFD sp!, {r1-r12, lr}
  @ r0-r3 can be clobered by SVC/SWI so r4-r8 are used for
  @ argument passing instead. Here we take the arguments
  @ passed to us my usermode and put them into the conventional
  @ registers, r5-r8 become r0-r3. r4 is the syscall number.
  MOV r0, r5
  MOV r1, r6
  MOV r2, r7
  MOV r3, r8
  @ r4 contains the syscall number the usermode process
  @ wants to call. We find the handler for that call by using
  @ the number as an index into the SYSCALL_TABLE.
  @ Load the address of the SYSCALL_TABLE into r5.
  LDR r5, =SYSCALL_TABLE
  @ The addresses of our syscall handeler functions stored in
  @ SYSCALL_TABLE are 32 bits long, 4 bytes. Therefore we need
  @ to multiply the index, (syscall number, r4), by 4 to get
  @ the address of the syscall handler address in SYSCALL_TABLE.
  MOV r6, #4
  MUL r4, r4, r6
  @ Add the address of SYSCALL_TABLE to the calculated address
  @ of the call within the table. This should give us an address
  @ within the table.
  ADD r4, r5
  @ Make sure that the index lands us at an address less
  @ than the end of the syscall table
  LDR r5, =SYSCALL_TABLE_END
  @ Subtract 1 so we are at the last byte in SYSCALL_TABLE
  SUB r5, #1
  CMP r4, r5
  @ If the address is higher than the start of syscall table
  @ return an error
  BHI syscall_handler_err
  @ Make sure that the index lands us at an address greater
  @ than the start of the syscall table
  LDR r5, =SYSCALL_TABLE
  CMP r4, r5
  @ If the address is lower than the start of syscall table
  @ return an error
  BLO syscall_handler_err
  @ Otherwise the address is valid so call that syscall.
  @ the address of the syscall handler we want is stored at
  @ the address we have calculated. So retive the address of
  @ the handler and branch to it.
  BLX r4
syscall_handler_end:
  @ Restore registers and switch back to usermode
  LDMFD sp!, {r1-r12, lr}
  B switch_to_usermode

syscall_handler_err:
  MOV r0, #0xFFFFFFFF
  B syscall_handler_end

SYSCALL_TABLE:
  B sch_device
  @ .word sch_write
  @ .word sch_read
SYSCALL_TABLE_END: .byte 0x00

.end
