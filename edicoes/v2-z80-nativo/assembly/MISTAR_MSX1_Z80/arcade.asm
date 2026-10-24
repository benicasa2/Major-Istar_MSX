;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (MINGW64)
;--------------------------------------------------------
	.module arcade
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hoststick
	.globl _wait_any
	.globl _scene_clear
	.globl _text_resource
	.globl _text_clear
	.globl _native_video_write
	.globl _glyph
	.globl _draw
	.globl _assetword
	.globl _asset
	.globl _arcade_lives
	.globl _arcade_tick
	.globl _arcade_velocity
	.globl _arcade_enemy
	.globl _arcade_player
	.globl _arcade_kind
	.globl _docking
	.globl _security
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_arcade_kind::
	.ds 1
_arcade_player::
	.ds 2
_arcade_enemy::
	.ds 24
_arcade_velocity::
	.ds 12
_arcade_tick::
	.ds 1
_arcade_lives::
	.ds 1
_platform_x:
	.ds 1
_platform_dx:
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
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:9: static u8 bitmap(u16 p){return p>=0xe00&&p<0x2600?video[p-0xe00]:255;}
;	---------------------------------
; Function bitmap
; ---------------------------------
_bitmap:
	ex	de, hl
	ld	a,d
	cp	a,#0x0e
	jr	C, 00103$
	sub	a, #0x26
	jr	NC, 00103$
	ld	c, e
	ld	a,d
	add	a,#0xf2
	ld	b, a
	ld	hl, #_video
	add	hl, bc
	ld	a, (hl)
	ret
00103$:
	ld	a, #0xff
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:10: static void platform(void){
;	---------------------------------
; Function platform
; ---------------------------------
_platform:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:11: native_video_write(0x1a00+platform_x,0);
	ld	a, (_platform_x)
	ld	e, a
	ld	d, #0x1a
	xor	a, a
	push	af
	inc	sp
	ex	de, hl
	call	_native_video_write
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:12: platform_x+=platform_dx;
	ld	a, (_platform_x)
	ld	hl, #_platform_dx
	add	a, (hl)
	ld	(_platform_x+0), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:13: if(platform_x<=2||platform_x>=29){platform_dx=-platform_dx;platform_x+=platform_dx;}
	ld	a, #0x02
	ld	iy, #_platform_x
	sub	a, 0 (iy)
	jr	NC, 00101$
	ld	a, (_platform_x+0)
	sub	a, #0x1d
	jr	C, 00102$
00101$:
	ld	hl, #_platform_dx
	xor	a, a
	sub	a, (hl)
	ld	(hl), a
	ld	a, (_platform_x)
	ld	hl, #_platform_dx
	add	a, (hl)
	ld	(_platform_x+0), a
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:14: native_video_write(0x1a00+platform_x,0xaa);arcade_tick++;
	ld	a, (_platform_x)
	ld	e, a
	ld	d, #0x1a
	ld	a, #0xaa
	push	af
	inc	sp
	ex	de, hl
	call	_native_video_write
	ld	hl, #_arcade_tick
	inc	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:15: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:16: static void arcade_message(u16 message){drawing[0x37]=255;text_clear();text_resource(message);text_resource(0x4062);wait_any();}
;	---------------------------------
; Function arcade_message
; ---------------------------------
_arcade_message:
	ex	de, hl
	ld	hl, #_drawing+55
	ld	(hl), #0xff
	push	de
	call	_text_clear
	pop	de
	ex	de, hl
	call	_text_resource
	ld	hl, #0x4062
	call	_text_resource
	jp	_wait_any
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:17: static void ship(u16 p,u8 erase){glyph(p,erase?' ':0x86);glyph(p+1,erase?' ':0x87);}
;	---------------------------------
; Function ship
; ---------------------------------
_ship:
	ex	de, hl
	ld	hl, #2
	add	hl, sp
	ld	a, (hl)
	or	a, a
	ld	a, #0x20
	jr	NZ, 00104$
	ld	a, #0x86
00104$:
	push	de
	push	af
	inc	sp
	ex	de,hl
	call	_glyph
	pop	de
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	or	a, a
	ld	a, #0x20
	jr	NZ, 00106$
	ld	a, #0x87
00106$:
	inc	de
	push	af
	inc	sp
	ex	de, hl
	call	_glyph
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:18: u8 docking(void){u8 i,d,n,collision;u16 q,p;arcade_kind=1;
;	---------------------------------
; Function docking
; ---------------------------------
_docking::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
	ld	hl, #_arcade_kind
	ld	(hl), #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:19: scene_clear();draw(0x5c46);drawing[0x37]=0;
	call	_scene_clear
	ld	hl, #0x5c46
	call	_draw
	ld	hl, #(_drawing + 55)
	ld	(hl), #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:20: for(i=0;i<12;i++){arcade_enemy[i]=assetword(0x4b18+(u16)i*2);glyph(arcade_enemy[i],0x88);}
	ld	c, #0x00
00134$:
	ld	l, c
	ld	h, #0x00
	add	hl, hl
	ld	de, #_arcade_enemy
	add	hl, de
	ld	e, c
	ld	d, #0x00
	ld	a, e
	add	a, a
	rl	d
	add	a, #0x18
	ld	e, a
	ld	a, d
	adc	a, #0x4b
	ld	d, a
	push	hl
	push	bc
	ex	de, hl
	call	_assetword
	pop	bc
	pop	hl
	ld	(hl), e
	inc	hl
	ld	(hl), d
	push	bc
	ld	a, #0x88
	push	af
	inc	sp
	ex	de, hl
	call	_glyph
	pop	bc
	inc	c
	ld	a, c
	sub	a, #0x0c
	jr	C, 00134$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:21: arcade_player=0x1243;ship(arcade_player,0);arcade_tick=0;platform_x=15;platform_dx=1;
	ld	hl, #0x1243
	ld	(_arcade_player), hl
	xor	a, a
	push	af
	inc	sp
	call	_ship
	xor	a, a
	ld	(_arcade_tick+0), a
	ld	hl, #_platform_x
	ld	(hl), #0x0f
	ld	hl, #_platform_dx
	ld	(hl), #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:22: arcade_message(0x497b);drawing[0x37]=0;
	ld	hl, #0x497b
	call	_arcade_message
	ld	hl, #(_drawing + 55)
	ld	(hl), #0x00
00145$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:24: d=hoststick();q=arcade_player;
	call	_hoststick
	ld	c, a
	ld	de, (_arcade_player)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:25: if(d&8)q--;else if(d&4)q++;
	bit	3, c
	jr	Z, 00105$
	dec	de
	jp	00106$
00105$:
	bit	2, c
	jr	Z, 00106$
	inc	de
00106$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:26: if(d&2)q-=256;else if(d&1)q+=256;
	bit	1, c
	jr	Z, 00110$
	dec	d
	jp	00111$
00110$:
	bit	0, c
	jr	Z, 00111$
	inc	d
00111$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:27: if(d){
	ld	a, c
	or	a, a
	jp	Z, 00167$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:28: n=q&31;
	ld	a, e
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:29: if(!n||n>=29||q<0x1040){arcade_kind=0;return 0;}
	and	a, #0x1f
	jr	Z, 00112$
	sub	a, #0x1d
	jr	NC, 00112$
	inc	sp
	inc	sp
	push	de
	ld	a, -3 (ix)
	sub	a, #0x40
	ld	a, -2 (ix)
	sbc	a, #0x10
	jr	NC, 00113$
00112$:
	xor	a, a
	ld	(_arcade_kind+0), a
	jp	00147$
00113$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:30: ship(arcade_player,1);collision=0;
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, (_arcade_player)
	call	_ship
	pop	de
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:31: for(i=0;i<8;i++){p=q+(u16)i*32;collision|=bitmap(p)|bitmap(p+1);}
	ld	bc, #0x0
00136$:
	ld	l, b
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, -3 (ix)
	ld	l, a
	ld	a, h
	adc	a, -2 (ix)
	ld	h, a
	push	hl
	push	bc
	push	de
	call	_bitmap
	ld	-1 (ix), a
	pop	de
	pop	bc
	pop	hl
	inc	hl
	push	bc
	push	de
	call	_bitmap
	pop	de
	pop	bc
	or	a, -1 (ix)
	or	a, c
	ld	c, a
	inc	b
	ld	a, b
	sub	a, #0x08
	jr	C, 00136$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:32: if(collision){arcade_kind=0;return 2;}
	ld	a, c
	or	a, a
	jr	Z, 00118$
	xor	a, a
	ld	(_arcade_kind+0), a
	ld	a, #0x02
	jp	00147$
00118$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:33: arcade_player=q;ship(q,0);
	ld	(_arcade_player), de
	xor	a, a
	push	af
	inc	sp
	ex	de, hl
	call	_ship
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:34: if(q==0x1853){
	ld	a, -3 (ix)
	sub	a, #0x53
	jr	NZ, 00167$
	ld	a, -2 (ix)
	sub	a, #0x18
	jr	NZ, 00167$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:35: for(i=0;i<20;i++){platform();}
	ld	b, #0x14
00140$:
	push	bc
	call	_platform
	pop	bc
	djnz	00140$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:36: arcade_message(0x40b9);arcade_kind=0;return 1;
	ld	hl, #0x40b9
	call	_arcade_message
	xor	a, a
	ld	(_arcade_kind+0), a
	ld	a, #0x01
	jp	00147$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:39: for(i=0;i<12;i++){
00167$:
	ld	c, #0x00
00141$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:40: q=arcade_enemy[i];
	ld	a, c
	ld	b, #0x00
	add	a, a
	rl	b
	add	a, #<(_arcade_enemy)
	ld	-2 (ix), a
	ld	a, b
	adc	a, #>(_arcade_enemy)
	ld	-1 (ix), a
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:41: if(!(arcade_tick&7)){glyph(q,' ');q-=256;if(q<0x1040)q+=0x800;arcade_enemy[i]=q;}
	ld	a, (_arcade_tick)
	and	a, #0x07
	jr	NZ, 00127$
	push	bc
	push	de
	ld	a, #0x20
	push	af
	inc	sp
	ex	de,hl
	call	_glyph
	pop	de
	pop	bc
	dec	d
	ld	b, e
	ld	l, d
	ld	a, b
	sub	a, #0x40
	ld	a, l
	sbc	a, #0x10
	jr	NC, 00125$
	ld	a, l
	add	a, #0x08
	ld	e, b
	ld	d, a
00125$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), e
	inc	hl
	ld	(hl), d
00127$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:42: if(q==arcade_player||q==arcade_player+1){arcade_kind=0;return 2;}
	ld	hl, (_arcade_player)
	cp	a, a
	sbc	hl, de
	jr	Z, 00128$
	ld	hl, (_arcade_player)
	inc	hl
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	b, e
	ld	l, d
	ld	a, -2 (ix)
	sub	a, b
	jr	NZ, 00129$
	ld	a, -1 (ix)
	sub	a, l
	jr	NZ, 00129$
00128$:
	xor	a, a
	ld	(_arcade_kind+0), a
	ld	a, #0x02
	jp	00147$
00129$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:43: glyph(q,0x88);
	push	bc
	ld	a, #0x88
	push	af
	inc	sp
	ex	de, hl
	call	_glyph
	pop	bc
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:39: for(i=0;i<12;i++){
	inc	c
	ld	a, c
	sub	a, #0x0c
	jp	C, 00141$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:45: p=0x1953;for(i=0;i<2;i++,p+=32){native_video_write(p,bitmap(p)^255);native_video_write(p+1,bitmap(p+1)^255);}
	ld	hl, #0x1953
	ex	(sp), hl
	ld	-1 (ix), #0x00
00143$:
	pop	hl
	push	hl
	call	_bitmap
	cpl
	push	af
	inc	sp
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	call	_native_video_write
	pop	bc
	push	bc
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	push	bc
	call	_bitmap
	pop	bc
	pop	hl
	cpl
	push	bc
	push	af
	inc	sp
	call	_native_video_write
	pop	bc
	inc	-1 (ix)
	ld	hl, #0x0020
	add	hl, bc
	ex	(sp), hl
	ld	a, -1 (ix)
	sub	a, #0x02
	jr	C, 00143$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:46: platform();
	call	_platform
	jp	00145$
00147$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:48: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:49: static u8 robot_collision(void){u8 i;for(i=0;i<5;i++)if(arcade_player==arcade_enemy[i])return 1;return 0;}
;	---------------------------------
; Function robot_collision
; ---------------------------------
_robot_collision:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	bc, #_arcade_enemy+0
	ld	e, #0x00
00104$:
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	add	hl, bc
	ld	a, (hl)
	ld	-2 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-1 (ix), a
	ld	a, (_arcade_player+0)
	sub	a, -2 (ix)
	jr	NZ, 00105$
	ld	a, (_arcade_player+1)
	sub	a, -1 (ix)
	jr	NZ, 00105$
	ld	a, #0x01
	jp	00106$
00105$:
	inc	e
	ld	a, e
	sub	a, #0x05
	jr	C, 00104$
	xor	a, a
00106$:
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:50: static void robots(void){u8 i,col;u16 p;
;	---------------------------------
; Function robots
; ---------------------------------
_robots:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-11
	add	hl, sp
	ld	sp, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:51: for(i=0;i<5;i++){
	ld	-1 (ix), #0x00
00112$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:52: p=arcade_enemy[i];glyph(p,' ');
	ld	a, -1 (ix)
	ld	c, #0x00
	add	a, a
	rl	c
	add	a, #<(_arcade_enemy)
	ld	-11 (ix), a
	ld	a, c
	adc	a, #>(_arcade_enemy)
	ld	-10 (ix), a
	pop	hl
	push	hl
	ld	a, (hl)
	ld	-9 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-8 (ix), a
	ld	a, #0x20
	push	af
	inc	sp
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_glyph
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:53: if(!bitmap(p+256))p+=512;
	ld	a, -9 (ix)
	ld	-7 (ix), a
	ld	a, -8 (ix)
	ld	-6 (ix), a
	ld	l, -7 (ix)
	ld	a, -6 (ix)
	inc	a
	ld	h, a
	call	_bitmap
	or	a, a
	jr	NZ, 00109$
	ld	c, -7 (ix)
	ld	a, -6 (ix)
	add	a, #0x02
	ld	-9 (ix), c
	ld	-8 (ix), a
	jp	00110$
00109$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:55: col=(p&31)+arcade_velocity[i];
	ld	a, -9 (ix)
	and	a, #0x1f
	ld	c, a
	ld	a, #<(_arcade_velocity)
	add	a, -1 (ix)
	ld	-5 (ix), a
	ld	a, #>(_arcade_velocity)
	adc	a, #0x00
	ld	-4 (ix), a
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	a, (hl)
	ld	-3 (ix), a
	ld	a, c
	add	a, -3 (ix)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:56: if(!col||col>=31){
	ld	-2 (ix), a
	or	a, a
	jr	Z, 00104$
	ld	a, -2 (ix)
	sub	a, #0x1f
	jr	C, 00105$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:57: if((p>>8)==0x17)p=col==0?0x0f9d:0x0f81;
	ld	a, -8 (ix)
	sub	a, #0x17
	jr	NZ, 00102$
	ld	a, -2 (ix)
	or	a, a
	jr	NZ, 00116$
	ld	-3 (ix), #0x9d
	ld	-2 (ix), #0x0f
	jp	00117$
00116$:
	ld	-3 (ix), #0x81
	ld	-2 (ix), #0x0f
00117$:
	ld	a, -3 (ix)
	ld	-9 (ix), a
	ld	a, -2 (ix)
	ld	-8 (ix), a
	jp	00110$
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:58: else arcade_velocity[i]=-arcade_velocity[i];
	xor	a, a
	sub	a, -3 (ix)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), a
	jp	00110$
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:59: }else p+=arcade_velocity[i];
	ld	a, -3 (ix)
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	add	hl, bc
	ld	-9 (ix), l
	ld	-8 (ix), h
00110$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:61: arcade_enemy[i]=p;glyph(p,0x84);
	pop	hl
	push	hl
	ld	a, -9 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -8 (ix)
	ld	(hl), a
	ld	a, #0x84
	push	af
	inc	sp
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_glyph
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:51: for(i=0;i<5;i++){
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x05
	jp	C, 00112$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:63: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:64: u8 security(u8 from_above){u8 i,d,col,killed,won;u16 q;
;	---------------------------------
; Function security
; ---------------------------------
_security::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-8
	add	hl, sp
	ld	sp, hl
	ld	-2 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:65: arcade_kind=2;arcade_lives=3;
	ld	hl, #_arcade_kind
	ld	(hl), #0x02
	ld	hl, #_arcade_lives
	ld	(hl), #0x03
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:66: while(arcade_lives){
00129$:
	ld	a, (_arcade_lives+0)
	or	a, a
	jp	Z, 00131$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:67: scene_clear();draw(0x5c8c);drawing[0x37]=0;glyph(0xe3a,0x85);glyph(0xe3c,'0'+arcade_lives);
	call	_scene_clear
	ld	hl, #0x5c8c
	call	_draw
	ld	hl, #(_drawing + 55)
	ld	(hl), #0x00
	ld	a, #0x85
	push	af
	inc	sp
	ld	hl, #0x0e3a
	call	_glyph
	ld	a, (_arcade_lives)
	add	a, #0x30
	push	af
	inc	sp
	ld	hl, #0x0e3c
	call	_glyph
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:68: for(i=0;i<5;i++){
	ld	-1 (ix), #0x00
00132$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:69: arcade_enemy[i]=assetword(0x4b06+(u16)i*3);
	ld	a, -1 (ix)
	ld	-4 (ix), a
	ld	-3 (ix), #0x00
	sla	-4 (ix)
	rl	-3 (ix)
	ld	a, -4 (ix)
	add	a, #<(_arcade_enemy)
	ld	-8 (ix), a
	ld	a, #0x00
	adc	a, #>(_arcade_enemy)
	ld	-7 (ix), a
	ld	a, -1 (ix)
	ld	-4 (ix), a
	ld	-3 (ix), #0x00
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	-6 (ix), l
	ld	-5 (ix), h
	ld	a, -6 (ix)
	add	a, #0x06
	ld	-4 (ix), a
	ld	a, #0x00
	adc	a, #0x4b
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	_assetword
	ld	-4 (ix), e
	ld	-3 (ix), d
	pop	hl
	push	hl
	ld	a, -4 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -3 (ix)
	ld	(hl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:70: arcade_velocity[i]=(i&1)?-1:1;if(!from_above)arcade_velocity[i]=-arcade_velocity[i];
	ld	a, #<(_arcade_velocity)
	add	a, -1 (ix)
	ld	-4 (ix), a
	ld	a, #>(_arcade_velocity)
	adc	a, #0x00
	ld	-3 (ix), a
	bit	0, -1 (ix)
	ld	a, #0xff
	jr	NZ, 00139$
	ld	a, #0x01
00139$:
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	(hl), a
	ld	a, -2 (ix)
	or	a, a
	jr	NZ, 00102$
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	a, (hl)
	neg
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	(hl), a
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:71: glyph(arcade_enemy[i],asset(0x4b08+(u16)i*3));
	ld	a, -6 (ix)
	add	a, #0x08
	ld	-4 (ix), a
	ld	a, #0x00
	adc	a, #0x4b
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	_asset
	ld	-5 (ix), a
	pop	hl
	push	hl
	ld	a, (hl)
	ld	-4 (ix), a
	inc	hl
	ld	a, (hl)
	ld	-3 (ix), a
	ld	a, -5 (ix)
	push	af
	inc	sp
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	_glyph
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:68: for(i=0;i<5;i++){
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x05
	jp	C, 00132$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:73: arcade_player=0x178f;glyph(arcade_player,0x85);arcade_tick=0;platform_x=15;platform_dx=1;
	ld	hl, #0x178f
	ld	(_arcade_player), hl
	ld	a, #0x85
	push	af
	inc	sp
	call	_glyph
	xor	a, a
	ld	(_arcade_tick+0), a
	ld	hl, #_platform_x
	ld	(hl), #0x0f
	ld	hl, #_platform_dx
	ld	(hl), #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:74: arcade_message(0x4a10);drawing[0x37]=0;
	ld	hl, #0x4a10
	call	_arcade_message
	ld	hl, #(_drawing + 55)
	ld	(hl), #0x00
00134$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:76: robots();killed=robot_collision();d=hoststick();q=arcade_player;won=0;
	call	_robots
	call	_robot_collision
	ld	-1 (ix), a
	call	_hoststick
	ld	-3 (ix), a
	ld	hl, (_arcade_player)
	ld	-7 (ix), l
	ld	-6 (ix), h
	ld	-5 (ix), #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:77: if(d){
	ld	a, -3 (ix)
	or	a, a
	jp	Z, 00121$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:78: glyph(q,' ');
	ld	a, #0x20
	push	af
	inc	sp
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	call	_glyph
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:79: if((d&2)&&!bitmap(q-32)){q-=512;if(q<=0x1080)won=1;}
	bit	1, -3 (ix)
	jr	Z, 00117$
	ld	c, -7 (ix)
	ld	b, -6 (ix)
	ld	a, c
	add	a, #0xe0
	ld	l, a
	ld	a, b
	adc	a, #0xff
	push	bc
	ld	h, a
	call	_bitmap
	pop	bc
	or	a, a
	jr	NZ, 00117$
	ld	a,b
	add	a,#0xfe
	ld	-4 (ix), c
	ld	-3 (ix), a
	ld	b, a
	ld	a, #0x80
	cp	a, c
	ld	a, #0x10
	sbc	a, b
	jr	C, 00118$
	ld	-5 (ix), #0x01
	jp	00118$
00117$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:80: else if((d&1)&&!bitmap(q+256))q+=512;
	bit	0, -3 (ix)
	jr	Z, 00113$
	ld	l, -7 (ix)
	ld	h, -6 (ix)
	ld	e, l
	ld	a, h
	inc	a
	ld	d, a
	ex	de, hl
	push	de
	call	_bitmap
	pop	hl
	or	a, a
	jr	NZ, 00113$
	ld	a, h
	add	a, #0x02
	ld	-4 (ix), l
	ld	-3 (ix), a
	jp	00118$
00113$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:81: else{if(d&4)q++;else q--;col=q&31;if(!col||col==31)q=arcade_player;}
	bit	2, -3 (ix)
	jr	Z, 00107$
	ld	a, -7 (ix)
	add	a, #0x01
	ld	-4 (ix), a
	ld	a, -6 (ix)
	adc	a, #0x00
	ld	-3 (ix), a
	jp	00108$
00107$:
	ld	a, -7 (ix)
	add	a, #0xff
	ld	-4 (ix), a
	ld	a, -6 (ix)
	adc	a, #0xff
	ld	-3 (ix), a
00108$:
	ld	a, -4 (ix)
	and	a, #0x1f
	jr	Z, 00109$
	sub	a, #0x1f
	jr	NZ, 00118$
00109$:
	ld	hl, (_arcade_player)
	ld	-4 (ix), l
	ld	-3 (ix), h
00118$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:82: arcade_player=q;glyph(q,0x85);killed|=robot_collision();
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	(_arcade_player), hl
	ld	a, #0x85
	push	af
	inc	sp
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	_glyph
	call	_robot_collision
	or	a, -1 (ix)
	ld	-1 (ix), a
00121$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:84: platform();
	call	_platform
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:85: if(won){arcade_message(0x4acd);arcade_kind=0;return 1;}
	ld	a, -5 (ix)
	or	a, a
	jr	Z, 00123$
	ld	hl, #0x4acd
	call	_arcade_message
	xor	a, a
	ld	(_arcade_kind+0), a
	ld	a, #0x01
	jp	00136$
00123$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:86: if(killed)break;
	ld	a, -1 (ix)
	or	a, a
	jp	Z, 00134$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:88: arcade_lives--;
	ld	hl, #_arcade_lives
	dec	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:89: if(arcade_lives)arcade_message(0x4a62);
	ld	a, (_arcade_lives+0)
	or	a, a
	jp	Z, 00129$
	ld	hl, #0x4a62
	call	_arcade_message
	jp	00129$
00131$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:91: arcade_kind=0;return 0;
	xor	a, a
	ld	(_arcade_kind+0), a
00136$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\arcade.c:92: }
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
