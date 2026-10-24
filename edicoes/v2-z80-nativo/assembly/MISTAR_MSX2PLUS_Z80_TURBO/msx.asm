;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (MINGW64)
;--------------------------------------------------------
	.module msx
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _arcade_ready
	.globl _pixelbyte
	.globl _disk_transfer
	.globl _panasonic_turbo_set
	.globl _panasonic_turbo_init
	.globl _game
	.globl _frames_flushed
	.globl _waiting_kind
	.globl _faultop
	.globl _faultpc
	.globl _disk_buffer
	.globl _disk_sector
	.globl _dirty_any
	.globl _dirty
	.globl _saveslot
	.globl _video_changed
	.globl _video_mode
	.globl _flush
	.globl _hostinit
	.globl _hosttrigger
	.globl _hoststick
	.globl _hostsound
	.globl _host_ready
	.globl _hostkey
	.globl _hostfatal
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_vdata	=	0x0098
_vctrl	=	0x0099
_keys	=	0x00a9
_rowselect	=	0x00aa
_palette	=	0x009a
_psgreg	=	0x00a0
_psgdata	=	0x00a1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_lastkey:
	.ds 1
_diskmode:
	.ds 1
_ram_saved:
	.ds 1
_phase:
	.ds 1
_vram_bank:
	.ds 1
_full_color:
	.ds 1
_dirty::
	.ds 768
_dirty_any::
	.ds 1
_next_write:
	.ds 2
_disk_sector::
	.ds 2
_disk_buffer::
	.ds 2
_faultpc::
	.ds 2
_faultop::
	.ds 1
_waiting_kind::
	.ds 1
_frames_flushed::
	.ds 2
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
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:23: u8 disk_transfer(u8 writing) __naked {
;	---------------------------------
; Function disk_transfer
; ---------------------------------
_disk_transfer::
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:41: __endasm;
	push	ix
	push	iy
	ld	hl,(_disk_buffer)
	ld	de,(_disk_sector)
	ld	bc,#0x02f9
	and	a
	rra
	call	0x0144
	di
	ld	a,#0
	adc	a,#0
	xor	#1
	pop	iy
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:42: }
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:43: u8 saveslot(u8 writing,u8 slot,u8 *buffer){if(diskmode){disk_sector=1400+((u16)(slot-1)<<1);disk_buffer=buffer;return disk_transfer(writing);}if(slot!=1)return 0;if(writing)ram_saved=1;return ram_saved;}
;	---------------------------------
; Function saveslot
; ---------------------------------
_saveslot::
	ld	c, a
	ld	b, l
	ld	a, (_diskmode+0)
	or	a, a
	jr	Z, 00102$
	ld	h, #0x00
	ld	l, b
	dec	hl
	add	hl, hl
	ld	de, #0x0578
	add	hl, de
	ld	(_disk_sector), hl
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	ld	(_disk_buffer+0), a
	ld	a, 1 (iy)
	ld	(_disk_buffer+1), a
	ld	a, c
	call	_disk_transfer
	jp	00107$
00102$:
	dec	b
	jr	Z, 00104$
	xor	a, a
	jp	00107$
00104$:
	ld	a, c
	or	a, a
	jr	Z, 00106$
	ld	iy, #_ram_saved
	ld	0 (iy), #0x01
00106$:
	ld	a, (_ram_saved)
00107$:
	pop	hl
	pop	bc
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:44: static void reg(u8 n,u8 v){vctrl=v;vctrl=0x80|n;}
;	---------------------------------
; Function reg
; ---------------------------------
_reg:
	ld	c, a
	ld	a, l
	out	(_vctrl), a
	ld	a, c
	or	a, #0x80
	out	(_vctrl), a
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:45: static void addr(u16 a){
;	---------------------------------
; Function addr
; ---------------------------------
_addr:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:47: u8 bank=a>>14;if(bank!=vram_bank){reg(14,bank);vram_bank=bank;}
	ld	a, h
	rlca
	rlca
	and	a, #0x03
	ld	c, a
	ld	b, #0x00
	ld	a, (_vram_bank)
	sub	a, c
	jr	Z, 00102$
	push	hl
	push	bc
	ld	l, c
	ld	a, #0x0e
	call	_reg
	pop	bc
	pop	hl
	ld	a, c
	ld	(#_vram_bank), a
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:49: vctrl=(u8)a;vctrl=0x40|((a>>8)&63);
	ld	a, l
	out	(_vctrl), a
	ld	a, h
	and	a, #0x3f
	or	a, #0x40
	out	(_vctrl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:50: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:51: void pixelbyte(u16 offset,u8 value){(void)value;dirty[offset>>3]|=1<<(offset&7);dirty_any=1;}
;	---------------------------------
; Function pixelbyte
; ---------------------------------
_pixelbyte::
	push	ix
	ld	ix,#0
	add	ix,sp
	ex	de, hl
	ld	bc, #_dirty+0
	ld	l, e
	ld	h, d
	srl	h
	rr	l
	srl	h
	rr	l
	srl	h
	rr	l
	add	hl, bc
	ld	c, (hl)
	ld	a, e
	and	a, #0x07
	ld	b, a
	ld	a, #0x01
	inc	b
	jp	00104$
00103$:
	add	a, a
00104$:
	djnz	00103$
	or	a, c
	ld	(hl), a
	ld	iy, #_dirty_any
	ld	0 (iy), #0x01
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:52: void video_changed(u16 offset,u16 length){u16 first=offset>>3,last=(offset+length-1)>>3;memset(dirty+first,255,last-first+1);dirty_any=1;}
;	---------------------------------
; Function video_changed
; ---------------------------------
_video_changed::
	ld	c, l
	ld	b, h
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	add	hl, de
	ex	de, hl
	dec	de
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	hl, #_dirty+0
	add	hl, bc
	ld	a, e
	sub	a, c
	ld	c, a
	ld	a, d
	sbc	a, b
	ld	b, a
	inc	bc
	push	bc
	ld	de, #0x00ff
	call	_memset
	ld	hl, #_dirty_any
	ld	(hl), #0x01
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:53: void video_mode(u8 full_screen){if(full_color!=full_screen){full_color=full_screen;memset(dirty,255,sizeof(dirty));dirty_any=1;}}
;	---------------------------------
; Function video_mode
; ---------------------------------
_video_mode::
	ld	iy, #_full_color
	cp	a, 0 (iy)
	ret	Z
	ld	(_full_color+0), a
	ld	hl, #_dirty
	ld	(hl), #0xff
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x02ff
	ldir
	ld	hl, #_dirty_any
	ld	(hl), #0x01
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:54: static void render(u16 offset){u8 value=video[offset];u8 y=offset>>5;
;	---------------------------------
; Function render
; ---------------------------------
_render:
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	ex	de, hl
	ld	hl, #_video+0
	add	hl, de
	ld	a, (hl)
	ld	-1 (ix), a
	ld	c, e
	ld	b, d
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:58: const u8 *lut=(full_color||(y>=9&&y<104))?artifact:mono;
	ld	a, (_full_color+0)
	or	a, a
	jr	NZ, 00109$
	ld	a, c
	sub	a, #0x09
	jr	C, 00106$
	ld	a, c
	sub	a, #0x68
	jr	NC, 00106$
00109$:
	ld	bc, #_render_artifact_10000_85+0
	jp	00107$
00106$:
	ld	bc, #_render_mono_10000_85+0
00107$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:59: {u16 p=offset<<2;if(p!=next_write||!(p&0x3fff))addr(p);next_write=p+4;}vdata=lut[value>>6];vdata=lut[(value>>4)&3];vdata=lut[(value>>2)&3];vdata=lut[value&3];
	ex	de, hl
	add	hl, hl
	add	hl, hl
	ex	de, hl
	ld	hl, (_next_write)
	cp	a, a
	sbc	hl, de
	jr	NZ, 00101$
	ld	a, e
	or	a, a
	jr	NZ, 00102$
	ld	a, d
	and	a, #0x3f
	jr	NZ, 00102$
00101$:
	push	bc
	ex	de, hl
	push	hl
	call	_addr
	pop	de
	pop	bc
00102$:
	ld	hl, #0x0004
	add	hl, de
	ld	(_next_write), hl
	ld	a, -1 (ix)
	rlca
	rlca
	and	a, #0x03
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	out	(_vdata), a
	ld	a, -1 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a, #0x3
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	out	(_vdata), a
	ld	a, -1 (ix)
	rrca
	rrca
	and	a, #0x3
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	out	(_vdata), a
	ld	a, -1 (ix)
	and	a, #0x03
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	out	(_vdata), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:65: }
	inc	sp
	pop	ix
	ret
_render_artifact_10000_85:
	.db #0x11	; 17
	.db #0x44	; 68	'D'
	.db #0x88	; 136
	.db #0xff	; 255
_render_mono_10000_85:
	.db #0x11	; 17
	.db #0x1f	; 31
	.db #0xf1	; 241
	.db #0xff	; 255
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:66: void flush(void){u16 i,offset;u8 b,n;if(!dirty_any)return;dirty_any=0;next_write=65535;
;	---------------------------------
; Function flush
; ---------------------------------
_flush::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	a, (_dirty_any+0)
	or	a, a
	jr	Z, 00113$
	xor	a, a
	ld	(_dirty_any+0), a
	ld	hl, #0xffff
	ld	(_next_write), hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:67: for(i=0;i<768;i++){b=dirty[i];if(!b)continue;dirty[i]=0;offset=i<<3;for(n=0;n<8;n++,offset++,b>>=1)if(b&1)render(offset);}
	ld	bc, #0x0000
00112$:
	ld	hl, #_dirty
	add	hl, bc
	ld	e, (hl)
	ld	a, e
	or	a, a
	jr	Z, 00108$
	ld	(hl), #0x00
	inc	sp
	inc	sp
	push	bc
	ld	a, #0x03
00159$:
	sla	-2 (ix)
	rl	-1 (ix)
	dec	a
	jr	NZ, 00159$
	ld	d, a
00110$:
	bit	0, e
	jr	Z, 00111$
	push	bc
	push	de
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	call	_render
	pop	de
	pop	bc
00111$:
	inc	d
	inc	-2 (ix)
	jr	NZ, 00161$
	inc	-1 (ix)
00161$:
	srl	e
	ld	a, d
	sub	a, #0x08
	jr	C, 00110$
00108$:
	inc	bc
	ld	a, b
	sub	a, #0x03
	jr	C, 00112$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:68: frames_flushed++;
	ld	bc, (_frames_flushed)
	inc	bc
	ld	(_frames_flushed), bc
00113$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:69: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:70: static void setphase(void){
;	---------------------------------
; Function setphase
; ---------------------------------
_setphase:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:72: reg(16,4);palette=phase?0x70:0x07;palette=4;
	ld	l, #0x04
	ld	a, #0x10
	call	_reg
	ld	a, (_phase+0)
	or	a, a
	ld	a, #0x70
	jr	NZ, 00104$
	ld	a, #0x07
00104$:
	out	(_palette), a
	ld	a, #0x04
	out	(_palette), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:73: reg(16,8);palette=phase?0x07:0x70;palette=4;
	ld	l, #0x08
	ld	a, #0x10
	call	_reg
	ld	a, (_phase+0)
	or	a, a
	ld	a, #0x07
	jr	NZ, 00106$
	ld	a, #0x70
00106$:
	out	(_palette), a
	ld	a, #0x04
	out	(_palette), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:77: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:78: void hostinit(void){u16 i;lastkey=255;phase=0;full_color=0;dirty_any=1;frames_flushed=0;waiting_kind=0;
;	---------------------------------
; Function hostinit
; ---------------------------------
_hostinit::
	ld	hl, #_lastkey
	ld	(hl), #0xff
	xor	a, a
	ld	(_phase+0), a
	ld	(_full_color+0), a
	ld	hl, #_dirty_any
	ld	(hl), #0x01
	ld	hl, #0x0000
	ld	(_frames_flushed), hl
	xor	a, a
	ld	(_waiting_kind+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:79: memset(dirty,255,sizeof(dirty));diskmode=*(const u8*)0xbffe==0xa5;ram_saved=0;
	ld	hl, #_dirty
	ld	(hl), #0xff
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x02ff
	ldir
	ld	a, (#0xbffe)
	sub	a, #0xa5
	ld	a, #0x01
	jr	Z, 00122$
	xor	a, a
00122$:
	ld	(_diskmode+0), a
	xor	a, a
	ld	(_ram_saved+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:80: reg(1,0);reg(7,1);
	ld	l, #0x00
	ld	a, #0x01
	call	_reg
	ld	l, #0x01
	ld	a, #0x07
	call	_reg
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:82: reg(0,6);reg(2,0x1f);reg(5,0xef);reg(6,0);reg(8,2);reg(9,0);reg(10,0);reg(11,1);reg(14,0);vram_bank=0;
	ld	l, #0x06
	xor	a, a
	call	_reg
	ld	l, #0x1f
	ld	a, #0x02
	call	_reg
	ld	l, #0xef
	ld	a, #0x05
	call	_reg
	ld	l, #0x00
	ld	a, #0x06
	call	_reg
	ld	l, #0x02
	ld	a, #0x08
	call	_reg
	ld	l, #0x00
	ld	a, #0x09
	call	_reg
	ld	l, #0x00
	ld	a, #0x0a
	call	_reg
	ld	l, #0x01
	ld	a, #0x0b
	call	_reg
	ld	l, #0x00
	ld	a, #0x0e
	call	_reg
	xor	a, a
	ld	(_vram_bank+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:83: reg(16,1);palette=0;palette=0;reg(16,15);palette=0x77;palette=7;setphase();
	ld	l, #0x01
	ld	a, #0x10
	call	_reg
	xor	a, a
	out	(_palette), a
	xor	a, a
	out	(_palette), a
	ld	l, #0x0f
	ld	a, #0x10
	call	_reg
	ld	a, #0x77
	out	(_palette), a
	ld	a, #0x07
	out	(_palette), a
	call	_setphase
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:84: addr(0);for(i=0;i<24576;i++)vdata=0;vram_bank=255;
	ld	hl, #0x0000
	call	_addr
	ld	bc, #0x0000
00102$:
	xor	a, a
	out	(_vdata), a
	inc	bc
	ld	a, b
	sub	a, #0x60
	jr	C, 00102$
	ld	hl, #_vram_bank
	ld	(hl), #0xff
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:91: reg(1,0x40);
	ld	l, #0x40
	ld	a, #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:92: }
	jp	_reg
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:94: static u8 joystick1(void) __naked {__asm
;	---------------------------------
; Function joystick1
; ---------------------------------
_joystick1:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:103: __endasm;}
	push	ix
	push	iy
	ld	a,#1
	call	0x00d5
	di
	pop	iy
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:104: static u8 trigger1(void) __naked {__asm
;	---------------------------------
; Function trigger1
; ---------------------------------
_trigger1:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:113: __endasm;}
	push	ix
	push	iy
	ld	a,#1
	call	0x00d8
	di
	pop	iy
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:114: void arcade_ready(void) __naked {__asm ret __endasm;}
;	---------------------------------
; Function arcade_ready
; ---------------------------------
_arcade_ready::
	ret	
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:115: u8 hosttrigger(void){u8 row=rowselect,b;rowselect=(row&0xf0)|8;b=keys;rowselect=row;return !(b&1)||trigger1();}
;	---------------------------------
; Function hosttrigger
; ---------------------------------
_hosttrigger::
	in	a, (_rowselect)
	ld	b, a
	and	a, #0xf0
	or	a, #0x08
	out	(_rowselect), a
	in	a, (_keys)
	ld	c, a
	ld	a, b
	out	(_rowselect), a
	ld	a, c
	and	a, #0x01
	jr	Z, 00104$
	call	_trigger1
	or	a,a
	ret	Z
00104$:
	ld	a, #0x01
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:116: u8 hoststick(void){u8 d,j,row,b,n;
;	---------------------------------
; Function hoststick
; ---------------------------------
_hoststick::
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:118: flush();
	call	_flush
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:120: for(n=0;n<6;n++){(void)vctrl;while(!(vctrl&128));}
	ld	c, #0x00
00115$:
	in	a, (_vctrl)
00101$:
	in	a, (_vctrl)
	rlca
	jr	NC, 00101$
	inc	c
	ld	a, c
	sub	a, #0x06
	jr	C, 00115$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:121: arcade_ready();
	call	_arcade_ready
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:122: row=rowselect;rowselect=(row&0xf0)|8;b=keys;rowselect=row;
	in	a, (_rowselect)
	ld	c, a
	and	a, #0xf0
	or	a, #0x08
	out	(_rowselect), a
	in	a, (_keys)
	ld	h, a
	ld	a, c
	out	(_rowselect), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:123: d=0;if(!(b&16))d|=8;if(!(b&32))d|=2;if(!(b&64))d|=1;if(!(b&128))d|=4;
	ld	c, #0x00
	bit	4, h
	jr	NZ, 00106$
	ld	c, #0x08
00106$:
	bit	5, h
	jr	NZ, 00108$
	set	1, c
00108$:
	bit	6, h
	jr	NZ, 00110$
	set	0, c
00110$:
	add	hl, hl
	jr	C, 00112$
	set	2, c
00112$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:124: j=joystick1();if(j<=8)d|=directions[j];return d;
	push	bc
	call	_joystick1
	ld	e, a
	pop	bc
	ld	a, #0x08
	sub	a, e
	jr	C, 00114$
	ld	hl, #_hoststick_directions_10000_110+0
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	or	a, c
	ld	c, a
00114$:
	ld	a, c
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:125: }
	ret
_hoststick_directions_10000_110:
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x01	; 1
	.db #0x09	; 9
	.db #0x08	; 8
	.db #0x0a	; 10
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:128: void hostsound(void){u8 n;psgreg=0;psgdata=90;psgreg=1;psgdata=1;psgreg=8;psgdata=10;for(n=0;n<2;n++){(void)vctrl;while(!(vctrl&128));}psgreg=8;psgdata=0;}
;	---------------------------------
; Function hostsound
; ---------------------------------
_hostsound::
	xor	a, a
	out	(_psgreg), a
	ld	a, #0x5a
	out	(_psgdata), a
	ld	a, #0x01
	out	(_psgreg), a
	ld	a, #0x01
	out	(_psgdata), a
	ld	a, #0x08
	out	(_psgreg), a
	ld	a, #0x0a
	out	(_psgdata), a
	ld	c, #0x00
00105$:
	in	a, (_vctrl)
00101$:
	in	a, (_vctrl)
	rlca
	jr	NC, 00101$
	inc	c
	ld	a, c
	sub	a, #0x02
	jr	C, 00105$
	ld	a, #0x08
	out	(_psgreg), a
	xor	a, a
	out	(_psgdata), a
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:129: void host_ready(void) __naked {__asm ret __endasm;}
;	---------------------------------
; Function host_ready
; ---------------------------------
_host_ready::
	ret	
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:130: u8 hostkey(void){u8 row,col,b,n,found=255,c=0;const char *table="0123456789-=\\[];'/,./?AB" "CDEFGHIJKLMNOPQRSTUVWXYZ";
;	---------------------------------
; Function hostkey
; ---------------------------------
_hostkey::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-10
	add	hl, sp
	ld	sp, hl
	ld	-8 (ix), #0xff
	ld	-3 (ix), #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:131: flush();host_ready();
	call	_flush
	call	_host_ready
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:132: rowselect=(rowselect&0xf0)|6;if(!(keys&32)){if(lastkey!=0xfe){phase^=1;setphase();}lastkey=0xfe;return 0;}
	in	a, (_rowselect)
	and	a, #0xf0
	or	a, #0x06
	out	(_rowselect), a
	in	a, (_keys)
	bit	5, a
	jr	NZ, 00104$
	ld	a, (_lastkey+0)
	sub	a, #0xfe
	jr	Z, 00102$
	ld	a, (_phase+0)
	xor	a, #0x01
	ld	(_phase+0), a
	call	_setphase
00102$:
	ld	hl, #_lastkey
	ld	(hl), #0xfe
	xor	a, a
	jp	00133$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:135: if(!(keys&64)){if(lastkey!=0xfd)panasonic_turbo_set(!turbo_active);lastkey=0xfd;return 0;}
	in	a, (_keys)
	bit	6, a
	jr	NZ, 00166$
	ld	a, (_lastkey+0)
	sub	a, #0xfd
	jr	Z, 00106$
	ld	a, (_turbo_active+0)
	sub	a, #0x01
	ld	a, #0x00
	rla
	call	_panasonic_turbo_set
00106$:
	ld	hl, #_lastkey
	ld	(hl), #0xfd
	xor	a, a
	jp	00133$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:137: for(row=0;row<9;row++){if(row==6)continue;rowselect=(rowselect&0xf0)|row;b=keys;for(col=0;col<8;col++)if(!(b&(1<<col))){n=row*8+col;if(row<6)c=table[n];else if(row==7)c=col==7?13:col==5?8:0;else c=col==0?' ':col==4?8:col==5?0x5e:col==6?10:col==7?9:0;if(c){found=n;break;}}if(found!=255)break;}
00166$:
	ld	-2 (ix), #0x00
00132$:
	ld	a, -2 (ix)
	sub	a, #0x06
	jp	Z, 00124$
	in	a, (_rowselect)
	and	a, #0xf0
	or	a, -2 (ix)
	out	(_rowselect), a
	in	a, (_keys)
	ld	-7 (ix), a
	ld	a, -2 (ix)
	sub	a, #0x06
	ld	a, #0x00
	rla
	ld	-6 (ix), a
	ld	a, -2 (ix)
	sub	a, #0x07
	ld	a, #0x01
	jr	Z, 00298$
	xor	a, a
00298$:
	ld	-5 (ix), a
	ld	-1 (ix), #0x00
00130$:
	ld	b, -1 (ix)
	ld	hl, #0x0001
	inc	b
	jp	00300$
00299$:
	add	hl, hl
00300$:
	djnz	00299$
	ld	a, -7 (ix)
	and	a, l
	ld	-10 (ix), a
	ld	-9 (ix), #0x00
	xor	a, a
	or	a, -10 (ix)
	jp	NZ, 00131$
	ld	a, -2 (ix)
	ld	-3 (ix), a
	add	a, a
	add	a, a
	add	a, a
	ld	-4 (ix), a
	ld	a, -1 (ix)
	ld	-3 (ix), a
	add	a, -4 (ix)
	ld	-4 (ix), a
	ld	a, -6 (ix)
	or	a, a
	jr	Z, 00115$
	ld	a, -4 (ix)
	add	a, #<(___str_0)
	ld	-10 (ix), a
	ld	a, #0x00
	adc	a, #>(___str_0)
	ld	-9 (ix), a
	pop	hl
	push	hl
	ld	a, (hl)
	ld	-3 (ix), a
	jp	00116$
00115$:
	ld	a, -5 (ix)
	or	a, a
	jr	Z, 00112$
	ld	a, -1 (ix)
	sub	a, #0x07
	jr	NZ, 00135$
	ld	-3 (ix), #0x0d
	jp	00116$
00135$:
	ld	a, -1 (ix)
	sub	a, #0x05
	ld	a, #0x08
	jr	Z, 00138$
	xor	a, a
00138$:
	ld	-3 (ix), a
	jp	00116$
00112$:
	ld	a, -1 (ix)
	or	a, a
	jr	NZ, 00139$
	ld	-3 (ix), #0x20
	jp	00140$
00139$:
	ld	a, -1 (ix)
	sub	a, #0x04
	jr	NZ, 00141$
	ld	-3 (ix), #0x08
	jp	00142$
00141$:
	ld	a, -1 (ix)
	sub	a, #0x05
	jr	NZ, 00143$
	ld	-3 (ix), #0x5e
	jp	00144$
00143$:
	ld	a, -1 (ix)
	sub	a, #0x06
	jr	NZ, 00145$
	ld	-3 (ix), #0x0a
	jp	00146$
00145$:
	ld	a, -1 (ix)
	sub	a, #0x07
	ld	a, #0x09
	jr	Z, 00148$
	xor	a, a
00148$:
	ld	-3 (ix), a
00146$:
00144$:
00142$:
00140$:
00116$:
	ld	a, -3 (ix)
	or	a, a
	jr	Z, 00131$
	ld	a, -4 (ix)
	ld	-8 (ix), a
	jp	00121$
00131$:
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x08
	jp	C, 00130$
00121$:
	ld	a, -8 (ix)
	inc	a
	jr	NZ, 00125$
00124$:
	inc	-2 (ix)
	ld	a, -2 (ix)
	sub	a, #0x09
	jp	C, 00132$
00125$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:138: if(found==lastkey)return 0;lastkey=found;if(c)waiting_kind=0;return c;
	ld	a, (_lastkey+0)
	sub	a, -8 (ix)
	jr	NZ, 00127$
	xor	a, a
	jp	00133$
00127$:
	ld	a, -8 (ix)
	ld	(_lastkey+0), a
	ld	a, -3 (ix)
	or	a, a
	jr	Z, 00129$
	xor	a, a
	ld	(_waiting_kind+0), a
00129$:
	ld	a, -3 (ix)
00133$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:139: }
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "0123456789-="
	.db 0x5c
	.ascii "[];'/,./?ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	.db 0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:140: void hostfatal(u16 p,u8 op){faultpc=p;faultop=op;reg(7,6);while(1);}
;	---------------------------------
; Function hostfatal
; ---------------------------------
_hostfatal::
	ld	(_faultpc), hl
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	ld	(_faultop+0), a
	ld	l, #0x06
	ld	a, #0x07
	call	_reg
00102$:
	jp	00102$
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:141: void main(void){
;	---------------------------------
; Function main
; ---------------------------------
_main::
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:143: panasonic_turbo_init();
	call	_panasonic_turbo_init
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:145: game();for(;;);
	call	_game
00103$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\msx.c:146: }
	jp	00103$
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
