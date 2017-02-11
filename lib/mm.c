#include <stdint.h>
#include <mm.h>

void mm_init(void *heap) {
  mm_alloc *first = (mm_alloc *)heap;
  first->next = NULL;
  first->prev = NULL;
  first->size = 0;
  first->info = MM_FIRST;
}

void *mm_malloc(void *heap, mm_addr heap_size, mm_addr size) {
  mm_alloc *curr = (mm_alloc *)heap;
  mm_alloc *next = curr->next;

  /* If they requested a zero sized block then tell them they are
   * being stupid by returning an error. */
  if (size == 0) {
    return MM_ERROR;
  }

  /* If they requested an allocation which it larger than the size of
   * our heap then return them an error. This accounts for the first
   * allocation structure in that size comparison as well. */
  if (size > (heap_size - sizeof(mm_alloc))) {
    return MM_ERROR;
  }

  /* If the first allocation in the kernel heap is not marked as such
   * there is a problem. */
  if (curr->info & MM_FIRST != MM_FIRST) {
    return MM_ERROR;
  }

  /* Traverse the doubly linked list looking for a spot of contiguous
   * memory that is big enough for what we want to allocate. */
  while (curr->next != NULL) {
    /* Check if there is enough space between this allocation
     * structure, its data, and the next allocation structure, to fit
     * a new allocation structure and its data. If there is then we
     * will create the new allocation structure and return the
     * pointer to its data. If there is not then we move on to the
     * next allocation structure and check for space between again.
     */
    /* Make sure that the size requested, plus the size of this
     * allocation and this allocations data plus the size of the
     * new allocation structure we'll need for the new data,
     * fits between the current allocation structure and the next
     * allocation structure. */
    if (((mm_addr)curr + (mm_addr)sizeof(mm_alloc) + curr->size +
          (mm_addr)sizeof(mm_alloc) + size)
        < (mm_addr)curr->next) {
      /* The next allocation's previous pointer needs to point to the
       * space we want to use as the allocation structure for the
       * requested size. Currently the next allocation's previous
       * pointer is pointing to the current allocation, so by doing
       * it this way we never loose part of our list because we have
       * a variable pointing to the current allocation. */
      curr->next->prev = (mm_alloc *)((mm_addr)curr
          + (mm_addr)sizeof(mm_alloc) + curr->size);
      /* To maintain the doubly linked list we need to set the new
       * structures previous pointer to point back to the current
       * allocation. */
      curr->next->prev->prev = curr;
      /* The new structures next pointer should then point to the
       * current structures next structure because we have inserted
       * it between the two. */
      curr->next->prev->next = curr->next;
      /* The current allocation's next pointer should be updated to
       * point to the new allocation. */
      curr->next = curr->next->prev;
      /* Set the current allocation to the new one that we just set
       * because that is what we are using for the requested size. */
      curr = curr->next;
      /* Now we need to set up the allocation structure for this
       * request. Marking it as in use and setting the size. */
      curr->size = size;
      curr->info = MM_IN_USE;
      /* The address we return is the address of the memory
       * following this new allocation structure. */
      return (void *)((mm_addr)curr + (mm_addr)sizeof(mm_alloc));
    }
  }

  /* We got to the end of the list. So we want to check if there is
   * enough space between the end of this final allocation structure
   * and the end of the heap to fit the request. If there is not
   * enough space then return an error.
   *
   * First we check if the final one is marked as in use. If is not
   * in use then check if there is enough space between it and the
   * end of the heap.
   *
   * If it is in use then we want to create an allocation after the
   * data that this allocation is using. */
  if (curr->info & MM_IN_USE != MM_IN_USE) {
    /* Not in use */
    /* Make sure that the size requested plus the size of this
     * allocation is less than the size of the kernel heap. */
    if (((mm_addr)curr + (mm_addr)sizeof(mm_alloc) + size)
        < ((mm_addr)heap + (mm_addr)heap_size)) {
      /* Mark it as in use and set the size of it. */
      curr->info |= MM_IN_USE;
      curr->size = size;
      /* The address we return is the address of the memory
       * following this allocation structure. */
      return (void *)((mm_addr)curr + (mm_addr)sizeof(mm_alloc));
    }
  } else if (curr->info & MM_IN_USE == MM_IN_USE) {
    /* In use. */
    /* Make sure that the size requested plus the size of this
     * allocation and this allocations data plus the size of the
     * new allocation we'll need for the new data is less than the
     * size of the kernel heap. */
    if (((mm_addr)curr + (mm_addr)sizeof(mm_alloc) + curr->size +
          (mm_addr)sizeof(mm_alloc) + size)
        < ((mm_addr)heap + (mm_addr)heap_size)) {
      /* Set the current allocations next to be after it's data. This
       * will be the new allocation we are using for the requested
       * size. */
      curr->next = (mm_alloc *)((mm_addr)curr
          + (mm_addr)sizeof(mm_alloc) + curr->size);
      /* The current allocation's next pointer is now pointing to the
       * space we want to use as the allocation structure for the
       * requested size. The data in that structure is unknown so we
       * can write all over it and all is well. To maintain the
       * doubly linked list we need to set the new structures
       * previous pointer to point back to the current allocation. */
      curr->next->prev = curr;
      /* Set the current allocation to the next one that we just set
       * because that is what we are using for the requested size. */
      curr = curr->next;
      /* Now we need to set up the allocation structure for this
       * request. Marking it as in use, the size, and that next is
       * NULL. */
      curr->next = NULL;
      curr->size = size;
      curr->info = MM_IN_USE;
      /* The address we return is the address of the memory
       * following this new allocation structure. */
      return (void *)((mm_addr)curr + (mm_addr)sizeof(mm_alloc));
    }
  }

  /* If we found that there was no space for the size requested then
   * return an error. */
  return MM_ERROR;
}

int mm_free(void *heap, mm_addr heap_size, void *addr) {
  return -1;
}
