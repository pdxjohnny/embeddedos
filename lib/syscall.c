#include <syscall.h>

static int call(uint32_t syscall_number, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4) {
  int ret = -1;
  asm volatile (
      "MOV r4, %1\n"
      "MOV r5, %2\n"
      "MOV r6, %3\n"
      "MOV r7, %4\n"
      "MOV r8, %5\n"
      "SWI 0x000000\n"
      "MOV %0, r0\n"
      :"=r"(ret)
      :"r"(syscall_number), "r"(a1), "r"(a2), "r"(a3), "r"(a4)
      :"r0", "r4", "r5", "r6", "r7", "r8"
      );
  return ret;
}

int device(uint32_t device) {
  return call(SYSCALL_DEVICE, device, 0, 0, 0);
}

int write(int fd, char *buf, uint32_t buf_len) {
  return call(SYSCALL_WRITE, fd, (uint32_t)buf, buf_len, 0);
}

int read(int fd, char *buf, uint32_t buf_len) {
  return call(SYSCALL_READ, fd, (uint32_t)buf, buf_len, 0);
}
