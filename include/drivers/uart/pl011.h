#ifndef PL011_H
#define PL011_H
#define UARTDR(X)           (X + 0x000)
#define UARTRSR             (X + 0x004)
#define UARTECR             (X + 0x004)
#define UARTFR(X)           (X + 0x018)
#define UARTILPR(X)         (X + 0x020)
#define UARTIBRD(X)         (X + 0x024)
#define UARTFBRD(X)         (X + 0x028)
#define UARTLCR_H(X)        (X + 0x02C)
#define UARTCR(X)           (X + 0x030)
#define UARTIFLS(X)         (X + 0x034)
#define UARTIMSC(X)         (X + 0x038)
#define UARTRIS(X)          (X + 0x03C)
#define UARTMIS(X)          (X + 0x040)
#define UARTICR(X)          (X + 0x044)
#define UARTDMACR(X)        (X + 0x048)
#define UARTPeriphID0(X)    (X + 0xFE0)
#define UARTPeriphID1(X)    (X + 0xFE4)
#define UARTPeriphID2(X)    (X + 0xFE8)
#define UARTPeriphID3(X)    (X + 0xFEC)
#define UARTPCellID0(X)     (X + 0xFF0)
#define UARTPCellID1(X)     (X + 0xFF4)
#define UARTPCellID2(X)     (X + 0xFF8)
#define UARTPCellID3(X)     (X + 0xFFC)


/** Initialize PrimeCell UART (PL011) on the processor
 * \param uart_addr Address of the UART on the processor.
 * \param fifo_en Enabled or disable the FIFO for TX and RX.
 * \param buad The buad rate at which the UART communicates.
*/
void uart_setup(int uart_addr, int fifo_en, int buad);
#endif
