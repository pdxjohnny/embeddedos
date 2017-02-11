#include <stdint.h>
#include <processor.h>

struct fd_entry *fd_table;
uint32_t fd_table_len;

int sci_device() {
}

int sch_device(uint32_t device) {
  return -1;
}
