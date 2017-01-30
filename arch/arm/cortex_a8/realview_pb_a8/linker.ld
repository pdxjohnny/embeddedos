ENTRY(_start)
SECTIONS
{
  . = 0x70010000;
  .text : ALIGN(0x1000) {
    _TEXT_START_ = .;
    kernel/arm/entry.o( .text )
    *(.text)
    _TEXT_END_ = .;
  }
  .data : ALIGN(0x1000) {
    _DATA_START_ = .;
    *(.data)
    _DATA_END_ = .;
  }
. = ALIGN(8);
}
