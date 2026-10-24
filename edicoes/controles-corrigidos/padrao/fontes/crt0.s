.module crt0
.globl _main
.area _HEADER (ABS)
.org 0x4000
.db 0x41,0x42
.dw start
.dw 0,0,0,0,0,0
.org 0x4040
start:
 di
 ld sp,#0xf300
 ; Map this cartridge's slot into page 2 as well (32 KiB ROM).
 in a,(0xa8)
 rrca
 rrca
 and #3
 ld c,a
 ld b,#0
 ld hl,#0xfcc1
 add hl,bc
 ld a,(hl)
 and #0x80
 or c
 ld c,a
 inc hl
 inc hl
 inc hl
 inc hl
 ld a,(hl)
 and #0x0c
 or c
 ld h,#0x80
 call 0x0024
 di
 ld hl,#0xc000
 ld de,#0xc001
 ld bc,#0x31ff
 ld (hl),#0
 ldir
 call _main
halted:
 jr halted
.area _HOME
.area _CODE
.area _INITIALIZER
.area _GSINIT
.area _GSFINAL
.area _DATA
.area _INITIALIZED
.area _BSEG
.area _BSS
.area _HEAP
