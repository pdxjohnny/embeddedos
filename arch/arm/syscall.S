#include <processor.h>

.text
.global syscall_setup
syscall_setup:
  STMFD sp!, {r0-r1, lr}
  @ Replace the software interrupt in the trap table
  @ with our syscall handler. This way when someone
  @ calls the SWI instruction it will jump to syscall_handler
  LDR r0, =INT_TABLE_SW_INT
  LDR r1, =syscall_handler
  STR r1, [r0]
  LDMFD sp!, {r0-r1, pc}

.global switch_to_usermode
switch_to_usermode:
  STMFD sp!, {r0}
  @ Load the Current Program Status Register
  @ this contains all sorts of information about
  @ the current state of the processor.
  MRS r0, cpsr
  @ The lower five bits of the CPSR are the MODE bits
  @ these tell us if we are in kernel mode user mode
  @ or one of the interrupt modes. We are in kernel
  @ mode so we need to clear the lowest 3 bits.
  @ The MODE bits will go from being 10111 to 10000
  @ which is user mode.
  BIC r0, r0, #0x03
  @ Then we need to store r0 which now contains a MODE
  @ of usermode into the System Program Status Register.
  @ This allows us to set up for a switch to user mode.
  MSR spsr, r0
  @ Now we restore the contents of the register we used
  @ for these operations, r0.
  LDMFD sp!, {r0}
  @ This is a special variation of the MOV instruction
  @ which is similar to how we use SUBS pc, lr #4 to return
  @ from a hardware interrupt. It will return us from a
  @ software interrupt and swap spsr into cpsr when this
  @ instruction is executed.
  MOVS pc, lr

.end
