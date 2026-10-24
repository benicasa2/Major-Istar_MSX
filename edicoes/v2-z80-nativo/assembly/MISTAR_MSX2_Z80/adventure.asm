;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (MINGW64)
;--------------------------------------------------------
	.module adventure
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _security
	.globl _docking
	.globl _saveslot
	.globl _video_mode
	.globl _hostinit
	.globl _hostsound
	.globl _hostkey
	.globl _input_line
	.globl _wait_any
	.globl _scene_clear
	.globl _newline
	.globl _text_string
	.globl _text_resource
	.globl _text_clear
	.globl _text_at
	.globl _native_putchar
	.globl _native_video_fill
	.globl _glyph
	.globl _draw
	.globl _setpair
	.globl _pair
	.globl _assetword
	.globl _asset
	.globl _memcmp
	.globl _adventure
	.globl _objects
	.globl _draw_room
	.globl _game
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_objects::
	.ds 825
_adventure::
	.ds 9
_line:
	.ds 64
_noun:
	.ds 4
_parsepos:
	.ds 1
_random_seed:
	.ds 1
_savebuffer:
	.ds 1024
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
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:13: static u16 object_name(u8 i){return pair(objects[i].name_hi,objects[i].name_lo);}
;	---------------------------------
; Function object_name
; ---------------------------------
_object_name:
	ld	e, a
	ld	bc, #_objects+0
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ex	de, hl
	ld	c, e
	ld	b, d
	ld	hl, #5
	add	hl, bc
	ld	c, (hl)
	ld	hl, #4
	add	hl, de
	ld	a, (hl)
	ld	l, c
	jp	_pair
_verbs:
	.ascii "GET "
	.db 0x00
	.db #0x00	; 0
	.ascii "CUT "
	.db 0x00
	.db #0x00	; 0
	.ascii "DROP"
	.db 0x00
	.db #0x01	; 1
	.ascii "GO  "
	.db 0x00
	.db #0x02	; 2
	.ascii "ENTE"
	.db 0x00
	.db #0x02	; 2
	.ascii "LOOK"
	.db 0x00
	.db #0x03	; 3
	.ascii "L   "
	.db 0x00
	.db #0x03	; 3
	.ascii "READ"
	.db 0x00
	.db #0x04	; 4
	.ascii "SHOO"
	.db 0x00
	.db #0x05	; 5
	.ascii "FIRE"
	.db 0x00
	.db #0x05	; 5
	.ascii "BLAS"
	.db 0x00
	.db #0x05	; 5
	.ascii "COMB"
	.db 0x00
	.db #0x06	; 6
	.ascii "EAT "
	.db 0x00
	.db #0x07	; 7
	.ascii "PUSH"
	.db 0x00
	.db #0x08	; 8
	.ascii "PRES"
	.db 0x00
	.db #0x08	; 8
	.ascii "SAVE"
	.db 0x00
	.db #0x09	; 9
	.ascii "LOAD"
	.db 0x00
	.db #0x0a	; 10
	.ascii "UNLO"
	.db 0x00
	.db #0x0b	; 11
	.ascii "OPEN"
	.db 0x00
	.db #0x0b	; 11
	.ascii "LIGH"
	.db 0x00
	.db #0x0c	; 12
	.ascii "UNLI"
	.db 0x00
	.db #0x0c	; 12
	.ascii "TURN"
	.db 0x00
	.db #0x0d	; 13
	.ascii "ON  "
	.db 0x00
	.db #0x0e	; 14
	.ascii "OFF "
	.db 0x00
	.db #0x0f	; 15
	.ascii "INVE"
	.db 0x00
	.db #0x10	; 16
	.ascii "INV "
	.db 0x00
	.db #0x10	; 16
	.ascii "I   "
	.db 0x00
	.db #0x10	; 16
	.ascii "NORT"
	.db 0x00
	.db #0x11	; 17
	.ascii "SOUT"
	.db 0x00
	.db #0x11	; 17
	.ascii "EAST"
	.db 0x00
	.db #0x11	; 17
	.ascii "WEST"
	.db 0x00
	.db #0x11	; 17
	.ascii "UP  "
	.db 0x00
	.db #0x11	; 17
	.ascii "DOWN"
	.db 0x00
	.db #0x11	; 17
	.ascii "N   "
	.db 0x00
	.db #0x11	; 17
	.ascii "S   "
	.db 0x00
	.db #0x11	; 17
	.ascii "E   "
	.db 0x00
	.db #0x11	; 17
	.ascii "W   "
	.db 0x00
	.db #0x11	; 17
	.ascii "U   "
	.db 0x00
	.db #0x11	; 17
	.ascii "D   "
	.db 0x00
	.db #0x11	; 17
	.ascii "    "
	.db 0x00
	.db #0x03	; 3
	.ascii "HELP"
	.db 0x00
	.db #0x12	; 18
	.ascii "SCOR"
	.db 0x00
	.db #0x13	; 19
	.ascii "QUIT"
	.db 0x00
	.db #0x14	; 20
	.ascii "FIX "
	.db 0x00
	.db #0x15	; 21
	.ascii "REPA"
	.db 0x00
	.db #0x15	; 21
	.ascii "RUN "
	.db 0x00
	.db #0x16	; 22
	.ascii "STAR"
	.db 0x00
	.db #0x16	; 22
	.ascii "BOOT"
	.db 0x00
	.db #0x16	; 22
	.ascii "USE "
	.db 0x00
	.db #0x16	; 22
	.ascii "NERF"
	.db 0x00
	.db #0x17	; 23
	.ascii "SHIT"
	.db 0x00
	.db #0x17	; 23
	.ascii "DAMN"
	.db 0x00
	.db #0x17	; 23
	.ascii "SCRE"
	.db 0x00
	.db #0x17	; 23
	.ascii "KILL"
	.db 0x00
	.db #0x17	; 23
	.ascii "FUCK"
	.db 0x00
	.db #0x17	; 23
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:14: static u16 object_art(u8 i){return pair(objects[i].art_hi,objects[i].art_lo);}
;	---------------------------------
; Function object_art
; ---------------------------------
_object_art:
	ld	e, a
	ld	bc, #_objects+0
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ex	de, hl
	ld	c, e
	ld	b, d
	ld	hl, #24
	add	hl, bc
	ld	c, (hl)
	ld	hl, #23
	add	hl, de
	ld	a, (hl)
	ld	l, c
	jp	_pair
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:15: static u8 place(void){return adventure.room<=22?103:adventure.room;}
;	---------------------------------
; Function place
; ---------------------------------
_place:
	ld	a, (#_adventure + 0)
	cp	a, #0x17
	ret	NC
	ld	a, #0x67
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:16: static void say(u16 p){text_resource(p);}
;	---------------------------------
; Function say
; ---------------------------------
_say:
	jp	_text_resource
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:17: static u8 answer(u16 p,u8 result){say(p);return result;}
;	---------------------------------
; Function answer
; ---------------------------------
_answer:
	call	_say
	ld	iy, #2
	add	iy, sp
	ld	a, 0 (iy)
	pop	hl
	inc	sp
	jp	(hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:18: static void pause_message(u16 p){say(p);say(0x4062);wait_any();}
;	---------------------------------
; Function pause_message
; ---------------------------------
_pause_message:
	call	_say
	ld	hl, #0x4062
	call	_say
	jp	_wait_any
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:19: static void number(u16 v){u16 d=10000;u8 n,seen=0;while(d){n=0;while(v>=d){v-=d;n++;}if(n||seen||d==1){native_putchar('0'+n);seen=1;}d/=10;}}
;	---------------------------------
; Function number
; ---------------------------------
_number:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	ld	bc, #0x2710
	ld	-2 (ix), #0x00
00108$:
	ld	a, b
	or	a, c
	jr	Z, 00111$
	ld	e, #0x00
00101$:
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jr	C, 00119$
	cp	a, a
	sbc	hl, bc
	inc	e
	jp	00101$
00119$:
	ld	-1 (ix), e
	ld	a, e
	or	a, a
	jr	NZ, 00104$
	ld	a, -2 (ix)
	or	a, a
	jr	NZ, 00104$
	ld	a, c
	dec	a
	or	a, b
	jr	NZ, 00105$
00104$:
	ld	a, -1 (ix)
	add	a, #0x30
	push	hl
	push	bc
	call	_native_putchar
	pop	bc
	pop	hl
	ld	-2 (ix), #0x01
00105$:
	push	hl
	ld	de, #0x000a
	ld	l, c
	ld	h, b
	call	__divuint
	ld	c, e
	ld	b, d
	pop	hl
	jp	00108$
00111$:
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:20: static u8 same(const char *a,const char *b){return memcmp(a,b,4)==0;}
;	---------------------------------
; Function same
; ---------------------------------
_same:
	ld	bc, #0x0004
	push	bc
	call	_memcmp
	ld	a, e
	or	a, a
	or	a, d
	ld	a, #0x01
	ret	Z
	xor	a, a
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:21: static u8 word(char *dst){u8 n=0;char c;memset(dst,' ',4);while(line[parsepos]==' ')parsepos++;while((c=line[parsepos])!=0&&c!=' '){parsepos++;if(n<4)dst[n++]=c;}return n!=0;}
;	---------------------------------
; Function word
; ---------------------------------
_word:
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	ld	e, l
	ld	d, h
	ld	(hl), #0x20
	inc	hl
	ld	(hl), #0x20
	inc	hl
	ld	(hl), #0x20
	inc	hl
	ld	(hl), #0x20
00101$:
	ld	hl, #_line
	ld	a, (_parsepos)
	ld	c, a
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x20
	jr	NZ, 00116$
	ld	hl, #_parsepos
	inc	(hl)
	jp	00101$
00116$:
	ld	-1 (ix), #0x00
00107$:
	ld	hl, #_line
	ld	a, (_parsepos)
	ld	c, a
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	b,a
	or	a,a
	jr	Z, 00109$
	sub	a, #0x20
	jr	Z, 00109$
	ld	hl, #_parsepos
	inc	(hl)
	ld	a, -1 (ix)
	sub	a, #0x04
	jr	NC, 00107$
	ld	l, -1 (ix)
	ld	h, #0x00
	add	hl, de
	inc	-1 (ix)
	ld	(hl), b
	jp	00107$
00109$:
	ld	a, -1 (ix)
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	inc	sp
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:22: static u8 preposition(void){u16 p;for(p=0x52f6;p<0x5366;p+=4)if(noun[0]==asset(p)&&noun[1]==asset(p+1)&&noun[2]==asset(p+2)&&noun[3]==asset(p+3))return 1;return 0;}
;	---------------------------------
; Function preposition
; ---------------------------------
_preposition:
	ld	bc, #0x52f6
00107$:
	ld	hl, #_noun
	ld	e, (hl)
	push	bc
	push	de
	ld	l, c
	ld	h, b
	call	_asset
	pop	de
	pop	bc
	sub	a, e
	jr	NZ, 00108$
	ld	hl, #_noun + 1
	ld	e, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	push	bc
	push	de
	call	_asset
	pop	de
	pop	bc
	sub	a, e
	jr	NZ, 00108$
	ld	hl, #_noun + 2
	ld	e, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	push	bc
	push	de
	call	_asset
	pop	de
	pop	bc
	sub	a, e
	jr	NZ, 00108$
	ld	hl, #_noun + 3
	ld	e, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	push	bc
	push	de
	call	_asset
	pop	de
	pop	bc
	sub	a, e
	jr	NZ, 00108$
	ld	a, #0x01
	ret
00108$:
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	e, c
	ld	d, b
	ld	a, e
	sub	a, #0x66
	ld	a, d
	sbc	a, #0x53
	jr	C, 00107$
	xor	a, a
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:23: static u8 get_noun(void){while(word(noun)){if(!preposition())return 1;}return 0;}
;	---------------------------------
; Function get_noun
; ---------------------------------
_get_noun:
00103$:
	ld	hl, #_noun
	call	_word
	or	a, a
	jr	Z, 00105$
	call	_preposition
	or	a, a
	jr	NZ, 00103$
	ld	a, #0x01
	ret
00105$:
	xor	a, a
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:24: static u8 second_noun(void){if(get_noun())return 1;say(0x3f13);input_line(line);parsepos=0;return get_noun();}
;	---------------------------------
; Function second_noun
; ---------------------------------
_second_noun:
	call	_get_noun
	or	a, a
	jr	Z, 00102$
	ld	a, #0x01
	ret
00102$:
	ld	hl, #0x3f13
	call	_say
	ld	hl, #_line
	call	_input_line
	xor	a, a
	ld	(_parsepos+0), a
	jp	_get_noun
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:25: static s8 lookup(void){u8 i;s8 distant=-1;for(i=0;i<OBJECT_COUNT;i++)if(same(noun,objects[i].key)){if(objects[i].room==0||objects[i].room==place())return i;distant=i;}return distant<0?-1:-2;}
;	---------------------------------
; Function lookup
; ---------------------------------
_lookup:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ld	c, #0xff
	ld	-4 (ix), #0x00
	ld	-1 (ix), #0x00
00107$:
	ld	e, -1 (ix)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	a, l
	add	a, #<(_objects)
	ld	-3 (ix), a
	ld	a, h
	adc	a, #>(_objects)
	ld	-2 (ix), a
	ld	e, -3 (ix)
	ld	d, -2 (ix)
	push	bc
	ld	hl, #_noun
	call	_same
	pop	bc
	or	a, a
	jr	Z, 00108$
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	ld	hl, #6
	add	hl, bc
	ld	c, (hl)
	ld	a, c
	or	a, a
	jr	Z, 00101$
	push	bc
	call	_place
	pop	bc
	sub	a, c
	jr	NZ, 00102$
00101$:
	ld	a, -4 (ix)
	jp	00109$
00102$:
	ld	c, -1 (ix)
00108$:
	inc	-1 (ix)
	ld	a, -1 (ix)
	ld	-4 (ix), a
	ld	a, -1 (ix)
	sub	a, #0x21
	jr	C, 00107$
	bit	7, c
	ld	a, #0xff
	jr	NZ, 00112$
	ld	a, #0xfe
00112$:
00109$:
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:26: static u8 object_error(s8 i){say(i==-2?0x42b2:0x4292);return TURN;}
;	---------------------------------
; Function object_error
; ---------------------------------
_object_error:
	sub	a, #0xfe
	jr	NZ, 00103$
	ld	hl, #0x42b2
	jp	00104$
00103$:
	ld	hl, #0x4292
00104$:
	call	_say
	ld	a, #0x01
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:27: static u8 lit(void){Object *f=&objects[FLASHLIGHT];return adventure.room<63||adventure.room>75||(f->on&&(f->room==0||f->room==adventure.room));}
;	---------------------------------
; Function lit
; ---------------------------------
_lit:
	ld	hl, #_adventure+0
	ld	c, (hl)
	ld	a, c
	sub	a, #0x3f
	jr	C, 00104$
	ld	a, #0x4b
	sub	a, c
	jr	C, 00104$
	ld	a, (#(_objects + 425) + 16)
	or	a, a
	jr	Z, 00103$
	ld	a, (#(_objects + 425) + 6)
	or	a, a
	jr	Z, 00104$
	sub	a, c
	jr	Z, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:28: static void game_over(u16 message){if(message)pause_message(message);scene_clear();text_at(0xe20);say(0x3e73);say(0x5b34);text_clear();draw(0x68f9);adventure.ended=1;}
;	---------------------------------
; Function game_over
; ---------------------------------
_game_over:
	ld	a, h
	or	a, l
	jr	Z, 00102$
	call	_pause_message
00102$:
	call	_scene_clear
	ld	hl, #0x0e20
	call	_text_at
	ld	hl, #0x3e73
	call	_say
	ld	hl, #0x5b34
	call	_say
	call	_text_clear
	ld	hl, #0x68f9
	call	_draw
	ld	hl, #_adventure+6
	ld	(hl), #0x01
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:29: static void environment(void){
;	---------------------------------
; Function environment
; ---------------------------------
_environment:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:30: if(adventure.room>=67&&objects[HELMET].room){game_over(0x43ca);return;}
	ld	hl, #_adventure
	ld	c, (hl)
	ld	a, c
	sub	a, #0x43
	jr	C, 00102$
	ld	a, (#(_objects + 56) + 0)
	or	a, a
	jr	Z, 00102$
	ld	hl, #0x43ca
	jp	_game_over
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:31: if(adventure.room==32&&adventure.last_room==33&&objects[MIRROR].room){game_over(0x435d);return;}
	ld	a, c
	sub	a, #0x20
	jr	NZ, 00105$
	ld	a, (#_adventure + 1)
	sub	a, #0x21
	jr	NZ, 00105$
	ld	a, (#(_objects + 281) + 0)
	or	a, a
	jr	Z, 00105$
	ld	hl, #0x435d
	jp	_game_over
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:32: if(!lit()){if(++adventure.dark_moves>2){game_over(0x43f1);return;}}else adventure.dark_moves=0;
	call	_lit
	ld	c, a
	ld	hl, #_adventure + 3
	ld	a, c
	or	a, a
	jr	NZ, 00111$
	inc	(hl)
	ld	a, (hl)
	cp	a, #0x03
	jr	C, 00112$
	ld	hl, #0x43f1
	jp	_game_over
00111$:
	ld	(hl), #0x00
00112$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:33: if(adventure.room==66&&!adventure.pill_taken)game_over(0x441a);
	ld	a, (#_adventure + 0)
	sub	a, #0x42
	ret	NZ
	ld	a, (#_adventure + 4)
	or	a, a
	ret	NZ
	ld	hl, #0x441a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:34: }
	jp	_game_over
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:35: static void battery_tick(void){Object *f=&objects[FLASHLIGHT];if(!f->on)return;if(!f->battery){f->on=0;say(0x42ed);return;}if(f->battery--<=f->warning){say(0x412b);number(f->battery+1);say(0x3f73);}}
;	---------------------------------
; Function battery_tick
; ---------------------------------
_battery_tick:
	ld	a, (#(_objects + 441) + 0)
	or	a, a
	ret	Z
	ld	hl, #(_objects + 442)
	ld	c, (hl)
	ld	a, c
	or	a, a
	jr	NZ, 00104$
	ld	hl, #(_objects + 441)
	ld	(hl), #0x00
	ld	hl, #0x42ed
	jp	_say
00104$:
	ld	a, c
	dec	a
	ld	(#(_objects + 442)),a
	ld	a, (#(_objects + 425) + 18)
	sub	a, c
	ret	C
	ld	hl, #0x412b
	call	_say
	ld	hl, #(_objects + 442)
	ld	l, (hl)
	ld	h, #0x00
	inc	hl
	call	_number
	ld	hl, #0x3f73
	jp	_say
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:36: void draw_room(void){u8 i,found=0;u16 a;
;	---------------------------------
; Function draw_room
; ---------------------------------
_draw_room::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ld	-2 (ix), #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:37: if(adventure.redraw_only){drawing[0x37]=0;native_video_fill(0xe00,0xf20,0);}else scene_clear();
	ld	a, (#(_adventure + 5) + 0)
	or	a, a
	jr	Z, 00102$
	ld	hl, #_drawing+55
	ld	(hl), #0x00
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0f20
	ld	hl, #0x0e00
	call	_native_video_fill
	jp	00103$
00102$:
	call	_scene_clear
00103$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:38: text_at(0xe20);say(0x3e73);
	ld	hl, #0x0e20
	call	_text_at
	ld	hl, #0x3e73
	call	_say
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:39: if(!lit()){say(0x5a4b);text_clear();draw(0x6a7d);}
	call	_lit
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:40: else{say(assetword(0x597f+(u16)adventure.room*2));text_clear();if(!adventure.redraw_only)draw(assetword(0x5cd0+(u16)adventure.room*2));}
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:39: if(!lit()){say(0x5a4b);text_clear();draw(0x6a7d);}
	or	a, a
	jr	NZ, 00107$
	ld	hl, #0x5a4b
	call	_say
	call	_text_clear
	ld	hl, #0x6a7d
	call	_draw
	jp	00108$
00107$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:40: else{say(assetword(0x597f+(u16)adventure.room*2));text_clear();if(!adventure.redraw_only)draw(assetword(0x5cd0+(u16)adventure.room*2));}
	ld	hl, #_adventure
	ld	l, (hl)
	ld	h, #0x00
	add	hl, hl
	ld	bc, #0x597f
	add	hl, bc
	call	_assetword
	ex	de, hl
	call	_say
	call	_text_clear
	ld	a, (#(_adventure + 5) + 0)
	or	a, a
	jr	NZ, 00108$
	ld	hl, #_adventure
	ld	l, (hl)
	ld	h, #0x00
	add	hl, hl
	ld	bc, #0x5cd0
	add	hl, bc
	call	_assetword
	ex	de, hl
	call	_draw
00108$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:41: adventure.redraw_only=0;
	ld	hl, #(_adventure + 5)
	ld	(hl), #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:42: a=0x5723+(u16)(adventure.room-1)*6;
	ld	hl, #_adventure
	ld	c, (hl)
	ld	b, #0x00
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #0x5723
	add	hl, bc
	ld	c, l
	ld	b, h
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:43: for(i=0;i<6;i++)if(asset(a+i))glyph(0xe3a+i,asset(0x5b88+i));
	ld	e, #0x00
00125$:
	ld	-4 (ix), e
	ld	-3 (ix), #0x00
	ld	a, c
	ld	d, b
	pop	hl
	push	hl
	add	a, l
	ld	l, a
	ld	a, d
	adc	a, h
	push	bc
	push	de
	ld	h, a
	call	_asset
	pop	de
	pop	bc
	or	a, a
	jr	Z, 00126$
	ld	a, -4 (ix)
	add	a, #0x88
	ld	l, a
	ld	a, #0x00
	adc	a, #0x5b
	push	bc
	push	de
	ld	h, a
	call	_asset
	ld	h, a
	pop	de
	pop	bc
	ld	a, -4 (ix)
	add	a, #0x3a
	ld	l, a
	ld	a, #0x00
	adc	a, #0x0e
	push	bc
	push	de
	push	hl
	inc	sp
	ld	h, a
	call	_glyph
	pop	de
	pop	bc
00126$:
	inc	e
	ld	a, e
	sub	a, #0x06
	jr	C, 00125$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:44: drawing[0x37]^=255;say(0x3e88);
	ld	hl, #_drawing+55
	ld	a, (hl)
	cpl
	ld	(hl), a
	ld	hl, #0x3e88
	call	_say
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:45: if(lit())for(i=0;i<OBJECT_COUNT;i++)if(objects[i].room==place()&&objects[i].key[0]!=' '){
	call	_lit
	or	a, a
	jr	Z, 00121$
	ld	-1 (ix), #0x00
00127$:
	ld	c, -1 (ix)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	a, l
	add	a, #<(_objects)
	ld	c, a
	ld	a, h
	adc	a, #>(_objects)
	ld	b, a
	ld	e, c
	ld	d, b
	ld	hl, #6
	add	hl, de
	ld	e, (hl)
	push	bc
	push	de
	call	_place
	pop	de
	pop	bc
	sub	a, e
	jr	NZ, 00128$
	ld	a, (bc)
	sub	a, #0x20
	jr	Z, 00128$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:46: if(found)say(0x5b8e);found=1;say(object_name(i));a=object_art(i);if(a)draw(a);
	ld	a, -2 (ix)
	or	a, a
	jr	Z, 00113$
	ld	hl, #0x5b8e
	call	_say
00113$:
	ld	-2 (ix), #0x01
	ld	a, -1 (ix)
	call	_object_name
	ex	de, hl
	call	_say
	ld	a, -1 (ix)
	call	_object_art
	ld	a, d
	or	a, e
	jr	Z, 00128$
	ex	de, hl
	call	_draw
00128$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:45: if(lit())for(i=0;i<OBJECT_COUNT;i++)if(objects[i].room==place()&&objects[i].key[0]!=' '){
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x21
	jr	C, 00127$
00121$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:48: if(!found)say(0x3ebf);else native_putchar('.');newline();
	ld	a, -2 (ix)
	or	a, a
	jr	NZ, 00123$
	ld	hl, #0x3ebf
	call	_say
	jp	00124$
00123$:
	ld	a, #0x2e
	call	_native_putchar
00124$:
	call	_newline
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:49: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:50: static void restart(void){u16 a;u8 i,j,*p;
;	---------------------------------
; Function restart
; ---------------------------------
_restart:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-6
	add	hl, sp
	ld	sp, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:51: for(i=0;i<OBJECT_COUNT;i++){p=(u8*)&objects[i];a=0x4c7a+(u16)i*25;for(j=0;j<25;j++)p[j]=asset(a+j);}
	ld	c, #0x00
00105$:
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ex	(sp), hl
	ld	e, c
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #0x4c7a
	add	hl, de
	ld	-4 (ix), l
	ld	-3 (ix), h
	ld	b, #0x00
00103$:
	ld	a, -6 (ix)
	add	a, b
	ld	-2 (ix), a
	ld	a, -5 (ix)
	adc	a, #0x00
	ld	-1 (ix), a
	ld	e, b
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	d, #0x00
	add	hl, de
	push	bc
	call	_asset
	pop	bc
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), a
	inc	b
	ld	a, b
	sub	a, #0x19
	jr	C, 00103$
	inc	c
	ld	a, c
	sub	a, #0x21
	jr	C, 00105$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:52: memset(&adventure,0,sizeof(adventure));adventure.room=1;
	ld	hl, #_adventure+0
	push	hl
	ld	hl, #_adventure
	ld	(hl), #0x00
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x0008
	ldir
	pop	hl
	ld	(hl), #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:53: setpair(&objects[COMPUTER].name_hi,0x5203);setpair(&objects[REACTOR].name_hi,0x529f);
	ld	de, #0x5203
	ld	hl, #(_objects + 329)
	call	_setpair
	ld	de, #0x529f
	ld	hl, #(_objects + 754)
	call	_setpair
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:54: setpair(&objects[BOX].art_hi,0x542c);setpair(&objects[CHEST].art_hi,0x54e3);
	ld	de, #0x542c
	ld	hl, #(_objects + 23)
	call	_setpair
	ld	de, #0x54e3
	ld	hl, #(_objects + 98)
	call	_setpair
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:55: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:56: static u8 move_to(u8 destination){u8 old=adventure.room,result;
;	---------------------------------
; Function move_to
; ---------------------------------
_move_to:
	ld	c, a
	ld	hl, #_adventure
	ld	b, (hl)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:57: if(!destination)return answer(0x422d,TURN);
	ld	a, c
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x422d
	call	_answer
	ret
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:58: if(old==86&&destination==87&&objects[MUTANT].key[0]!=' ')return answer(0x4766,TURN);
	ld	a, b
	sub	a, #0x56
	jr	NZ, 00104$
	ld	a, c
	sub	a, #0x57
	jr	NZ, 00104$
	ld	a, (#(_objects + 225) + 0)
	sub	a, #0x20
	jr	Z, 00104$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4766
	call	_answer
	ret
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:59: adventure.room=destination;adventure.last_room=old;adventure.redraw_only=old==destination;
	ld	hl, #_adventure
	ld	(hl), c
	inc	hl
	ld	(hl), b
	ld	a, c
	sub	a, b
	ld	a, #0x01
	jr	Z, 00292$
	xor	a, a
00292$:
	ld	hl, #(_adventure + 5)
	ld	(hl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:60: if(destination==23&&old==22){result=docking();if(result==0)adventure.room=22;else if(result==2){pause_message(0x49d5);adventure.room=1;}}
	ld	a, c
	sub	a, #0x17
	ld	a, #0x01
	jr	Z, 00294$
	xor	a, a
00294$:
	ld	e, a
	or	a, a
	jr	Z, 00141$
	ld	a, b
	sub	a, #0x16
	jr	NZ, 00141$
	call	_docking
	ld	c, a
	or	a, a
	jr	NZ, 00110$
	ld	hl, #_adventure
	ld	(hl), #0x16
	jp	00142$
00110$:
	ld	a, c
	sub	a, #0x02
	jp	NZ, 00142$
	ld	hl, #0x49d5
	call	_pause_message
	ld	hl, #_adventure
	ld	(hl), #0x01
	jp	00142$
00141$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:61: else if((destination==53&&old==44)||(destination==65&&old==64)){
	ld	a, c
	sub	a, #0x35
	ld	a, #0x01
	jr	Z, 00300$
	xor	a, a
00300$:
	ld	l, a
	or	a, a
	jr	Z, 00139$
	ld	a, b
	sub	a, #0x2c
	jr	Z, 00134$
00139$:
	ld	a, c
	sub	a, #0x41
	ld	a, #0x01
	jr	Z, 00303$
	xor	a, a
00303$:
	ld	d, a
	or	a, a
	jr	Z, 00135$
	ld	a, b
	sub	a, #0x40
	jr	NZ, 00135$
00134$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:62: if(!security(destination==53)){if(destination==53){adventure.room=23;pause_message(0x4a88);}else{adventure.room=61;objects[FLASHLIGHT].on=0;pause_message(0x4ae2);}}
	push	hl
	ld	a, l
	call	_security
	pop	hl
	or	a, a
	jr	NZ, 00142$
	or	a, l
	jr	Z, 00113$
	ld	hl, #_adventure
	ld	(hl), #0x17
	ld	hl, #0x4a88
	call	_pause_message
	jp	00142$
00113$:
	ld	hl, #_adventure
	ld	(hl), #0x3d
	ld	hl, #_objects+441
	ld	(hl), #0x00
	ld	hl, #0x4ae2
	call	_pause_message
	jp	00142$
00135$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:64: else if((old==30&&destination==31)||(old==31&&destination==30)||(old==65&&destination==66)||(old==66&&destination==65)||(old==24&&destination==76)||(old==76&&destination==24)){
	ld	a, b
	sub	a, #0x1e
	jr	NZ, 00125$
	ld	a, c
	sub	a, #0x1f
	jr	Z, 00120$
00125$:
	ld	a, b
	sub	a, #0x1f
	jr	NZ, 00127$
	ld	a, c
	sub	a, #0x1e
	jr	Z, 00120$
00127$:
	ld	a, b
	sub	a, #0x41
	jr	NZ, 00129$
	ld	a, c
	sub	a, #0x42
	jr	Z, 00120$
00129$:
	ld	a, b
	sub	a, #0x42
	jr	NZ, 00131$
	or	a, d
	jr	NZ, 00120$
00131$:
	ld	a, b
	sub	a, #0x18
	jr	NZ, 00133$
	ld	a, c
	sub	a, #0x4c
	jr	Z, 00120$
00133$:
	ld	a, b
	sub	a, #0x4c
	jr	NZ, 00121$
	ld	a, c
	sub	a, #0x18
	jr	NZ, 00121$
00120$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:65: hostsound();say(0x4102);
	call	_hostsound
	ld	hl, #0x4102
	call	_say
	jp	00142$
00121$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:67: else if(old==22&&destination==23)say(0x40de);
	ld	a, b
	sub	a, #0x16
	jr	NZ, 00142$
	or	a, e
	jr	Z, 00142$
	ld	hl, #0x40de
	call	_say
00142$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:68: return CHANGE;
	ld	a, #0x03
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:69: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:70: static u8 movement(char c){u8 i;u16 a=0x5723+(u16)(adventure.room-1)*6;for(i=0;i<6;i++)if(c==asset(0x5b88+i))return move_to(asset(a+i));return answer(0x422d,TURN);}
;	---------------------------------
; Function movement
; ---------------------------------
_movement:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ld	c, a
	ld	hl, #_adventure+0
	ld	e, (hl)
	ld	d, #0x00
	dec	de
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	de, #0x5723
	add	hl, de
	ex	(sp), hl
	ld	e, #0x00
00104$:
	ld	-2 (ix), e
	ld	-1 (ix), #0x00
	ld	a, -2 (ix)
	add	a, #0x88
	ld	l, a
	ld	a, #0x00
	adc	a, #0x5b
	push	bc
	push	de
	ld	h, a
	call	_asset
	pop	de
	pop	bc
	sub	a, c
	jr	NZ, 00105$
	pop	bc
	push	bc
	ld	l, -2 (ix)
	ld	h, #0x00
	add	hl, bc
	call	_asset
	call	_move_to
	jp	00106$
00105$:
	inc	e
	ld	a, e
	sub	a, #0x06
	jr	C, 00104$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x422d
	call	_answer
00106$:
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:71: static u8 reveal(Object *o){u8 id,letter;if(o->reveal1){id=o->reveal1;letter=o->letter1;o->reveal1=0;}else if(o->reveal2){id=o->reveal2;letter=o->letter2;o->reveal2=0;}else return 0;if(id<=OBJECT_COUNT)objects[id-1].key[0]=letter;return 1;}
;	---------------------------------
; Function reveal
; ---------------------------------
_reveal:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	iy, #-7
	add	iy, sp
	ld	sp, iy
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	a, -2 (ix)
	add	a, #0x09
	ld	-5 (ix), a
	ld	a, -1 (ix)
	adc	a, #0x00
	ld	-4 (ix), a
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	a, (hl)
	ld	-3 (ix), a
	or	a, a
	jr	Z, 00105$
	ld	a, -3 (ix)
	ld	-7 (ix), a
	ld	c, -2 (ix)
	ld	b, -1 (ix)
	ld	hl, #10
	add	hl, bc
	ld	c, (hl)
	ld	l, -5 (ix)
	ld	h, -4 (ix)
	ld	(hl), #0x00
	jp	00106$
00105$:
	ld	a, -2 (ix)
	add	a, #0x0b
	ld	-6 (ix), a
	ld	a, -1 (ix)
	adc	a, #0x00
	ld	-5 (ix), a
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	a, (hl)
	ld	-3 (ix), a
	or	a, a
	jr	Z, 00102$
	ld	a, -3 (ix)
	ld	-7 (ix), a
	ld	a, -2 (ix)
	ld	-4 (ix), a
	ld	a, -1 (ix)
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	de, #0x000c
	add	hl, de
	ld	c, (hl)
	ld	l, -6 (ix)
	ld	h, -5 (ix)
	ld	(hl), #0x00
	jp	00106$
00102$:
	xor	a, a
	jp	00109$
00106$:
	ld	a, #0x21
	sub	a, -7 (ix)
	jr	C, 00108$
	ld	e, -7 (ix)
	ld	d, #0x00
	dec	de
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #_objects
	add	hl, de
	ld	(hl), c
00108$:
	ld	a, #0x01
00109$:
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:72: static u8 require_tool(u8 id){s8 t;if(!second_noun()){say(0x4292);return 0;}t=lookup();if(t<0){object_error(t);return 0;}if(objects[t].room){say(0x4270);return 0;}if(t+1!=id){say(0x42e0);return 0;}return 1;}
;	---------------------------------
; Function require_tool
; ---------------------------------
_require_tool:
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	ld	-1 (ix), a
	call	_second_noun
	or	a, a
	jr	NZ, 00102$
	ld	hl, #0x4292
	call	_say
	xor	a, a
	jp	00109$
00102$:
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00104$
	ld	a, c
	call	_object_error
	xor	a, a
	jp	00109$
00104$:
	ld	de, #_objects+0
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ld	hl, #0x4270
	call	_say
	xor	a, a
	jp	00109$
00106$:
	inc	c
	ld	a, -1 (ix)
	sub	a, c
	jr	Z, 00108$
	ld	hl, #0x42e0
	call	_say
	xor	a, a
	jp	00109$
00108$:
	ld	a, #0x01
00109$:
	inc	sp
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:73: static void consume(u8 i){objects[i].key[0]=' ';objects[i].room=255;adventure.items--;}
;	---------------------------------
; Function consume
; ---------------------------------
_consume:
	ld	e, a
	ld	bc, #_objects+0
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	(hl), #0x20
	ld	bc, #0x0006
	add	hl, bc
	ld	(hl), #0xff
	ld	hl, #_adventure+2
	dec	(hl)
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:74: static u8 take(void){s8 id;u8 i,any=0;Object *o;
;	---------------------------------
; Function take
; ---------------------------------
_take:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ld	c, #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:75: if(adventure.items>=5)return answer(0x4242,TURN);
	ld	a, (#(_adventure + 2) + 0)
	sub	a, #0x05
	jr	C, 00102$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4242
	call	_answer
	jp	00131$
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:76: if(same(noun,"ALL ")||same(noun,"EVER")){
	push	bc
	ld	de, #___str_55
	ld	hl, #_noun
	call	_same
	pop	bc
	or	a, a
	jr	NZ, 00147$
	push	bc
	ld	de, #___str_56
	ld	hl, #_noun
	call	_same
	pop	bc
	or	a, a
	jp	Z, 00112$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:77: for(i=0;i<OBJECT_COUNT&&adventure.items<5;i++){o=&objects[i];if(o->room==place()&&o->key[0]!=' '&&o->takeable&&!o->tool&&!o->reveal1&&!o->reveal2){o->room=0;adventure.items++;any=1;}}
00147$:
	ld	b, #0x00
00129$:
	ld	a, b
	sub	a, #0x21
	jp	NC, 00110$
	ld	a, (#(_adventure + 2) + 0)
	sub	a, #0x05
	jp	NC, 00110$
	ld	e, b
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #_objects
	add	hl, de
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	a, -2 (ix)
	add	a, #0x06
	ld	e, a
	ld	a, -1 (ix)
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	ld	l, a
	push	hl
	push	bc
	push	de
	call	_place
	pop	de
	pop	bc
	pop	hl
	sub	a, l
	jr	NZ, 00130$
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	a, (hl)
	sub	a, #0x20
	jr	Z, 00130$
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	bc
	ld	bc, #0x0015
	add	hl, bc
	pop	bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	bc
	ld	bc, #0x000f
	add	hl, bc
	pop	bc
	ld	a, (hl)
	or	a, a
	jr	NZ, 00130$
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	bc
	ld	bc, #0x0009
	add	hl, bc
	pop	bc
	ld	a, (hl)
	or	a, a
	jr	NZ, 00130$
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	push	bc
	ld	bc, #0x000b
	add	hl, bc
	pop	bc
	ld	a, (hl)
	or	a,a
	jr	NZ, 00130$
	ld	(de), a
	ld	a, (#(_adventure + 2) + 0)
	inc	a
	ld	(#(_adventure + 2)),a
	ld	c, #0x01
00130$:
	inc	b
	jp	00129$
00110$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:78: return any?CHANGE:answer(0x4292,TURN);
	ld	a, c
	or	a, a
	jr	Z, 00133$
	ld	a, #0x03
	jp	00131$
00133$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00131$
00112$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:80: id=lookup();if(id<0)return object_error(id);o=&objects[id];
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00115$
	ld	a, c
	call	_object_error
	jp	00131$
00115$:
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ex	(sp), hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:77: for(i=0;i<OBJECT_COUNT&&adventure.items<5;i++){o=&objects[i];if(o->room==place()&&o->key[0]!=' '&&o->takeable&&!o->tool&&!o->reveal1&&!o->reveal2){o->room=0;adventure.items++;any=1;}}
	ld	a, -4 (ix)
	add	a, #0x06
	ld	-2 (ix), a
	ld	a, -3 (ix)
	adc	a, #0x00
	ld	-1 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:81: if(!o->room)return answer(0x42c9,TURN);
	pop	de
	pop	hl
	push	hl
	push	de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00117$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x42c9
	call	_answer
	jp	00131$
00117$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:82: if((o->triggers&2)&&reveal(o))say(0x3ee1);
	pop	de
	push	de
	ld	hl, #22
	add	hl, de
	bit	1, (hl)
	jr	Z, 00119$
	push	bc
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	call	_reveal
	pop	bc
	or	a, a
	jr	Z, 00119$
	push	bc
	ld	hl, #0x3ee1
	call	_say
	pop	bc
00119$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:83: if(!o->takeable)return answer(id==POSTER?0x4672:0x421a,TURN);
	pop	de
	push	de
	ld	hl, #21
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00122$
	ld	a, c
	sub	a, #0x0c
	jr	NZ, 00135$
	ld	bc, #0x4672
	jp	00136$
00135$:
	ld	bc, #0x421a
00136$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	l, c
	ld	h, b
	call	_answer
	jp	00131$
00122$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:84: if(o->tool){if(!require_tool(o->tool))return TURN;o->tool=0;}
	pop	hl
	push	hl
	ld	de, #0x000f
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00126$
	push	hl
	call	_require_tool
	pop	hl
	or	a, a
	jr	NZ, 00124$
	ld	a, #0x01
	jp	00131$
00124$:
	ld	(hl), #0x00
00126$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:85: o->room=0;adventure.items++;return CHANGE;
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	(hl), #0x00
	ld	a, (#(_adventure + 2) + 0)
	inc	a
	ld	(#(_adventure + 2)),a
	ld	a, #0x03
00131$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:86: }
	ld	sp, ix
	pop	ix
	ret
___str_55:
	.ascii "ALL "
	.db 0x00
___str_56:
	.ascii "EVER"
	.db 0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:87: static u8 drop(void){u8 i;s8 id;if(same(noun,"ALL ")||same(noun,"EVER")){for(i=0;i<OBJECT_COUNT;i++)if(!objects[i].room)objects[i].room=place();adventure.items=0;return CHANGE;}id=lookup();if(id<0)return object_error(id);if(objects[id].room)return answer(0x4270,TURN);objects[id].room=place();adventure.items--;return CHANGE;}
;	---------------------------------
; Function drop
; ---------------------------------
_drop:
	ld	de, #___str_57
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00117$
	ld	de, #___str_58
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	Z, 00105$
00117$:
	ld	c, #0x00
00111$:
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00112$
	push	hl
	push	bc
	call	_place
	pop	bc
	pop	hl
	ld	(hl), a
00112$:
	inc	c
	ld	a, c
	sub	a, #0x21
	jr	C, 00111$
	ld	hl, #_adventure+2
	ld	(hl), #0x00
	ld	a, #0x03
	ret
00105$:
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00108$
	ld	a, c
	jp	_object_error
00108$:
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	bc, #0x0006
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4270
	call	_answer
	ret
00110$:
	push	hl
	call	_place
	pop	hl
	ld	(hl), a
	ld	hl, #_adventure+2
	dec	(hl)
	ld	a, #0x03
	ret
___str_57:
	.ascii "ALL "
	.db 0x00
___str_58:
	.ascii "EVER"
	.db 0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:88: static u8 inspect(u8 reading,u8 has_noun){s8 id;Object *o;
;	---------------------------------
; Function inspect
; ---------------------------------
_inspect:
	ld	c, a
	ld	a, l
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:89: if(!has_noun)return REDRAW;
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x02
	ret
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:90: id=lookup();if(id<0)return id==-1?REDRAW:object_error(id);o=&objects[id];
	push	bc
	call	_lookup
	ld	e, a
	pop	bc
	bit	7, e
	jr	Z, 00104$
	ld	a, e
	inc	a
	jr	NZ, 00119$
	ld	a, #0x02
	ret
00119$:
	ld	a, e
	jp	_object_error
00104$:
	ld	a, e
	rlca
	sbc	a, a
	ld	d, a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #_objects
	add	hl, de
	ex	de, hl
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:91: if(reading){if(o->takeable&&o->room)return answer(0x4270,TURN);say(pair(o->read_hi,o->read_lo));}
	ld	a, c
	or	a, a
	jr	Z, 00115$
	ld	c, e
	ld	b, d
	ld	hl, #21
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	push	de
	pop	iy
	ld	a, 6 (iy)
	or	a, a
	jr	Z, 00106$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4270
	call	_answer
	ret
00106$:
	ld	c, e
	ld	b, d
	ld	hl, #14
	add	hl, bc
	ld	c, (hl)
	ld	hl, #13
	add	hl, de
	ld	a, (hl)
	ld	l, c
	call	_pair
	ex	de, hl
	call	_say
	jp	00116$
00115$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:92: else{if((o->triggers&1)&&o->open>0&&o->open<128&&reveal(o))say(0x3ee1);else say(pair(o->examine_hi,o->examine_lo));}
	push	de
	pop	iy
	ld	a, 22 (iy)
	rrca
	jr	NC, 00109$
	push	de
	pop	iy
	ld	a, 20 (iy)
	or	a, a
	jr	Z, 00109$
	sub	a, #0x80
	jr	NC, 00109$
	ex	de, hl
	push	hl
	call	_reveal
	pop	de
	or	a, a
	jr	Z, 00109$
	ld	hl, #0x3ee1
	call	_say
	jp	00116$
00109$:
	push	de
	pop	iy
	ld	c, 8 (iy)
	ld	hl, #7
	add	hl, de
	ld	a, (hl)
	ld	l, c
	call	_pair
	ex	de, hl
	call	_say
00116$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:93: return TURN;
	ld	a, #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:94: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:95: static u8 open_object(void){s8 id=lookup();Object *o;
;	---------------------------------
; Function open_object
; ---------------------------------
_open_object:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
	call	_lookup
	ld	-3 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:96: if(id<0)return object_error(id);o=&objects[id];
	bit	7, -3 (ix)
	jr	Z, 00102$
	ld	a, -3 (ix)
	call	_object_error
	jp	00123$
00102$:
	ld	bc, #_objects+0
	ld	e, -3 (ix)
	ld	a, e
	rlca
	sbc	a, a
	ld	d, a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:97: if(o->tool&&!require_tool(o->tool))return TURN;
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	bc, #15
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	call	_require_tool
	or	a, a
	jr	NZ, 00104$
	ld	a, #0x01
	jp	00123$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:98: if(o->open<128)return answer(o->open==2?0x421a:0x429d,TURN);
	ld	a, -2 (ix)
	add	a, #0x14
	ld	c, a
	ld	a, -1 (ix)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	cp	a, #0x80
	jr	NC, 00107$
	sub	a, #0x02
	jr	NZ, 00125$
	ld	hl, #0x421a
	jp	00126$
00125$:
	ld	hl, #0x429d
00126$:
	ld	a, #0x01
	push	af
	inc	sp
	call	_answer
	jp	00123$
00107$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:99: if(o->destination){o->open=1;if(id==BOX||id==CHEST){setpair(&o->art_hi,id==BOX?0x5444:0x54f5);draw(object_art(id));}if(id==SHUTTER){game_over(0x4395);return PROMPT;}return answer(0x3f07,TURN);}
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	ld	hl, #19
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	ld	a, #0x01
	ld	(bc), a
	ld	a, -3 (ix)
	or	a, a
	jr	Z, 00108$
	ld	a, -3 (ix)
	sub	a, #0x03
	jr	NZ, 00109$
00108$:
	ld	a, -3 (ix)
	or	a, a
	jr	NZ, 00127$
	ld	de, #0x5444
	jp	00128$
00127$:
	ld	de, #0x54f5
00128$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	bc, #0x0017
	add	hl, bc
	call	_setpair
	ld	a, -3 (ix)
	call	_object_art
	ex	de, hl
	call	_draw
00109$:
	ld	a, -3 (ix)
	sub	a, #0x1a
	jr	NZ, 00112$
	ld	hl, #0x4395
	call	_game_over
	xor	a, a
	jp	00123$
00112$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x3f07
	call	_answer
	jp	00123$
00114$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:100: if((o->triggers&4)&&reveal(o)){o->open=1;return answer(0x3ee1,TURN);}
	ld	e, -2 (ix)
	ld	d, -1 (ix)
	ld	hl, #22
	add	hl, de
	bit	2, (hl)
	jr	Z, 00116$
	push	bc
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	call	_reveal
	pop	bc
	or	a, a
	jr	Z, 00116$
	ld	a,#0x01
	ld	(bc),a
	push	af
	inc	sp
	ld	hl, #0x3ee1
	call	_answer
	jp	00123$
00116$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:101: o->open=1;
	ld	a, #0x01
	ld	(bc), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:102: if(id==BOX||id==CHEST){setpair(&o->art_hi,id==BOX?0x5444:0x54f5);draw(object_art(id));}
	ld	a, -3 (ix)
	or	a, a
	jr	Z, 00118$
	ld	a, -3 (ix)
	sub	a, #0x03
	jr	NZ, 00119$
00118$:
	ld	a, -3 (ix)
	or	a, a
	jr	NZ, 00129$
	ld	de, #0x5444
	jp	00130$
00129$:
	ld	de, #0x54f5
00130$:
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	ld	bc, #0x0017
	add	hl, bc
	call	_setpair
	ld	a, -3 (ix)
	call	_object_art
	ex	de, hl
	call	_draw
00119$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:103: if(id==SHUTTER){game_over(0x4395);return PROMPT;}
	ld	a, -3 (ix)
	sub	a, #0x1a
	jr	NZ, 00122$
	ld	hl, #0x4395
	call	_game_over
	xor	a, a
	jp	00123$
00122$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:104: return answer(0x3f07,TURN);
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x3f07
	call	_answer
00123$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:105: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:106: static u8 repair(void){s8 id=lookup(),tool;u16 name;u8 wanted;
;	---------------------------------
; Function repair
; ---------------------------------
_repair:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
	call	_lookup
	ld	-1 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:107: if(id<0)return object_error(id);
	bit	7, -1 (ix)
	jr	Z, 00102$
	ld	a, -1 (ix)
	call	_object_error
	jp	00114$
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:108: if(objects[id].room!=adventure.room||(id!=COMPUTER&&id!=REACTOR))return answer(0x4292,TURN);
	ld	bc, #_objects+0
	ld	e, -1 (ix)
	ld	a, e
	rlca
	sbc	a, a
	ld	d, a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ex	(sp), hl
	pop	de
	push	de
	ld	hl, #6
	add	hl, de
	ld	a, (#_adventure + 0)
	sub	a, (hl)
	jr	NZ, 00103$
	ld	a, -1 (ix)
	sub	a, #0x0d
	ld	a, #0x01
	jr	Z, 00179$
	xor	a, a
00179$:
	ld	e, a
	bit	0, e
	jr	NZ, 00104$
	ld	a, -1 (ix)
	sub	a, #0x1e
	jr	Z, 00104$
00103$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00114$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:109: wanted=id==COMPUTER?GRID:MODULE;name=id==COMPUTER?0x52b5:0x52c6;
	ld	a, e
	or	a, a
	ld	l, #0x0f
	jr	NZ, 00117$
	ld	l, #0x10
00117$:
	or	a, a
	jr	Z, 00118$
	ld	de, #0x52b5
	jp	00119$
00118$:
	ld	de, #0x52c6
00119$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:110: if(!second_noun())return answer(0x4292,TURN);tool=lookup();if(tool<0)return object_error(tool);
	push	hl
	push	bc
	push	de
	call	_second_noun
	pop	de
	pop	bc
	pop	hl
	or	a, a
	jr	NZ, 00108$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00114$
00108$:
	push	hl
	push	bc
	push	de
	call	_lookup
	ld	-1 (ix), a
	pop	de
	pop	bc
	pop	hl
	bit	7, -1 (ix)
	jr	Z, 00110$
	ld	a, -1 (ix)
	call	_object_error
	jp	00114$
00110$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:111: if((u8)tool!=wanted||objects[tool].room)return answer(0x4270,TURN);
	ld	a, -1 (ix)
	sub	a, l
	jr	NZ, 00111$
	push	de
	ld	e, -1 (ix)
	ld	a, e
	rlca
	sbc	a, a
	ld	d, a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	pop	de
	add	hl, bc
	ld	bc, #0x0006
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
00111$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4270
	call	_answer
	jp	00114$
00112$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:112: setpair(&objects[id].name_hi,name);consume(tool);return answer(0x4662,TURN);
	pop	hl
	push	hl
	ld	bc, #0x0004
	add	hl, bc
	call	_setpair
	ld	a, -1 (ix)
	call	_consume
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4662
	call	_answer
00114$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:113: }
	ld	sp, ix
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:114: static u8 use(void){s8 id=lookup();if(id<0)return object_error(id);
;	---------------------------------
; Function use
; ---------------------------------
_use:
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00102$
	ld	a, c
	jp	_object_error
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:115: if(id!=COMPUTER||objects[id].room!=adventure.room||objects[GRID].key[0]!=' ')return answer(0x4292,TURN);
	ld	a,c
	cp	a,#0x0d
	jr	NZ, 00103$
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (#_adventure + 0)
	sub	a, (hl)
	jr	NZ, 00103$
	ld	a, (#_objects + 375)
	sub	a, #0x20
	jr	Z, 00104$
00103$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	ret
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:116: say(0x4080);draw(0x69c3);say(0x4062);wait_any();objects[CARD].key[0]='C';return CHANGE;
	ld	hl, #0x4080
	call	_say
	ld	hl, #0x69c3
	call	_draw
	ld	hl, #0x4062
	call	_say
	call	_wait_any
	ld	hl, #_objects + 350
	ld	(hl), #0x43
	ld	a, #0x03
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:117: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:118: static u8 combine(void){s8 first=lookup(),second;if(first<0)return object_error(first);
;	---------------------------------
; Function combine
; ---------------------------------
_combine:
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00102$
	ld	a, c
	call	_object_error
	jp	00117$
00102$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:119: if((first!=MUSHROOM&&first!=SEAWEED)||objects[first].room)return answer(0x4270,TURN);
	ld	a, c
	sub	a, #0x07
	ld	a, #0x01
	jr	Z, 00169$
	xor	a, a
00169$:
	ld	-1 (ix), a
	bit	0, -1 (ix)
	jr	NZ, 00106$
	ld	a, c
	sub	a, #0x08
	jr	NZ, 00103$
00106$:
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
00103$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4270
	call	_answer
	jp	00117$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:120: if(!second_noun())return answer(0x4292,TURN);second=lookup();if(second<0)return object_error(second);
	push	bc
	call	_second_noun
	pop	bc
	or	a, a
	jr	NZ, 00108$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00117$
00108$:
	push	bc
	call	_lookup
	pop	bc
	ld	b, a
	bit	7, b
	jr	Z, 00110$
	ld	a, b
	call	_object_error
	jp	00117$
00110$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:121: if(objects[second].room||!((first==MUSHROOM&&second==SEAWEED)||(first==SEAWEED&&second==MUSHROOM)))return answer(0x4270,TURN);
	ld	e, b
	ld	a, e
	rlca
	sbc	a, a
	ld	d, a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, #_objects
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00111$
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00115$
	ld	a, b
	sub	a, #0x08
	jr	Z, 00112$
00115$:
	ld	a, c
	sub	a, #0x08
	jr	NZ, 00111$
	ld	a, b
	sub	a, #0x07
	jr	Z, 00112$
00111$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4270
	call	_answer
	jp	00117$
00112$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:122: consume(MUSHROOM);consume(SEAWEED);objects[PILL].key[0]='P';objects[PILL].room=0;adventure.items++;return answer(0x4692,TURN);
	ld	a, #0x07
	call	_consume
	ld	a, #0x08
	call	_consume
	ld	hl, #_objects + 700
	ld	(hl), #0x50
	ld	hl, #_objects + 706
	ld	(hl), #0x00
	ld	hl, #_adventure+2
	inc	(hl)
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4692
	call	_answer
00117$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:123: }
	inc	sp
	pop	ix
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:124: static u8 eat(void){s8 id=lookup();if(id<0)return object_error(id);if(id!=PILL)return answer(0x4313,TURN);if(objects[id].room)return answer(0x4270,TURN);consume(PILL);adventure.pill_taken=1;return answer(0x409c,TURN);}
;	---------------------------------
; Function eat
; ---------------------------------
_eat:
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00102$
	ld	a, c
	jp	_object_error
00102$:
	ld	a, c
	sub	a, #0x1c
	jr	Z, 00104$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4313
	call	_answer
	ret
00104$:
	ld	de, #_objects+0
	ld	a, c
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4270
	call	_answer
	ret
00106$:
	ld	a, #0x1c
	call	_consume
	ld	hl, #_adventure+4
	ld	a,#0x01
	ld	(hl),a
	push	af
	inc	sp
	ld	hl, #0x409c
	call	_answer
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:125: static u8 shoot(void){s8 id=lookup();if(objects[BLASTER].room)return answer(0x4292,PROMPT);if(id<0)return answer(0x4292,PROMPT);hostsound();if(adventure.room!=87)return answer(0x3fb6,PROMPT);
;	---------------------------------
; Function shoot
; ---------------------------------
_shoot:
	call	_lookup
	ld	c, a
	ld	a, (#_objects + 256)
	or	a, a
	jr	Z, 00102$
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	ret
00102$:
	bit	7, c
	jr	Z, 00104$
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	ret
00104$:
	push	bc
	call	_hostsound
	pop	bc
	ld	a, (#_adventure + 0)
	sub	a, #0x57
	jr	Z, 00106$
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x3fb6
	call	_answer
	ret
00106$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:126: if(id==BLASTER&&objects[MUTANT].key[0]!=' '){game_over(0x3fee);return PROMPT;}
	ld	a, c
	sub	a, #0x0a
	jr	NZ, 00108$
	ld	a, (#_objects + 225)
	sub	a, #0x20
	jr	Z, 00108$
	ld	hl, #0x3fee
	call	_game_over
	xor	a, a
	ret
00108$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:127: if(id==MUTANT&&objects[id].key[0]!=' '){pause_message(0x402c);objects[id].key[0]=' ';return CHANGE;}return answer(0x3fb6,PROMPT);
	ld	a,c
	cp	a,#0x09
	jr	NZ, 00111$
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	a, (hl)
	sub	a, #0x20
	jr	Z, 00111$
	push	hl
	ld	hl, #0x402c
	call	_pause_message
	pop	hl
	ld	(hl), #0x20
	ld	a, #0x03
	ret
00111$:
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x3fb6
	call	_answer
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:128: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:129: static u8 light(u8 enabled,u8 automatic){s8 id=automatic?FLASHLIGHT:lookup();Object *f=&objects[FLASHLIGHT];if(id!=FLASHLIGHT)return answer(0x4292,TURN);if(f->room!=0&&f->room!=place())return answer(0x4292,TURN);
;	---------------------------------
; Function light
; ---------------------------------
_light:
	ld	c, a
	ld	a, l
	or	a, a
	jr	Z, 00113$
	ld	e, #0x11
	jp	00114$
00113$:
	push	bc
	call	_lookup
	ld	e, a
	pop	bc
00114$:
	ld	a, e
	sub	a, #0x11
	jr	Z, 00102$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	ret
00102$:
	ld	hl, #(_objects + 425) + 6
	ld	b, (hl)
	ld	a, b
	or	a, a
	jr	Z, 00104$
	push	bc
	call	_place
	pop	bc
	sub	a, b
	jr	Z, 00104$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	ret
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:130: if(!enabled){f->on=0;say(0x3f7c);}else{if(!f->battery)return answer(0x42ed,TURN);f->on=1;say(0x3e7a);}return adventure.room>=63&&adventure.room<=75?CHANGE:TURN;
	ld	a, c
	or	a, a
	jr	NZ, 00109$
	ld	hl, #(_objects + 425) + 16
	ld	(hl), #0x00
	ld	hl, #0x3f7c
	call	_say
	jp	00110$
00109$:
	ld	a, (#(_objects + 425) + 17)
	or	a, a
	jr	NZ, 00107$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x42ed
	call	_answer
	ret
00107$:
	ld	hl, #(_objects + 425) + 16
	ld	(hl), #0x01
	ld	hl, #0x3e7a
	call	_say
00110$:
	ld	a, (#_adventure + 0)
	cp	a, #0x3f
	jr	C, 00115$
	cp	a, #0x4c
	jr	NC, 00115$
	ld	a, #0x03
	ret
00115$:
	ld	a, #0x01
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:131: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:132: static u8 ending(void){s8 id=lookup();if(id<0)return object_error(id);if(id!=BUTTON||objects[id].room!=adventure.room)return answer(0x4292,TURN);
;	---------------------------------
; Function ending
; ---------------------------------
_ending:
	call	_lookup
	ld	c, a
	bit	7, c
	jr	Z, 00102$
	ld	a, c
	jp	_object_error
00102$:
	ld	a,c
	cp	a,#0x1d
	jr	NZ, 00103$
	rlca
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (#_adventure + 0)
	sub	a, (hl)
	jr	Z, 00104$
00103$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	ret
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:133: if(objects[MODULE].key[0]!=' '){game_over(0x4446);return PROMPT;}
	ld	a, (#_objects + 400)
	sub	a, #0x20
	jr	Z, 00107$
	ld	hl, #0x4446
	call	_game_over
	xor	a, a
	ret
00107$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:134: scene_clear();text_at(0xe20);say(0x3e73);say(0x5b53);drawing[0x37]^=255;draw(0x5e33);text_clear();pause_message(0x47a9);text_clear();pause_message(0x4830);text_clear();say(0x48f3);adventure.ended=1;return PROMPT;
	call	_scene_clear
	ld	hl, #0x0e20
	call	_text_at
	ld	hl, #0x3e73
	call	_say
	ld	hl, #0x5b53
	call	_say
	ld	hl, #_drawing+55
	ld	a, (hl)
	cpl
	ld	(hl), a
	ld	hl, #0x5e33
	call	_draw
	call	_text_clear
	ld	hl, #0x47a9
	call	_pause_message
	call	_text_clear
	ld	hl, #0x4830
	call	_pause_message
	call	_text_clear
	ld	hl, #0x48f3
	call	_say
	ld	hl, #_adventure + 6
	ld	(hl), #0x01
	xor	a, a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:135: }
	ret
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:136: static u8 checkpoint(u8 writing){u8 slot=noun[0]-'0',ok;u16 i,sum=0;u8 *p=(u8*)objects;
;	---------------------------------
; Function checkpoint
; ---------------------------------
_checkpoint:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	ld	-1 (ix), a
	ld	hl, #_noun+0
	ld	c, (hl)
	ld	a, c
	add	a, #0xd0
	ld	-4 (ix), a
	xor	a, a
	ld	-3 (ix), a
	ld	-2 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:137: if(noun[0]==' ')slot=1;if(slot<1||slot>9){text_string("Use SAVE 1 or LOAD 1.");return PROMPT;}
	ld	a, c
	sub	a, #0x20
	jr	NZ, 00102$
	ld	-4 (ix), #0x01
00102$:
	ld	a, -4 (ix)
	sub	a, #0x01
	jr	C, 00103$
	ld	a, #0x09
	sub	a, -4 (ix)
	jr	NC, 00104$
00103$:
	ld	hl, #___str_59
	call	_text_string
	xor	a, a
	jp	00120$
00104$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:138: if(writing){
	ld	a, -1 (ix)
	or	a, a
	jp	Z, 00114$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:139: memset(savebuffer,0,sizeof(savebuffer));memcpy(savebuffer,"MIZ2",4);
	ld	hl, #_savebuffer
	ld	(hl), #0x00
	push	hl
	ld	e, l
	ld	d, h
	inc	de
	ld	bc, #0x03ff
	ldir
	pop	hl
	ld	de, #___str_60+0
	ex	de, hl
	ldi
	ldi
	ldi
	ldi
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:140: savebuffer[4]=adventure.room;savebuffer[5]=adventure.last_room;savebuffer[6]=adventure.items;savebuffer[7]=adventure.dark_moves;savebuffer[8]=adventure.pill_taken;
	ld	a, (#_adventure + 0)
	ld	hl, #(_savebuffer + 4)
	ld	(hl), a
	inc	hl
	ld	a, (#_adventure + 1)
	ld	(hl), a
	inc	hl
	ld	a, (#_adventure + 2)
	ld	(hl), a
	inc	hl
	ld	a, (#_adventure + 3)
	ld	(hl), a
	inc	hl
	ld	a, (#_adventure + 4)
	ld	(hl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:141: savebuffer[9]=adventure.turns;savebuffer[10]=adventure.turns>>8;
	ld	bc, #_savebuffer + 9
	ld	hl, #_adventure + 7
	ld	a, (hl)
	inc	hl
	ld	(bc), a
	ld	a, (hl)
	ld	(#(_savebuffer + 10)),a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:142: memcpy(savebuffer+16,p,sizeof(objects));for(i=0;i<1000;i++)sum+=savebuffer[i];savebuffer[1000]=(u8)sum;savebuffer[1001]=sum>>8;
	ld	de, #(_savebuffer + 16)
	ld	hl, #_objects
	ld	bc, #0x0339
	ldir
	ld	bc, #0x0000
00116$:
	ld	hl, #_savebuffer
	add	hl, bc
	ld	l, (hl)
	ld	e, -3 (ix)
	ld	d, -2 (ix)
	ld	h, #0x00
	add	hl, de
	ld	-3 (ix), l
	ld	-2 (ix), h
	inc	bc
	ld	e, c
	ld	d, b
	ld	a, e
	sub	a, #0xe8
	ld	a, d
	sbc	a, #0x03
	jr	C, 00116$
	ld	a, -3 (ix)
	ld	hl, #(_savebuffer + 1000)
	ld	(hl), a
	ld	a, -2 (ix)
	inc	hl
	ld	(hl), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:143: ok=saveslot(1,slot,savebuffer);text_string(ok?"Game saved.":"SAVE failed. ROM uses slot 1.");
	ld	hl, #_savebuffer
	push	hl
	ld	l, -4 (ix)
	ld	a, #0x01
	call	_saveslot
	or	a, a
	jr	Z, 00122$
	ld	hl, #___str_61+0
	jp	00123$
00122$:
	ld	hl, #___str_62+0
00123$:
	call	_text_string
	jp	00115$
00114$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:145: ok=saveslot(0,slot,savebuffer);if(!ok){text_string("No saved game in this slot.");return PROMPT;}
	ld	hl, #_savebuffer
	push	hl
	ld	l, -4 (ix)
	xor	a, a
	call	_saveslot
	or	a, a
	jr	NZ, 00131$
	ld	hl, #___str_63
	call	_text_string
	xor	a, a
	jp	00120$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:146: for(i=0;i<1000;i++)sum+=savebuffer[i];if(memcmp(savebuffer,"MIZ2",4)||sum!=pair(savebuffer[1001],savebuffer[1000])){text_string("Invalid native saved game.");return PROMPT;}
00131$:
	ld	bc, #0x0000
00118$:
	ld	hl, #_savebuffer
	add	hl, bc
	ld	e, (hl)
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	ld	d, #0x00
	add	hl, de
	ld	-3 (ix), l
	ld	-2 (ix), h
	inc	bc
	ld	e, c
	ld	d, b
	ld	a, e
	sub	a, #0xe8
	ld	a, d
	sbc	a, #0x03
	jr	C, 00118$
	ld	hl, #_savebuffer
	ld	de, #0x0004
	push	de
	ld	de, #___str_60
	call	_memcmp
	ld	a, d
	or	a, e
	jr	NZ, 00110$
	ld	hl, #_savebuffer + 1000
	ld	l, (hl)
	ld	a, (#_savebuffer + 1001)
	call	_pair
	ld	l, -3 (ix)
	ld	h, -2 (ix)
	cp	a, a
	sbc	hl, de
	jr	Z, 00111$
00110$:
	ld	hl, #___str_64
	call	_text_string
	xor	a, a
	jp	00120$
00111$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:147: adventure.room=savebuffer[4];adventure.last_room=savebuffer[5];adventure.items=savebuffer[6];adventure.dark_moves=savebuffer[7];adventure.pill_taken=savebuffer[8];adventure.turns=pair(savebuffer[10],savebuffer[9]);
	ld	a, (#_savebuffer + 4)
	ld	hl, #_adventure
	ld	(hl), a
	inc	hl
	ld	a, (#_savebuffer + 5)
	ld	(hl), a
	inc	hl
	ld	a, (#_savebuffer + 6)
	ld	(hl), a
	inc	hl
	ld	a, (#_savebuffer + 7)
	ld	(hl), a
	inc	hl
	ld	a, (#_savebuffer + 8)
	ld	(hl), a
	ld	hl, #_savebuffer + 9
	ld	l, (hl)
	ld	a, (#_savebuffer + 10)
	call	_pair
	ld	((_adventure + 7)), de
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:148: memcpy(p,savebuffer+16,sizeof(objects));draw_room();
	ld	de, #_objects
	ld	hl, #(_savebuffer + 16)
	ld	bc, #0x0339
	ldir
	call	_draw_room
00115$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:150: return PROMPT;
	xor	a, a
00120$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:151: }
	ld	sp, ix
	pop	ix
	ret
___str_59:
	.ascii "Use SAVE 1 or LOAD 1."
	.db 0x00
___str_60:
	.ascii "MIZ2"
	.db 0x00
___str_61:
	.ascii "Game saved."
	.db 0x00
___str_62:
	.ascii "SAVE failed. ROM uses slot 1."
	.db 0x00
___str_63:
	.ascii "No saved game in this slot."
	.db 0x00
___str_64:
	.ascii "Invalid native saved game."
	.db 0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:152: static u8 execute(void){char verb[4];u8 i,action=V_UNKNOWN,has_noun;u16 p;s8 id;Object *o;
;	---------------------------------
; Function execute
; ---------------------------------
_execute:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-8
	add	hl, sp
	ld	sp, hl
	ld	-4 (ix), #0x18
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:153: parsepos=0;word(verb);for(i=0;i<sizeof(verbs)/sizeof(verbs[0]);i++)if(same(verb,verbs[i].key)){action=verbs[i].action;break;}
	xor	a, a
	ld	(_parsepos+0), a
	ld	hl, #0
	add	hl, sp
	call	_word
	ld	bc, #_verbs+0
	ld	-1 (ix), #0x00
00175$:
	ld	e, -1 (ix)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, bc
	ld	-3 (ix), l
	ld	-2 (ix), h
	push	bc
	ex	de, hl
	ld	hl, #2
	add	hl, sp
	call	_same
	pop	bc
	or	a, a
	jr	Z, 00176$
	ld	c, -3 (ix)
	ld	b, -2 (ix)
	ld	hl, #5
	add	hl, bc
	ld	a, (hl)
	ld	-4 (ix), a
	jp	00103$
00176$:
	inc	-1 (ix)
	ld	a, -1 (ix)
	sub	a, #0x37
	jr	C, 00175$
00103$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:154: has_noun=get_noun();
	call	_get_noun
	ld	-1 (ix), a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:155: switch(action){
	ld	a, #0x17
	sub	a, -4 (ix)
	jp	C, 00173$
	ld	c, -4 (ix)
	ld	b, #0x00
	ld	hl, #00516$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00516$:
	.dw	00132$
	.dw	00133$
	.dw	00105$
	.dw	00134$
	.dw	00135$
	.dw	00141$
	.dw	00139$
	.dw	00140$
	.dw	00142$
	.dw	00165$
	.dw	00166$
	.dw	00136$
	.dw	00145$
	.dw	00146$
	.dw	00143$
	.dw	00144$
	.dw	00151$
	.dw	00104$
	.dw	00158$
	.dw	00164$
	.dw	00167$
	.dw	00137$
	.dw	00138$
	.dw	00172$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:156: case V_MOVE:return movement(verb[0]);
00104$:
	ld	a, -8 (ix)
	call	_movement
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:157: case V_GO:
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:158: if(noun[0]==' '||noun[0]=='N'||noun[0]=='S'||noun[0]=='E'||noun[0]=='W'||noun[0]=='U'||noun[0]=='D'){
	ld	a, (#_noun + 0)
	cp	a, #0x20
	jr	Z, 00119$
	cp	a, #0x4e
	jr	Z, 00119$
	cp	a, #0x53
	jr	Z, 00119$
	cp	a, #0x45
	jr	Z, 00119$
	cp	a, #0x57
	jr	Z, 00119$
	cp	a, #0x55
	jr	Z, 00119$
	sub	a, #0x44
	jp	NZ, 00120$
00119$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:159: if(same(noun,"N   ")||same(noun,"NORT")||same(noun,"S   ")||same(noun,"SOUT")||same(noun,"E   ")||same(noun,"EAST")||same(noun,"W   ")||same(noun,"WEST")||same(noun,"U   ")||same(noun,"UP  ")||same(noun,"D   ")||same(noun,"DOWN"))return movement(noun[0]);
	ld	de, #___str_65
	ld	hl, #_noun
	call	_same
	or	a, a
	jp	NZ, 00106$
	ld	de, #___str_66
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_67
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_68
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_69
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_70
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_71
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_72
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_73
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_74
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_75
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	NZ, 00106$
	ld	de, #___str_76
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	Z, 00120$
00106$:
	ld	a, (#_noun + 0)
	call	_movement
	jp	00179$
00120$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:161: id=lookup();if(id<0)return object_error(id);o=&objects[id];if(o->open>=128||!o->open)return answer(o->open>=128?0x3f35:0x3ef9,TURN);return move_to(o->destination);
	call	_lookup
	ld	e, a
	bit	7, e
	jr	Z, 00128$
	ld	a, e
	call	_object_error
	jp	00179$
00128$:
	ld	bc, #_objects+0
	ld	a, e
	rlca
	sbc	a, a
	ld	d, a
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	-2 (ix), l
	ld	-1 (ix), h
	ld	bc, #20
	add	hl, bc
	ld	b, (hl)
	ld	a, b
	sub	a, #0x80
	ld	a, #0x00
	rla
	ld	c, a
	bit	0, c
	jr	Z, 00129$
	ld	a, b
	or	a, a
	jr	NZ, 00130$
00129$:
	bit	0, c
	jr	NZ, 00181$
	ld	hl, #0x3f35
	jp	00182$
00181$:
	ld	hl, #0x3ef9
00182$:
	ld	a, #0x01
	push	af
	inc	sp
	call	_answer
	jp	00179$
00130$:
	ld	c, -2 (ix)
	ld	b, -1 (ix)
	ld	hl, #19
	add	hl, bc
	ld	a, (hl)
	call	_move_to
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:162: case V_TAKE:return has_noun?take():answer(0x4292,TURN);
00132$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00183$
	call	_take
	jp	00179$
00183$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:163: case V_DROP:return has_noun?drop():answer(0x4292,TURN);
00133$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00185$
	call	_drop
	jp	00179$
00185$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:164: case V_LOOK:return inspect(0,has_noun);
00134$:
	ld	l, -1 (ix)
	xor	a, a
	call	_inspect
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:165: case V_READ:return has_noun?inspect(1,1):answer(0x4292,TURN);
00135$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00187$
	ld	a,#0x01
	ld	l,a
	call	_inspect
	jp	00179$
00187$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:166: case V_OPEN:return has_noun?open_object():answer(0x4292,TURN);
00136$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00189$
	call	_open_object
	jp	00179$
00189$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:167: case V_REPAIR:return has_noun?repair():answer(0x4292,TURN);
00137$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00191$
	call	_repair
	jp	00179$
00191$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:168: case V_USE:return has_noun?use():answer(0x4292,TURN);
00138$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00193$
	call	_use
	jp	00179$
00193$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:169: case V_COMBINE:return has_noun?combine():answer(0x4292,TURN);
00139$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00195$
	call	_combine
	jp	00179$
00195$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:170: case V_EAT:return has_noun?eat():answer(0x4292,TURN);
00140$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00197$
	call	_eat
	jp	00179$
00197$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:171: case V_SHOOT:return has_noun?shoot():answer(0x4292,PROMPT);
00141$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00199$
	call	_shoot
	jp	00179$
00199$:
	xor	a, a
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:172: case V_PUSH:return has_noun?ending():answer(0x4292,TURN);
00142$:
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00201$
	call	_ending
	jp	00179$
00201$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:173: case V_ON:return light(1,1);
00143$:
	ld	a,#0x01
	ld	l,a
	call	_light
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:174: case V_OFF:return light(0,1);
00144$:
	ld	l, #0x01
	xor	a, a
	call	_light
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:175: case V_LIGHT:return light(verb[0]!='U',0);
00145$:
	ld	a, -8 (ix)
	sub	a, #0x55
	ld	a, #0x01
	jr	Z, 00526$
	xor	a, a
00526$:
	xor	a, #0x01
	ld	l, #0x00
	call	_light
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:176: case V_TURN:i=same(noun,"OFF ")?0:same(noun,"ON  ")?1:2;if(i==2)return answer(0x4292,TURN);if(!get_noun())return answer(0x4292,TURN);return light(i,0);
00146$:
	ld	de, #___str_77
	ld	hl, #_noun
	call	_same
	or	a, a
	jr	Z, 00203$
	ld	c, #0x00
	jp	00204$
00203$:
	ld	de, #___str_78
	ld	hl, #_noun
	call	_same
	or	a, a
	ld	c, #0x01
	jr	NZ, 00206$
	ld	c, #0x02
00206$:
00204$:
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00148$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
00148$:
	push	bc
	call	_get_noun
	pop	bc
	or	a, a
	jr	NZ, 00150$
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4292
	call	_answer
	jp	00179$
00150$:
	ld	l, #0x00
	ld	a, c
	call	_light
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:177: case V_INVENTORY:
00151$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:178: newline();say(0x3ea9);if(!adventure.items)say(0x3ebf);else for(i=0;i<OBJECT_COUNT;i++)if(!objects[i].room){say(object_name(i));newline();}return PROMPT;
	call	_newline
	ld	hl, #0x3ea9
	call	_say
	ld	a, (#(_adventure + 2) + 0)
	or	a, a
	jr	NZ, 00246$
	ld	hl, #0x3ebf
	call	_say
	jp	00157$
00246$:
	ld	c, #0x00
00177$:
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_objects
	add	hl, de
	ld	de, #0x0006
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00178$
	push	bc
	ld	a, c
	call	_object_name
	ex	de, hl
	call	_say
	call	_newline
	pop	bc
00178$:
	inc	c
	ld	a, c
	sub	a, #0x21
	jr	C, 00177$
00157$:
	xor	a, a
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:179: case V_HELP:
00158$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:180: random_seed=random_seed*17+11;i=(random_seed&3)*2;if(adventure.room==61)i=10;else if(adventure.room==33)i=8;newline();say(assetword(0x4164+i));return TURN;
	ld	a, (_random_seed)
	ld	c, a
	add	a, a
	add	a, a
	add	a, a
	add	a, a
	add	a, c
	add	a, #0x0b
	ld	(_random_seed+0), a
	ld	a, (_random_seed)
	and	a, #0x03
	add	a, a
	ld	c, a
	ld	a, (#_adventure + 0)
	cp	a, #0x3d
	jr	NZ, 00162$
	ld	c, #0x0a
	jp	00163$
00162$:
	sub	a, #0x21
	jr	NZ, 00163$
	ld	c, #0x08
00163$:
	push	bc
	call	_newline
	pop	bc
	ld	b, #0x00
	ld	hl, #0x4164
	add	hl, bc
	call	_assetword
	ex	de, hl
	call	_say
	ld	a, #0x01
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:181: case V_SCORE:say(0x3f63);number(adventure.turns);say(0x3f73);return PROMPT;
00164$:
	ld	hl, #0x3f63
	call	_say
	ld	hl, (#(_adventure + 7) + 0)
	call	_number
	ld	hl, #0x3f73
	call	_say
	xor	a, a
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:182: case V_SAVE:return checkpoint(1);
00165$:
	ld	a, #0x01
	call	_checkpoint
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:183: case V_LOAD:return checkpoint(0);
00166$:
	xor	a, a
	call	_checkpoint
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:184: case V_QUIT:say(0x3e93);input_line(line);if(line[0]!='Y')return CHANGE;say(0x3f43);input_line(line);if(line[0]=='Y')return RESTART;adventure.ended=1;return PROMPT;
00167$:
	ld	hl, #0x3e93
	call	_say
	ld	hl, #_line
	call	_input_line
	ld	a, (#_line + 0)
	sub	a, #0x59
	jr	Z, 00169$
	ld	a, #0x03
	jp	00179$
00169$:
	ld	hl, #0x3f43
	call	_say
	ld	hl, #_line
	call	_input_line
	ld	a, (#_line + 0)
	sub	a, #0x59
	jr	NZ, 00171$
	ld	a, #0x04
	jp	00179$
00171$:
	ld	hl, #_adventure+6
	ld	(hl), #0x01
	xor	a, a
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:185: case V_SWEAR:return answer(0x4493,TURN);
00172$:
	ld	a, #0x01
	push	af
	inc	sp
	ld	hl, #0x4493
	call	_answer
	jp	00179$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:186: default:p=0x4205;say(p);return PROMPT;
00173$:
	ld	hl, #0x4205
	call	_say
	xor	a, a
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:187: }
00179$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:188: }
	ld	sp, ix
	pop	ix
	ret
___str_65:
	.ascii "N   "
	.db 0x00
___str_66:
	.ascii "NORT"
	.db 0x00
___str_67:
	.ascii "S   "
	.db 0x00
___str_68:
	.ascii "SOUT"
	.db 0x00
___str_69:
	.ascii "E   "
	.db 0x00
___str_70:
	.ascii "EAST"
	.db 0x00
___str_71:
	.ascii "W   "
	.db 0x00
___str_72:
	.ascii "WEST"
	.db 0x00
___str_73:
	.ascii "U   "
	.db 0x00
___str_74:
	.ascii "UP  "
	.db 0x00
___str_75:
	.ascii "D   "
	.db 0x00
___str_76:
	.ascii "DOWN"
	.db 0x00
___str_77:
	.ascii "OFF "
	.db 0x00
___str_78:
	.ascii "ON  "
	.db 0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:189: void game(void){u8 i,result=PROMPT;
;	---------------------------------
; Function game
; ---------------------------------
_game::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
	ld	-1 (ix), #0x00
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:190: hostinit();memset(drawing,0,sizeof(drawing));for(i=0;i<0x35;i++)drawing[i]=*(const u8*)(ASSET_BASE+0x6c00-0x3b26+i);
	call	_hostinit
	ld	hl, #_drawing
	ld	b, #0x40
00215$:
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
	inc	hl
	djnz	00215$
	ld	e, #0x00
00123$:
	ld	hl, #_drawing
	ld	d, #0x00
	add	hl, de
	ld	c, e
	ld	b, #0x00
	ld	iy, #0xbcda
	add	iy, bc
	ld	a, 0 (iy)
	ld	(hl), a
	inc	e
	ld	a, e
	sub	a, #0x35
	jr	C, 00123$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:191: video_mode(1);draw(0x5d9c);wait_any();native_video_fill(0xe00,0x2600,255);
	ld	a, #0x01
	call	_video_mode
	ld	hl, #0x5d9c
	call	_draw
	call	_wait_any
	ld	a, #0xff
	push	af
	inc	sp
	ld	de, #0x2600
	ld	hl, #0x0e00
	call	_native_video_fill
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:192: scene_clear();text_at(0xe20);say(0x3e73);say(0x5b49);draw(0x5edd);drawing[0x37]^=255;text_clear();pause_message(0x46f2);
	call	_scene_clear
	ld	hl, #0x0e20
	call	_text_at
	ld	hl, #0x3e73
	call	_say
	ld	hl, #0x5b49
	call	_say
	ld	hl, #0x5edd
	call	_draw
	ld	hl, #_drawing + 55
	ld	a, (hl)
	cpl
	ld	(hl), a
	call	_text_clear
	ld	hl, #0x46f2
	call	_pause_message
00127$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:194: restart();draw_room();
	call	_restart
	call	_draw_room
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:195: while(!adventure.ended){
00113$:
	ld	a, (#(_adventure + 6) + 0)
	or	a, a
	jr	NZ, 00115$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:196: say(0x3e6e);input_line(line);result=execute();
	ld	hl, #0x3e6e
	call	_say
	ld	hl, #_line
	call	_input_line
	call	_execute
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:197: if(result==RESTART)break;
	ld	-1 (ix), a
	sub	a, #0x04
	jr	Z, 00115$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:198: if(result==CHANGE)environment();
	ld	a, -1 (ix)
	sub	a, #0x03
	ld	a, #0x01
	jr	Z, 00219$
	xor	a, a
00219$:
	ld	c, a
	or	a, a
	jr	Z, 00105$
	push	bc
	call	_environment
	pop	bc
00105$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:199: if(adventure.ended)break;
	ld	a, (#(_adventure + 6) + 0)
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:200: if(result==CHANGE||result==REDRAW)draw_room();
	or	a, a
	jr	NZ, 00115$
	or	a, c
	jr	NZ, 00108$
	ld	a, -1 (ix)
	sub	a, #0x02
	jr	NZ, 00109$
00108$:
	call	_draw_room
00109$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:201: if(result!=PROMPT){adventure.turns++;battery_tick();}
	ld	a, -1 (ix)
	or	a, a
	jr	Z, 00113$
	ld	hl, (#(_adventure + 7) + 0)
	inc	hl
	ld	((_adventure + 7)), hl
	call	_battery_tick
	jp	00113$
00115$:
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:203: if(result==RESTART)continue;
	ld	a, -1 (ix)
	sub	a, #0x04
	jr	Z, 00127$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:204: say(0x3f8b);input_line(line);if(line[0]!='Y'){for(;;)hostkey();}
	ld	hl, #0x3f8b
	call	_say
	ld	hl, #_line
	call	_input_line
	ld	a, (#_line + 0)
	sub	a, #0x59
	jr	Z, 00127$
00125$:
	call	_hostkey
	jp	00125$
;C:\Users\Anderson\Documents\Codex\2026-10-23\https-github-com-morluto-rea-https\outputs\MISTAR-MSX-Z80-nativo\fontes\adventure.c:206: }
	inc	sp
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
