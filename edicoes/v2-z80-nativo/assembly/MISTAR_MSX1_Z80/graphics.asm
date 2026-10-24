;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (MINGW64)
;--------------------------------------------------------
	.module graphics
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hostfatal
	.globl _native_video_write
	.globl _asset
	.globl _draw
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_drawing_stream:
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
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:5: static void draw_word(u16 index,u16 value){drawing[index]=value>>8;drawing[index+1]=(u8)value;}
;	---------------------------------
; Function draw_word
; ---------------------------------
_draw_word:
	ld	c, l
	ld	b, h
	ld	hl, #_drawing
	add	hl, bc
	ld	(hl), d
	inc	bc
	ld	hl, #_drawing
	add	hl, bc
	ld	(hl), e
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:7: static u8 get(void){u16 p=drawing_stream++;return p>=0x6c00?drawing[p-0x6c00]:RESOURCE(p);}
;	---------------------------------
; Function get
; ---------------------------------
_get:
	ld	bc, (_drawing_stream)
	ld	hl, (_drawing_stream)
	inc	hl
	ld	(_drawing_stream), hl
	ld	a, b
	sub	a, #0x6c
	jr	C, 00103$
	ld	de, #_drawing+0
	ld	l, c
	ld	a,b
	add	a,#0x94
	ld	h, a
	add	hl, de
	ld	a, (hl)
	ret
00103$:
	ld	hl, #0x50da
	add	hl, bc
	ld	a, (hl)
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:8: static u16 getw(void){u16 v=(u16)get()<<8;return v|get();}
;	---------------------------------
; Function getw
; ---------------------------------
_getw:
	call	_get
	ld	d, a
	ld	e, #0x00
	push	de
	call	_get
	pop	de
	ld	e, a
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:9: static u16 pointaddr(void){return 0xf20+((u16)drawing[0x6a]<<8)+((u16)drawing[0x6c]<<5)+(drawing[0x6b]>>2);}
;	---------------------------------
; Function pointaddr
; ---------------------------------
_pointaddr:
	ld	a, (#_drawing + 106)
	ld	b, a
	ld	c, #0x00
	ld	hl, #0x0f20
	add	hl, bc
	ex	de, hl
	ld	hl, #_drawing + 108
	ld	l, (hl)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ex	de, hl
	ld	a, (#_drawing + 107)
	rrca
	rrca
	and	a, #0x3f
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ex	de, hl
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:10: static void plot(u8 color){u8 n=drawing[0x6b]&3,b;u16 a=pointaddr();b=video[a-0xe00]&RESOURCE(0x5b95+n);(drawing[0x4b]=(b));native_video_write(a,b|(color&RESOURCE(0x5b91+n)));}
;	---------------------------------
; Function plot
; ---------------------------------
_plot:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	-1 (ix), a
	ld	a, (#_drawing + 107)
	and	a, #0x03
	ld	-2 (ix), a
	call	_pointaddr
	ld	a, e
	ld	b, d
	ld	c,a
	ld	a,b
	add	a,#0xf2
	ld	b, a
	ld	hl, #_video
	add	hl, bc
	ld	l, (hl)
	ld	c, -2 (ix)
	ld	b, #0x00
	ld	iy, #0xac6f
	add	iy, bc
	ld	a, 0 (iy)
	and	a, l
	ld	-2 (ix), a
	ld	hl, #(_drawing + 75)
	ld	a, -2 (ix)
	ld	(hl), a
	ld	hl, #0xac6b
	add	hl, bc
	ld	a, (hl)
	and	a, -1 (ix)
	or	a, -2 (ix)
	push	af
	inc	sp
	ex	de, hl
	call	_native_video_write
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:11: static void character(u16 x,u8 ch){u8 n;u16 f=0x3b26+((u16)(u8)(ch-32)<<3);for(n=0;n<8;n++,x+=32)native_video_write(x,RESOURCE(f++)^drawing[0x37]);}
;	---------------------------------
; Function character
; ---------------------------------
_character:
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
	ld	a, c
	ld	h, b
	inc	bc
	add	a, #0xda
	ld	l, a
	ld	a, h
	adc	a, #0x50
	ld	h, a
	ld	a, (hl)
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
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:12: static void graphics(void){u8 op,a,b,n,x,y,dx,dy,sx,sy,minorx,minory,err,count,oldx,pat,match;u16 p,f,q,w,h,save;
;	---------------------------------
; Function graphics
; ---------------------------------
_graphics:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-10
	add	hl, sp
	ld	sp, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:13: while(1){
00160$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:14: op=get();if(!op)break;
	call	_get
	ld	-3 (ix), a
	or	a, a
	jp	Z, 00175$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:15: switch(op){
	ld	a, #0x09
	sub	a, -3 (ix)
	jp	C, 00157$
	ld	c, -3 (ix)
	ld	b, #0x00
	ld	hl, #00432$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00432$:
	.dw	00157$
	.dw	00103$
	.dw	00104$
	.dw	00105$
	.dw	00117$
	.dw	00130$
	.dw	00138$
	.dw	00149$
	.dw	00138$
	.dw	00150$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:16: case 1:(drawing[0x69]=(get()));break;
00103$:
	call	_get
	ld	(#(_drawing + 105)),a
	jp	00160$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:17: case 2:draw_word(0x6b,getw());plot(drawing[0x69]);break;
00104$:
	call	_getw
	ld	hl, #0x006b
	call	_draw_word
	ld	a, (#(_drawing + 105) + 0)
	call	_plot
	jp	00160$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:18: case 3:
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:19: a=get();b=get();(drawing[0x6d]=(a));(drawing[0x6e]=(b));x=drawing[0x6b];y=drawing[0x6c];
	call	_get
	ld	e, a
	push	de
	call	_get
	ld	c, a
	pop	de
	ld	hl, #(_drawing + 109)
	ld	(hl), e
	inc	hl
	ld	(hl), c
	ld	a, (#(_drawing + 107) + 0)
	ld	-4 (ix), a
	ld	a, (#(_drawing + 108) + 0)
	ld	-3 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:20: dx=a-x;dy=b-y;sx=sy=1;minorx=0;minory=1;
	ld	a, e
	sub	a, -4 (ix)
	ld	-10 (ix), a
	ld	a, c
	sub	a, -3 (ix)
	ld	-9 (ix), a
	ld	-8 (ix), #0x01
	ld	-7 (ix), #0x01
	ld	-6 (ix), #0x00
	ld	-5 (ix), #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:21: if(a<x){sx=255;dx=0-dx;}if(b<y){sy=255;dy=0-dy;minory=255;}
	ld	a, e
	sub	a, -4 (ix)
	jr	NC, 00107$
	ld	-7 (ix), #0xff
	ld	a, -10 (ix)
	neg
	ld	-10 (ix), a
00107$:
	ld	a, c
	sub	a, -3 (ix)
	jr	NC, 00109$
	ld	-8 (ix), #0xff
	ld	a, -9 (ix)
	neg
	ld	-9 (ix), a
	ld	-5 (ix), #0xff
00109$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:22: if(dx<dy){n=dx;dx=dy;dy=n;minorx=sx;minory=0;sx=0;}
	ld	a, -10 (ix)
	sub	a, -9 (ix)
	jr	NC, 00111$
	ld	c, -10 (ix)
	ld	a, -9 (ix)
	ld	-10 (ix), a
	ld	-9 (ix), c
	ld	a, -7 (ix)
	ld	-6 (ix), a
	ld	-5 (ix), #0x00
	ld	-7 (ix), #0x00
00111$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:23: err=dx>>1;count=1;
	ld	a, -10 (ix)
	srl	a
	ld	-2 (ix), a
	ld	-1 (ix), #0x01
00162$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:24: for(;;){(drawing[0x6b]=(x));(drawing[0x6c]=(y));plot(drawing[0x69]);if(count>dx)break;x+=sx;y+=(sx==0?sy:0);err+=dy;count++;if(err>dx){err-=dx;x+=minorx;y+=minory;}}
	ld	hl, #(_drawing + 107)
	ld	a, -4 (ix)
	ld	(hl), a
	inc	hl
	ld	a, -3 (ix)
	ld	(hl), a
	ld	a, (#(_drawing + 105) + 0)
	call	_plot
	ld	a, -10 (ix)
	sub	a, -1 (ix)
	jp	C, 00160$
	ld	a, -7 (ix)
	add	a, -4 (ix)
	ld	-4 (ix), a
	ld	a, -7 (ix)
	or	a, a
	jr	NZ, 00177$
	ld	a, -8 (ix)
	jp	00178$
00177$:
	xor	a, a
00178$:
	ld	c, -3 (ix)
	add	a, c
	ld	-3 (ix), a
	ld	a, -2 (ix)
	add	a, -9 (ix)
	ld	-2 (ix), a
	inc	-1 (ix)
	ld	a, -10 (ix)
	sub	a, -2 (ix)
	jr	NC, 00162$
	ld	a, -2 (ix)
	sub	a, -10 (ix)
	ld	-2 (ix), a
	ld	a, -4 (ix)
	add	a, -6 (ix)
	ld	-4 (ix), a
	ld	a, -3 (ix)
	add	a, -5 (ix)
	ld	-3 (ix), a
	jp	00162$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:26: case 4:
00117$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:27: draw_word(0x6b,getw());a=get();b=get();for(n=0;n<4;n++)(drawing[0x73+n]=(a&RESOURCE(0x5b91+n)));(drawing[0x71]=(b<<3));
	call	_getw
	ld	hl, #0x006b
	call	_draw_word
	call	_get
	ld	-1 (ix), a
	call	_get
	ld	c, a
	ld	b, #0x00
00164$:
	ld	e, b
	ld	a, e
	add	a, #0x73
	add	a, #<(_drawing)
	ld	l, a
	ld	a, #0x00
	adc	a, #>(_drawing)
	ld	h, a
	ld	d, #0x00
	ld	iy, #0xac6b
	add	iy, de
	ld	a, 0 (iy)
	and	a, -1 (ix)
	ld	(hl), a
	inc	b
	ld	a, b
	sub	a, #0x04
	jr	C, 00164$
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	ld	(#(_drawing + 113)),a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:28: for(y=drawing[0x6c];y<=191;y++){(drawing[0x6c]=(y));pat=RESOURCE(0x5b99+(y&7)+drawing[0x71]);(drawing[0x72]=(pat));oldx=drawing[0x6b];x=oldx;match=0;
	ld	hl, #(_drawing + 108)
	ld	c, (hl)
00173$:
	ld	a, #0xbf
	sub	a, c
	jp	C, 00160$
	ld	hl, #(_drawing + 108)
	ld	a,c
	ld	(hl),a
	and	a, #0x07
	ld	e, a
	ld	d, #0x00
	ld	hl, #0xac73
	add	hl, de
	ex	de, hl
	ld	hl, #(_drawing + 113)
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	ld	-4 (ix), a
	ld	hl, #(_drawing + 114)
	ld	a, -4 (ix)
	ld	(hl), a
	ld	a, (#(_drawing + 107) + 0)
	ld	-3 (ix), a
	ld	-2 (ix), #0x00
	ld	a, -3 (ix)
	ld	-1 (ix), a
00167$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:29: for(;x<128;x++){(drawing[0x6b]=(x));n=x&3;if((video[pointaddr()-0xe00]&RESOURCE(0x5b91+n))==drawing[0x73+n])break;plot(pat);match=1;}
	ld	a, -1 (ix)
	sub	a, #0x80
	jr	NC, 00121$
	ld	hl, #(_drawing + 107)
	ld	a, -1 (ix)
	ld	(hl), a
	ld	a, -1 (ix)
	and	a, #0x03
	ld	l, a
	push	hl
	push	bc
	call	_pointaddr
	pop	bc
	pop	hl
	ld	a,d
	add	a,#0xf2
	ld	d, a
	ld	iy, #_video
	add	iy, de
	ld	b, 0 (iy)
	ld	e, l
	ld	d, #0x00
	ld	iy, #0xac6b
	add	iy, de
	ld	a, 0 (iy)
	and	a, b
	ld	b, a
	ld	a, l
	add	a, #0x73
	ld	l, a
	ld	h, #0x00
	ld	de, #_drawing
	add	hl, de
	ld	a, (hl)
	sub	a, b
	jr	Z, 00121$
	push	bc
	ld	a, -4 (ix)
	call	_plot
	pop	bc
	ld	-2 (ix), #0x01
	inc	-1 (ix)
	jp	00167$
00121$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:30: if(x!=oldx)for(x=oldx;x>0;){--x;(drawing[0x6b]=(x));n=x&3;if((video[pointaddr()-0xe00]&RESOURCE(0x5b91+n))==drawing[0x73+n])break;plot(pat);}
	ld	a, -1 (ix)
	sub	a, -3 (ix)
	jr	Z, 00126$
	ld	b, -3 (ix)
00170$:
	ld	a, b
	or	a, a
	jr	Z, 00126$
	dec	b
	ld	hl, #(_drawing + 107)
	ld	a,b
	ld	(hl),a
	and	a, #0x03
	ld	l, a
	push	hl
	push	bc
	call	_pointaddr
	pop	bc
	pop	hl
	ld	a,d
	add	a,#0xf2
	ld	d, a
	ld	iy, #_video
	add	iy, de
	ld	h, 0 (iy)
	ld	e, l
	ld	d, #0x00
	ld	iy, #0xac6b
	add	iy, de
	ld	a, 0 (iy)
	and	a, h
	ld	e, a
	ld	a, l
	add	a, #0x73
	add	a, #<(_drawing)
	ld	l, a
	ld	a, #0x00
	adc	a, #>(_drawing)
	ld	h, a
	ld	a, (hl)
	sub	a, e
	jr	Z, 00126$
	push	bc
	ld	a, -4 (ix)
	call	_plot
	pop	bc
	jp	00170$
00126$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:31: (drawing[0x6b]=(oldx));if(!match)break;(drawing[0x6c]=(y+1));
	ld	hl, #(_drawing + 107)
	ld	a, -3 (ix)
	ld	(hl), a
	ld	a, -2 (ix)
	or	a, a
	jp	Z, 00160$
	inc	hl
	ld	a, c
	inc	a
	ld	(hl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:28: for(y=drawing[0x6c];y<=191;y++){(drawing[0x6c]=(y));pat=RESOURCE(0x5b99+(y&7)+drawing[0x71]);(drawing[0x72]=(pat));oldx=drawing[0x6b];x=oldx;match=0;
	inc	c
	jp	00173$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:34: case 5:
00130$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:35: x=get();y=get();(drawing[0x6b]=(x));(drawing[0x6c]=(y));p=0xf20+((u16)drawing[0x6a]<<8)+x+((u16)y<<5);w=get();h=get();pat=get()<<3;
	call	_get
	ld	b, a
	push	bc
	call	_get
	ld	c, a
	pop	af
	ld	b, a
	ld	hl, #(_drawing + 107)
	ld	(hl), b
	inc	hl
	ld	(hl), c
	ld	hl, #_drawing + 106
	ld	d, (hl)
	ld	e, #0x00
	ld	hl, #0x0f20
	add	hl, de
	ld	e, b
	ld	d, #0x00
	add	hl, de
	ex	de, hl
	ld	l, c
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	-5 (ix), l
	ld	-4 (ix), h
	push	bc
	call	_get
	ld	-3 (ix), a
	call	_get
	pop	bc
	ld	e, a
	ld	d, #0x00
	push	bc
	push	de
	call	_get
	pop	de
	pop	bc
	add	a, a
	add	a, a
	add	a, a
	ld	-2 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:36: do{a=RESOURCE(0x5b99+(y&7)+pat);q=p;n=(u8)w;do{native_video_write(q++,a);}while(--n);p+=32;y++;}while(--h);
00134$:
	ld	a, c
	and	a, #0x07
	ld	b, #0x00
	add	a, #0x73
	ld	l, a
	ld	a, b
	adc	a, #0xac
	ld	h, a
	ld	a, -2 (ix)
	ld	b, #0x00
	add	a, l
	ld	l, a
	ld	a, b
	adc	a, h
	ld	h, a
	ld	a, (hl)
	ld	-1 (ix), a
	ld	b, -3 (ix)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
00131$:
	push	hl
	inc	hl
	pop	iy
	push	hl
	push	bc
	push	de
	ld	a, -1 (ix)
	push	af
	inc	sp
	push	iy
	pop	hl
	call	_native_video_write
	pop	de
	pop	bc
	pop	hl
	djnz	00131$
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	push	de
	ld	de, #0x0020
	add	hl, de
	pop	de
	ld	-5 (ix), l
	ld	-4 (ix), h
	inc	c
	dec	de
	ld	a, d
	or	a, e
	jr	NZ, 00134$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:37: (drawing[0x6c]=(y));break;
	ld	hl, #(_drawing + 108)
	ld	(hl), c
	jp	00160$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:38: case 6:case 8:
00138$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:39: if(op==6)(drawing[0x37]=(0));p=getw();
	ld	a, -3 (ix)
	sub	a, #0x06
	ld	a, #0x01
	jr	Z, 00437$
	xor	a, a
00437$:
	ld	-3 (ix), a
	or	a, a
	jr	Z, 00140$
	ld	hl, #_drawing + 55
	ld	(hl), #0x00
00140$:
	call	_getw
	ld	-2 (ix), e
	ld	-1 (ix), d
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:40: while((a=get())!=0){if(a==255)p=getw();else character(p++,a);}
00144$:
	call	_get
	ld	b,a
	or	a,a
	jr	Z, 00146$
	inc	a
	jr	NZ, 00142$
	call	_getw
	ld	-2 (ix), e
	ld	-1 (ix), d
	jp	00144$
00142$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	inc	-2 (ix)
	jr	NZ, 00440$
	inc	-1 (ix)
00440$:
	push	bc
	inc	sp
	call	_character
	jp	00144$
00146$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:41: if(op==6)(drawing[0x37]=(255));break;
	ld	a, -3 (ix)
	or	a, a
	jp	Z, 00160$
	ld	hl, #_drawing + 55
	ld	(hl), #0xff
	jp	00160$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:42: case 7:p=getw();save=drawing_stream;draw_word(0x6f,save);drawing_stream=p;graphics();drawing_stream=save;break;
00149$:
	call	_getw
	ld	hl, (_drawing_stream)
	ex	de, hl
	push	de
	push	hl
	ld	hl, #0x006f
	call	_draw_word
	pop	de
	ld	(_drawing_stream), de
	call	_graphics
	pop	hl
	ld	(_drawing_stream), hl
	jp	00160$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:43: case 9:
00150$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:44: p=getw();f=getw();w=asset(f++);h=asset(f++);do{q=p;n=(u8)h;do{native_video_write(q,asset(f++));q+=32;}while(--n);p++;}while(--w);break;
	call	_getw
	push	de
	call	_getw
	pop	bc
	ld	l, e
	ld	h, d
	inc	de
	push	bc
	push	de
	call	_asset
	pop	de
	pop	bc
	ld	l, a
	ld	h, #0x00
	push	de
	pop	iy
	inc	de
	ld	-5 (ix), e
	ld	-4 (ix), d
	push	hl
	push	bc
	push	iy
	pop	hl
	call	_asset
	pop	bc
	pop	hl
	ld	-6 (ix), a
	ld	-3 (ix), l
	ld	-2 (ix), h
00154$:
	ld	e, c
	ld	d, b
	ld	a, -6 (ix)
	ld	-1 (ix), a
	ld	l, -5 (ix)
	ld	h, -4 (ix)
00151$:
	ld	-5 (ix), l
	ld	-4 (ix), h
	inc	hl
	push	hl
	push	bc
	push	de
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	call	_asset
	pop	de
	push	de
	push	af
	inc	sp
	ex	de,hl
	call	_native_video_write
	pop	de
	pop	bc
	pop	hl
	ld	a, e
	add	a, #0x20
	ld	e, a
	jr	NC, 00441$
	inc	d
00441$:
	dec	-1 (ix)
	jr	NZ, 00151$
	ld	-5 (ix), l
	ld	-4 (ix), h
	inc	bc
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	dec	hl
	ld	-3 (ix), l
	ld	-2 (ix), h
	ld	a, h
	or	a, -3 (ix)
	jr	NZ, 00154$
	jp	00160$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:45: default:hostfatal(drawing_stream-1,op);return;
00157$:
	ld	hl, (_drawing_stream)
	ld	-5 (ix), l
	ld	-4 (ix), h
	ld	a, -5 (ix)
	add	a, #0xff
	ld	-2 (ix), a
	ld	a, -4 (ix)
	adc	a, #0xff
	ld	-1 (ix), a
	ld	a, -3 (ix)
	push	af
	inc	sp
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	call	_hostfatal
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:46: }
00175$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:49: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\graphics.c:51: void draw(u16 resource){drawing_stream=resource;graphics();}
;	---------------------------------
; Function draw
; ---------------------------------
_draw::
	ld	(_drawing_stream), hl
	jp	_graphics
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
