#ifndef MM_H
#define MM_H
#include <stdint.h>

#define MM_ERROR       ((void *) -1)

#define MM_FIRST       (1 << 0)
#define MM_IN_USE      (1 << 1)

/* Ifdef should be added here to support 64 bit architechture. */
/* #ifdef ARCH_32 */
typedef uint32_t mm_addr;
/* #endif
#ifdef ARCH_64
typedef uint64_t mm_addr;
#endif */

/** allocation structs are how we track what memory
 * is being used on the heap. */
struct mm_allocation {
  struct mm_allocation *next;
  struct mm_allocation *prev;
  mm_addr size;
  uint8_t info;
};
typedef struct mm_allocation mm_alloc;

void *mm_malloc(void *heap, mm_addr heap_size, mm_addr size);
int mm_free(void *heap, mm_addr heap_size, void *addr);


/* user mode */
#ifndef HEAP_SIZE
#define HEAP_SIZE      0x1000
#endif

void *malloc(mm_addr size);
int free(void *addr);
#endif
