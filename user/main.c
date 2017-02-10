#include <processor.h>
#include <syscall.h>

int main() {
  int stdout;
  stdout = device(DEVICE_UART0);
  return 42;
}
