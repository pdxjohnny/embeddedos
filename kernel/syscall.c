#include <stdint.h>
#include <syscall.h>

void syscall_handler_init() {
  sci_device();
}
