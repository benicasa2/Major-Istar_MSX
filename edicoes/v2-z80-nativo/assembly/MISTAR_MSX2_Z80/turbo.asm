;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (MINGW64)
;--------------------------------------------------------
	.module turbo
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _turbo_bypassed
	.globl _turbo_initial
	.globl _turbo_active
	.globl _turbo_available
	.globl _panasonic_turbo_set
	.globl _panasonic_turbo_init
	.globl _panasonic_turbo_restore
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_expanded_id	=	0x0040
_panasonic_control	=	0x0041
_keyboard_row	=	0x00aa
_keyboard_matrix	=	0x00a9
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_turbo_available::
	.ds 1
_turbo_active::
	.ds 1
_turbo_initial::
	.ds 1
_turbo_bypassed::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:11: static u8 select_panasonic(u8 *previous,u8 *control){
;	---------------------------------
; Function select_panasonic
; ---------------------------------
_select_panasonic:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:12: *previous=~expanded_id;
	in	a, (_expanded_id)
	cpl
	ld	(hl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:13: expanded_id=8;
	ld	a, #0x08
	out	(_expanded_id), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:14: if(expanded_id!=0xf7){expanded_id=*previous;return 0;}
	in	a, (_expanded_id)
	sub	a, #0xf7
	jr	Z, 00102$
	ld	a, (hl)
	out	(_expanded_id), a
	xor	a, a
	ret
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:15: *control=panasonic_control;
	in	a, (_panasonic_control)
	ld	(de), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:16: if(*control&4){expanded_id=*previous;return 0;}
	ld	a, (de)
	bit	2, a
	jr	Z, 00104$
	ld	a, (hl)
	out	(_expanded_id), a
	xor	a, a
	ret
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:17: return 1;
	ld	a, #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:18: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:19: void panasonic_turbo_set(u8 enabled){u8 previous,control;
;	---------------------------------
; Function panasonic_turbo_set
; ---------------------------------
_panasonic_turbo_set::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	c, a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:20: if(!select_panasonic(&previous,&control)){turbo_available=0;turbo_active=0;return;}
	push	bc
	ld	hl, #3
	add	hl, sp
	ex	de, hl
	ld	hl, #2
	add	hl, sp
	call	_select_panasonic
	pop	bc
	or	a,a
	jr	NZ, 00102$
	ld	(_turbo_available+0), a
	ld	(_turbo_active+0), a
	jp	00103$
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:21: turbo_available=1;
	ld	hl, #_turbo_available
	ld	(hl), #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:22: panasonic_control=enabled?(control&0xfe):(control|1);
	ld	a, c
	or	a, a
	jr	Z, 00105$
	ld	a, -1 (ix)
	res	0, a
	jp	00106$
00105$:
	ld	a, -1 (ix)
	set	0, a
00106$:
	out	(_panasonic_control), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:23: turbo_active=(panasonic_control&1)==0;
	in	a, (_panasonic_control)
	and	a, #0x01
	ld	a, #0x01
	jr	Z, 00122$
	xor	a, a
00122$:
	ld	(_turbo_active+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:24: expanded_id=previous;
	ld	a, -2 (ix)
	out	(_expanded_id), a
00103$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:25: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:26: void panasonic_turbo_init(void){u8 previous,control,row,shift;
;	---------------------------------
; Function panasonic_turbo_init
; ---------------------------------
_panasonic_turbo_init::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:27: turbo_available=turbo_active=turbo_initial=turbo_bypassed=0;
	xor	a, a
	ld	(_turbo_bypassed+0), a
	ld	(_turbo_initial+0), a
	xor	a, a
	ld	(_turbo_active+0), a
	ld	(_turbo_available+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:28: row=keyboard_row;keyboard_row=(row&0xf0)|6;shift=(keyboard_matrix&1)==0;keyboard_row=row;
	in	a, (_keyboard_row)
	ld	b, a
	and	a, #0xf0
	or	a, #0x06
	out	(_keyboard_row), a
	in	a, (_keyboard_matrix)
	and	a, #0x01
	ld	a, #0x01
	jr	Z, 00123$
	xor	a, a
00123$:
	ld	c, a
	ld	a, b
	out	(_keyboard_row), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:29: if(!select_panasonic(&previous,&control))return;
	push	bc
	ld	hl, #3
	add	hl, sp
	ex	de, hl
	ld	hl, #2
	add	hl, sp
	call	_select_panasonic
	pop	bc
	or	a, a
	jr	Z, 00106$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:30: turbo_available=1;turbo_initial=(control&1)==0;turbo_active=turbo_initial;expanded_id=previous;
	ld	hl, #_turbo_available
	ld	(hl), #0x01
	ld	a, -1 (ix)
	and	a, #0x01
	ld	a, #0x01
	jr	Z, 00125$
	xor	a, a
00125$:
	ld	(_turbo_initial+0), a
	ld	a, (_turbo_initial+0)
	ld	(_turbo_active+0), a
	ld	a, -2 (ix)
	out	(_expanded_id), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:31: if(shift){turbo_bypassed=1;panasonic_turbo_set(0);}
	ld	a, c
	or	a, a
	jr	Z, 00104$
	ld	hl, #_turbo_bypassed
	ld	(hl), #0x01
	xor	a, a
	call	_panasonic_turbo_set
	jp	00106$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:32: else panasonic_turbo_set(1);
	ld	a, #0x01
	call	_panasonic_turbo_set
00106$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:33: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\turbo.c:34: void panasonic_turbo_restore(void){if(turbo_available)panasonic_turbo_set(turbo_initial);}
;	---------------------------------
; Function panasonic_turbo_restore
; ---------------------------------
_panasonic_turbo_restore::
	ld	a, (_turbo_available+0)
	or	a, a
	ret	Z
	ld	a, (_turbo_initial)
	jp	_panasonic_turbo_set
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
