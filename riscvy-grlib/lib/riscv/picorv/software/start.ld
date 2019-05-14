SECTIONS {
. = 0x45000000;
.text : { *(.text) }
_ftext = 0x45001000;
}
