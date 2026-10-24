.module diskboot
.area _BOOT (ABS)
.org 0xc01e
boot:
 di
 ld sp,#0xf300
 ld a,(0xf342)
 ld h,#0x40
 call 0x0024
 di
 ld hl,#0x4000
 ld (destination),hl
 ld hl,#14
 ld (sector),hl
 ld a,#64
 ld (remaining),a
next:
 ld de,(sector)
 ld hl,#0xc200
 ld bc,#0x01f9
 xor a
 call 0x0144
 di
 jr c,error
 ld hl,#0xc200
 ld de,(destination)
 ld bc,#512
 ldir
 ld (destination),de
 ld hl,(sector)
 inc hl
 ld (sector),hl
 ld hl,#remaining
 dec (hl)
 jr nz,next
 jp 0x4040
error:
 ld a,#6
 out (0x99),a
 ld a,#0x87
 out (0x99),a
 jr error
sector: .dw 0
destination: .dw 0
remaining: .db 0
