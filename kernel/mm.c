#include <stdint.h>
#include <mm.h>
#include <kernel/mm.h>

static uint8_t kheap[KHEAP_SIZE];

void *kmalloc(mm_addr size) {
  return mm_malloc(kheap, KHEAP_SIZE, size);
}

int kfree(void *addr) {
  return mm_free(kheap, KHEAP_SIZE, addr);
}
