ENTRY(_start)
SECTIONS
{
  . = 0x70010000;
  .text : { *(.text) }
  .data : { *(.data) }
  . = ALIGN(8);
}
