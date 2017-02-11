#include <processor.h>
#include <syscall.h>

int main() {
  int stdout;
  stdout = device(DEVICE_UART0);
  write(stdout, "Hello, world!\n", 14);
  return 42;
}
