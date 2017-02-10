#include <stdint.h>

#define SYSCALL_DEVICE 0x000000
#define SYSCALL_WRITE  0x000001
#define SYSCALL_READ   0x000002

int device(uint32_t device);

void write(int fd, char *buf, uint32_t buf_len);
int read(int fd, char *buf, uint32_t buf_len);
