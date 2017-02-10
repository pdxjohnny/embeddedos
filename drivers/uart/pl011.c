#include <stdint.h>
#include <drivers/uart/pl011.h>

void uart_setup(int uart_addr, int fifo_en, int baud) {
  /* 24 MHz Clock on Realview PB A8 */
}

void uart_write(int uart_addr, const char c) {
  *(uint8_t *)(UARTDR(uart_addr)) = c;
}

char uart_read(int uart_addr) {
  return *(uint32_t *)(UARTDR(uart_addr));
}
