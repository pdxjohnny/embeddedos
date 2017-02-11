#ifndef KERNEL_MM_H
#define KERNEL_MM_H
#include <stdint.h>
#include <mm.h>

#ifndef KHEAP_SIZE
#define KHEAP_SIZE      0x1000
#endif

void *kmalloc(mm_addr size);
int kfree(void *addr);
#endif
