#include <stdint.h>

struct fd_entry {
  int fd;
  int (*read)(int, char *, uint32_t);
  int (*write)(int, char *, uint32_t);
};
