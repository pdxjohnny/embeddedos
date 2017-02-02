#include <drivers/uart/pl011.h>

void uart_setup(int uart_addr, int fifo_en, int baud) {
}

void uart_write(int uart_addr, const char c) {
  *(int *)(UARTDR(uart_addr)) = c;
}

char uart_read(int uart_addr) {
  return *(int *)(UARTDR(uart_addr));
}
