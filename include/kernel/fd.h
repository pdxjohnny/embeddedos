#ifndef KERNEL_FD_H
#define KERNEL_FD_H
#include <stdint.h>

struct fd_entry {
  int fd;
  int (*read)(int, char *, uint32_t);
  int (*write)(int, char *, uint32_t);
};
#endif
