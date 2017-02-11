.text
.global _start

@ Kernel entry point
_start:
  @ Step one is to setup the stack the kernel will be using
  BL kstack_setup
  @ Setup software interupts so that syscalls can happen
  BL syscall_setup
  BL syscall_handler_init
  @ Switch to the user mode application, user_main
  LDR lr, =user_main
  BL switch_to_usermode

.end
