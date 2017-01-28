.text
.global _start

@ Kernel entry point
_start:
  @ Step one is to setup the stack the kernel will be using
  BL kstack_setup
  @ Setup software interupts so that syscalls can happen
  BL syscall_setup
  @ Make a syscall to test the syscall_handler
  MOV r0, #2
  SWI 0x1337
  @ Loop forever
  SUB pc, #8

	.END
