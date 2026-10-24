;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (MINGW64)
;--------------------------------------------------------
	.module screen
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _video_mode
	.globl _video_changed
	.globl _hostfatal
	.globl _hosttrigger
	.globl _hostkey
	.globl _memmove
	.globl _input_sequence
	.globl _drawing
	.globl _video
	.globl _pair
	.globl _setpair
	.globl _asset
	.globl _assetword
	.globl _native_video_write
	.globl _native_video_fill
	.globl _native_video_scroll
	.globl _glyph
	.globl _text_at
	.globl _native_putchar
	.globl _text_resource
	.globl _text_string
	.globl _newline
	.globl _text_clear
	.globl _scene_clear
	.globl _wait_any
	.globl _input_line
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_video::
	.ds 6144
_drawing::
	.ds 128
_input_sequence::
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
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:7: u16 pair(u8 hi,u8 lo){return ((u16)hi<<8)|lo;}
;	---------------------------------
; Function pair
; ---------------------------------
_pair::
	ld	d, a
	ld	e, l
	ret
_dirtybit:
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x08	; 8
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x40	; 64
	.db #0x80	; 128
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:8: void setpair(u8 *hi,u16 v){hi[0]=v>>8;hi[1]=(u8)v;}
;	---------------------------------
; Function setpair
; ---------------------------------
_setpair::
	ld	(hl), d
	inc	hl
	ld	(hl), e
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:9: u8 asset(u16 a){
;	---------------------------------
; Function asset
; ---------------------------------
_asset::
	ex	de, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:10: if(a>=0x6c00&&a<0x6c80)return drawing[a-0x6c00];
	ld	a, d
	sub	a, #0x6c
	jr	C, 00102$
	ld	a, e
	sub	a, #0x80
	ld	a, d
	sbc	a, #0x6c
	jr	NC, 00102$
	ld	bc, #_drawing+0
	ld	l, e
	ld	a,d
	add	a,#0x94
	ld	h, a
	add	hl, bc
	ld	a, (hl)
	ret
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:11: if(a<0x3b26||a>=0x6c35)return 0;
	ld	a, e
	sub	a, #0x26
	ld	a, d
	sbc	a, #0x3b
	jr	C, 00104$
	ld	a, e
	sub	a, #0x35
	ld	a, d
	sbc	a, #0x6c
	jr	C, 00105$
00104$:
	xor	a, a
	ret
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:12: return *(const u8*)(ASSET_BASE+a-0x3b26);
	ld	hl, #0x50da
	add	hl, de
	ld	a, (hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:13: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:14: u16 assetword(u16 a){return pair(asset(a),asset(a+1));}
;	---------------------------------
; Function assetword
; ---------------------------------
_assetword::
	ld	e, l
	ld	d, h
	inc	de
	ex	de, hl
	push	de
	call	_asset
	ld	c, a
	pop	hl
	push	bc
	call	_asset
	pop	bc
	ld	l, c
	jp	_pair
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:15: void native_video_write(u16 p,u8 v){u16 i=p-0xe00;if(i<6144&&video[i]!=v){video[i]=v;dirty[i>>3]|=dirtybit[i&7];dirty_any=1;}}
;	---------------------------------
; Function native_video_write
; ---------------------------------
_native_video_write::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	ld	e, l
	ld	a,h
	add	a,#0xf2
	ld	d, a
	ld	c, e
	ld	b, d
	ld	a, b
	sub	a, #0x18
	jr	NC, 00104$
	ld	hl, #_video+0
	add	hl, de
	ld	a, (hl)
	sub	a, 4 (ix)
	jr	Z, 00104$
	ld	a, 4 (ix)
	ld	(hl), a
	ld	hl, #_dirty+0
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	add	hl, de
	ex	de, hl
	ld	a, (de)
	ld	-1 (ix), a
	ld	hl, #_dirtybit+0
	ld	a, c
	and	a, #0x07
	ld	c, a
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	or	a, -1 (ix)
	ld	(de), a
	ld	iy, #_dirty_any
	ld	0 (iy), #0x01
00104$:
	inc	sp
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:16: void native_video_fill(u16 a,u16 b,u8 v){if(a<0xe00||b>0x2600||b<a){hostfatal(a,1);return;}memset(video+a-0xe00,v,b-a);if(b>a)video_changed(a-0xe00,b-a);}
;	---------------------------------
; Function native_video_fill
; ---------------------------------
_native_video_fill::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	push	af
	ld	c, l
	ld	b, h
	ld	-2 (ix), e
	ld	-1 (ix), d
	inc	sp
	inc	sp
	push	bc
	ld	a, -5 (ix)
	sub	a, #0x0e
	jr	C, 00101$
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	xor	a, a
	cp	a, e
	ld	a, #0x26
	sbc	a, d
	jr	C, 00101$
	ld	a, -2 (ix)
	sub	a, c
	ld	a, -1 (ix)
	sbc	a, b
	jr	NC, 00102$
00101$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	l, c
	ld	h, b
	call	_hostfatal
	jp	00107$
00102$:
	ld	hl, #_video+0
	add	hl, bc
	ld	e, l
	ld	a,h
	add	a,#0xf2
	ld	d, a
	ld	-4 (ix), e
	ld	-3 (ix), d
	ld	e, 4 (ix)
	ld	d, #0x00
	ld	a, -2 (ix)
	sub	a, c
	ld	l, a
	ld	a, -1 (ix)
	sbc	a, b
	ld	h, a
	push	hl
	pop	iy
	push	hl
	push	bc
	push	iy
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	_memset
	pop	bc
	pop	hl
	ld	a, c
	sub	a, -2 (ix)
	ld	a, b
	sbc	a, -1 (ix)
	jr	NC, 00107$
	ld	a, -6 (ix)
	add	a, #0x00
	ld	c, a
	ld	a, -5 (ix)
	adc	a, #0xf2
	ex	de, hl
	ld	l, c
	ld	h, a
	call	_video_changed
00107$:
	ld	sp, ix
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:17: void native_video_scroll(void){memmove(video+0xd00,video+0xe00,0xa00);memset(video+0x1700,255,256);video_changed(0xd00,0xb00);}
;	---------------------------------
; Function native_video_scroll
; ---------------------------------
_native_video_scroll::
	ld	hl, #0x0a00
	push	hl
	ld	de, #(_video + 3584)
	ld	hl, #(_video + 3328)
	call	_memmove
	ld	hl, #(_video + 5888)
	ld	b, #0x80
00103$:
	ld	(hl), #0xff
	inc	hl
	ld	(hl), #0xff
	inc	hl
	djnz	00103$
	ld	de, #0x0b00
	ld	hl, #0x0d00
	jp	_video_changed
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:18: void glyph(u16 p,u8 c){u16 f=0x3b26+((u16)(u8)(c-32)<<3);u8 i;for(i=0;i<8;i++,p+=32)native_video_write(p,asset(f++)^drawing[0x37]);}
;	---------------------------------
; Function glyph
; ---------------------------------
_glyph::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	ex	de, hl
	ld	a, 4 (ix)
	add	a, #0xe0
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #0x3b26
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	-1 (ix), #0x00
00102$:
	ld	l, c
	ld	h, b
	inc	bc
	push	bc
	push	de
	call	_asset
	pop	de
	pop	bc
	ld	hl, #(_drawing + 55)
	ld	l, (hl)
	xor	a, l
	push	bc
	push	de
	push	af
	inc	sp
	ex	de,hl
	call	_native_video_write
	pop	de
	pop	bc
	inc	-1 (ix)
	ld	hl, #0x0020
	add	hl, de
	ex	de, hl
	ld	a, -1 (ix)
	sub	a, #0x08
	jr	C, 00102$
	inc	sp
	pop	ix
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:19: static u16 cursor(void){return pair(drawing[0x35],drawing[0x36]);}
;	---------------------------------
; Function cursor
; ---------------------------------
_cursor:
	ld	hl, #_drawing + 54
	ld	l, (hl)
	ld	a, (#_drawing + 53)
	jp	_pair
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:20: void text_at(u16 p){setpair(drawing+0x35,p);drawing[0x39]=drawing[0x3a]=0;}
;	---------------------------------
; Function text_at
; ---------------------------------
_text_at::
	ex	de, hl
	ld	hl, #(_drawing + 53)
	call	_setpair
	ld	hl, #_drawing + 58
	ld	(hl), #0x00
	ld	hl, #(_drawing + 57)
	ld	(hl), #0x00
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:21: static void move_cursor(u16 p){
;	---------------------------------
; Function move_cursor
; ---------------------------------
_move_cursor:
	ex	de, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:22: if(p>=0xf20&&(p&255)>=32)p=(p&0xff00)+256;
	ld	c, e
	ld	b, d
	ld	a, c
	sub	a, #0x20
	ld	a, b
	sbc	a, #0x0f
	jr	C, 00102$
	ld	a, c
	sub	a, #0x20
	jr	C, 00102$
	ld	e, #0x00
	ld	d, b
	inc	d
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:23: setpair(drawing+0x35,p);
	push	de
	ld	hl, #(_drawing + 53)
	call	_setpair
	pop	de
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:24: if(p>=0x2600){native_video_scroll();setpair(drawing+0x35,0x2500);}
	ld	a, d
	sub	a, #0x26
	ret	C
	call	_native_video_scroll
	ld	de, #0x2500
	ld	hl, #(_drawing + 53)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:25: }
	jp	_setpair
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:26: static void wrap(u8 c){u8 n,i;u16 p,x;
;	---------------------------------
; Function wrap
; ---------------------------------
_wrap:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-9
	add	hl, sp
	ld	sp, hl
	ld	-5 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:27: if(c<=32){drawing[0x39]=drawing[0x3a]=0;return;}
	ld	a, #0x20
	sub	a, -5 (ix)
	jr	C, 00102$
	ld	hl, #_drawing + 58
	ld	(hl), #0x00
	ld	hl, #(_drawing + 57)
	ld	(hl), #0x00
	jp	00118$
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:28: n=drawing[0x39];if(n<=14){drawing[0x3b+n]=c;drawing[0x39]=++n;}
	ld	a, (#(_drawing + 57) + 0)
	ld	-4 (ix), a
	ld	a, #0x0e
	sub	a, -4 (ix)
	jr	C, 00104$
	ld	a, -4 (ix)
	add	a, #0x3b
	ld	l, a
	ld	h, #0x00
	ld	de, #_drawing
	add	hl, de
	ld	a, -5 (ix)
	ld	(hl), a
	inc	-4 (ix)
	ld	hl, #(_drawing + 57)
	ld	a, -4 (ix)
	ld	(hl), a
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:29: p=cursor();if((p&31)||!drawing[0x3a]){drawing[0x3a]=1;return;}
	call	_cursor
	inc	sp
	inc	sp
	push	de
	ld	hl, #_drawing + 58
	ld	a, -9 (ix)
	and	a, #0x1f
	jr	NZ, 00105$
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
00105$:
	ld	(hl), #0x01
	jp	00118$
00106$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:30: if(n>14){drawing[0x39]=drawing[0x3a]=0;return;}
	ld	a, #0x0e
	sub	a, -4 (ix)
	jr	NC, 00109$
	ld	(hl), #0x00
	ld	hl, #(_drawing + 57)
	ld	(hl), #0x00
	jp	00118$
00109$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:31: x=p-pair(drawing[0x38],drawing[0x39]);x=(x&0xff00)|(x&31);
	ld	hl, #(_drawing + 57)
	ld	l, (hl)
	ld	a, (#_drawing + 56)
	call	_pair
	ld	a, -9 (ix)
	sub	a, e
	ld	e, a
	ld	a, -8 (ix)
	sbc	a, d
	ld	b, a
	ld	a, e
	and	a, #0x1f
	ld	-3 (ix), a
	ld	-2 (ix), b
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:32: for(i=0;i<n;i++)glyph(x++,' ');
	ld	-1 (ix), #0x00
00113$:
	ld	a, -1 (ix)
	sub	a, -4 (ix)
	jr	NC, 00110$
	ld	a, -3 (ix)
	ld	-7 (ix), a
	ld	a, -2 (ix)
	ld	-6 (ix), a
	inc	-3 (ix)
	jr	NZ, 00180$
	inc	-2 (ix)
00180$:
	ld	a, #0x20
	push	af
	inc	sp
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	call	_glyph
	inc	-1 (ix)
	jp	00113$
00110$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:33: for(i=0;i+1<n;i++)glyph(p++,drawing[0x3b+i]);
	pop	bc
	push	bc
	ld	-1 (ix), #0x00
00116$:
	ld	a, -1 (ix)
	ld	-3 (ix), a
	ld	-2 (ix), #0x00
	ld	e, -3 (ix)
	ld	d, #0x00
	inc	de
	ld	l, -4 (ix)
	ld	h, #0x00
	ld	a, e
	sub	a, l
	ld	a, d
	sbc	a, h
	jr	NC, 00111$
	ld	l, -3 (ix)
	ld	h, #0x00
	ld	de, #0x003b
	add	hl, de
	ld	de, #_drawing
	add	hl, de
	ld	a, (hl)
	ld	l, c
	ld	h, b
	inc	bc
	push	bc
	push	af
	inc	sp
	call	_glyph
	pop	bc
	inc	-1 (ix)
	jp	00116$
00111$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:34: setpair(drawing+0x35,p);drawing[0x39]=drawing[0x3a]=0;
	ld	e, c
	ld	d, b
	ld	hl, #(_drawing + 53)
	call	_setpair
	ld	hl, #(_drawing + 58)
	ld	(hl), #0x00
	dec	hl
	ld	(hl), #0x00
00118$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:35: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:36: void native_putchar(u8 c){u16 p;wrap(c);p=cursor();
;	---------------------------------
; Function native_putchar
; ---------------------------------
_native_putchar::
	ld	c, a
	push	bc
	ld	a, c
	call	_wrap
	call	_cursor
	pop	bc
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:37: if(c==8){if(p==0x1b00)return;glyph(p,' ');p--;if(p&128)p-=0xe0;glyph(p,' ');move_cursor(p);}
	ld	a, c
	sub	a, #0x08
	jr	NZ, 00114$
	ld	c, e
	ld	b, d
	ld	a, c
	or	a, a
	jr	NZ, 00102$
	ld	a, b
	sub	a, #0x1b
	ret	Z
00102$:
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	ex	de,hl
	call	_glyph
	pop	hl
	dec	hl
	bit	7, l
	jr	Z, 00104$
	ld	a, l
	add	a, #0x20
	ld	l, a
	ld	a, h
	adc	a, #0xff
	ld	h, a
00104$:
	push	hl
	ld	a, #0x20
	push	af
	inc	sp
	call	_glyph
	pop	hl
	jp	_move_cursor
00114$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:38: else if(c==13){do{glyph(p++,' ');}while(p&31);move_cursor(p+0xe0);}
	ld	a, c
	sub	a, #0x0d
	jr	NZ, 00111$
00105$:
	ld	l, e
	ld	h, d
	inc	de
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	call	_glyph
	pop	de
	ld	a, e
	and	a, #0x1f
	jr	NZ, 00105$
	ld	hl, #0x00e0
	add	hl, de
	jp	_move_cursor
00111$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:39: else if(c>=32){glyph(p,c);move_cursor(p+1);}
	ld	a, c
	sub	a, #0x20
	ret	C
	push	de
	ld	a, c
	push	af
	inc	sp
	ex	de,hl
	call	_glyph
	pop	de
	inc	de
	ex	de, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:40: }
	jp	_move_cursor
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:41: void text_resource(u16 p){u8 c;while((c=asset(p++))!=0)native_putchar(c);}
;	---------------------------------
; Function text_resource
; ---------------------------------
_text_resource::
	ex	de, hl
00101$:
	ld	l, e
	ld	h, d
	inc	de
	push	de
	call	_asset
	pop	de
	ld	c, a
	or	a, a
	ret	Z
	push	de
	ld	a, c
	call	_native_putchar
	pop	de
	jp	00101$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:42: void text_string(const char *s){while(*s)native_putchar(*s++);}
;	---------------------------------
; Function text_string
; ---------------------------------
_text_string::
00101$:
	ld	a, (hl)
	or	a, a
	ret	Z
	inc	hl
	push	hl
	call	_native_putchar
	pop	hl
	jp	00101$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:43: void newline(void){native_putchar(13);}
;	---------------------------------
; Function newline
; ---------------------------------
_newline::
	ld	a, #0x0d
	jp	_native_putchar
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:44: void text_clear(void){text_at(0x1b00);native_video_fill(0x1b00,0x2600,255);}
;	---------------------------------
; Function text_clear
; ---------------------------------
_text_clear::
	ld	hl, #0x1b00
	call	_text_at
	ld	a, #0xff
	push	af
	inc	sp
	ld	de, #0x2600
	ld	hl, #0x1b00
	call	_native_video_fill
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:45: void scene_clear(void){video_mode(0);native_video_fill(0xe00,0x1ae0,0);drawing[0x37]=0;}
;	---------------------------------
; Function scene_clear
; ---------------------------------
_scene_clear::
	xor	a, a
	call	_video_mode
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x1ae0
	ld	hl, #0x0e00
	call	_native_video_fill
	ld	hl, #_drawing+55
	ld	(hl), #0x00
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:46: void wait_any(void){u8 k;waiting_kind=1;do{k=hostkey();}while(!k&&!hosttrigger());waiting_kind=0;newline();newline();}
;	---------------------------------
; Function wait_any
; ---------------------------------
_wait_any::
	ld	hl, #_waiting_kind
	ld	(hl), #0x01
00102$:
	call	_hostkey
	or	a, a
	jr	NZ, 00104$
	call	_hosttrigger
	or	a, a
	jr	Z, 00102$
00104$:
	xor	a, a
	ld	(_waiting_kind+0), a
	call	_newline
	jp	_newline
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:47: void input_line(char *b){u8 c,n=0,i;const char *word;input_sequence++;waiting_kind=2;
;	---------------------------------
; Function input_line
; ---------------------------------
_input_line::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	dec	sp
	ld	-3 (ix), l
	ld	-2 (ix), h
	ld	-1 (ix), #0x00
	ld	bc, (_input_sequence)
	inc	bc
	ld	(_input_sequence), bc
	ld	hl, #_waiting_kind
	ld	(hl), #0x02
00128$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:48: for(;;){c=hostkey();if(!c)continue;
	call	_hostkey
	ld	c, a
	or	a, a
	jr	Z, 00128$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:49: if(!n&&(c==0x5e||c==10||c==9||c==8)){word=c==0x5e?"NORTH":c==10?"SOUTH":c==9?"EAST":"WEST";for(i=0;word[i];i++){b[n++]=word[i];native_putchar(word[i]);}c=13;}
	ld	a, -1 (ix)
	or	a, a
	jr	NZ, 00105$
	ld	a, c
	sub	a, #0x5e
	ld	a, #0x01
	jr	Z, 00272$
	xor	a, a
00272$:
	ld	b, a
	or	a, a
	jr	NZ, 00104$
	ld	a,c
	cp	a,#0x0a
	jr	Z, 00104$
	cp	a,#0x09
	jr	Z, 00104$
	sub	a, #0x08
	jr	NZ, 00105$
00104$:
	ld	a, b
	or	a, a
	jr	Z, 00131$
	ld	de, #___str_0
	jp	00132$
00131$:
	ld	a, c
	sub	a, #0x0a
	jr	NZ, 00133$
	ld	de, #___str_1
	jp	00134$
00133$:
	ld	a, c
	sub	a, #0x09
	jr	NZ, 00135$
	ld	de, #___str_2
	jp	00136$
00135$:
	ld	de, #___str_3
00136$:
00134$:
00132$:
	ld	c, -1 (ix)
	ld	-1 (ix), #0x00
00126$:
	ld	l, -1 (ix)
	ld	h, #0x00
	add	hl, de
	ld	b, (hl)
	ld	a, b
	or	a, a
	jr	Z, 00156$
	ld	a, -3 (ix)
	add	a, c
	ld	-5 (ix), a
	ld	a, -2 (ix)
	adc	a, #0x00
	ld	-4 (ix), a
	inc	c
	push	hl
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), b
	pop	hl
	ld	a, (hl)
	push	bc
	push	de
	call	_native_putchar
	pop	de
	pop	bc
	inc	-1 (ix)
	jp	00126$
00156$:
	ld	-1 (ix), c
	ld	c, #0x0d
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:50: if(c==13){b[n]=0;newline();break;}
	ld	a, c
	sub	a, #0x0d
	jr	NZ, 00111$
	ld	a, -1 (ix)
	add	a, -3 (ix)
	ld	l, a
	ld	a, #0x00
	adc	a, -2 (ix)
	ld	h, a
	ld	(hl), #0x00
	call	_newline
	jp	00124$
00111$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:51: if(c==8){if(n){n--;native_putchar(8);}continue;}
	ld	a, c
	sub	a, #0x08
	jr	NZ, 00115$
	ld	a, -1 (ix)
	or	a, a
	jp	Z, 00128$
	dec	-1 (ix)
	ld	a, #0x08
	call	_native_putchar
	jp	00128$
00115$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:52: if(c>=32&&c<127&&n<63){if(c>='a'&&c<='z')c-=32;b[n++]=c;native_putchar(c);}
	ld	a,c
	cp	a,#0x20
	jp	C,00128$
	sub	a, #0x7f
	jp	NC, 00128$
	ld	a, -1 (ix)
	sub	a, #0x3f
	jp	NC, 00128$
	ld	a, c
	sub	a, #0x61
	jr	C, 00117$
	ld	a, #0x7a
	sub	a, c
	jr	C, 00117$
	ld	a, c
	add	a, #0xe0
	ld	c, a
00117$:
	ld	e, -1 (ix)
	inc	-1 (ix)
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	ld	d, #0x00
	add	hl, de
	ld	(hl), c
	ld	a, c
	call	_native_putchar
	jp	00128$
00124$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:54: waiting_kind=0;
	xor	a, a
	ld	(_waiting_kind+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\screen.c:55: }
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii "NORTH"
	.db 0x00
___str_1:
	.ascii "SOUTH"
	.db 0x00
___str_2:
	.ascii "EAST"
	.db 0x00
___str_3:
	.ascii "WEST"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
