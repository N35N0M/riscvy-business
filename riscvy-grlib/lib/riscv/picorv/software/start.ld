SECTIONS {
. = 0x40000000;
.text : { *(.text) }
_ftext = 0x40001000;
}
