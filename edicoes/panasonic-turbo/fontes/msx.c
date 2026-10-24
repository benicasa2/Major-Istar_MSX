#include "cpu.h"
#include "turbo.h"
#include <string.h>
__sfr __at(0x98) vdata;
__sfr __at(0x99) vctrl;
__sfr __at(0xa9) keys;
__sfr __at(0xaa) rowselect;
__sfr __at(0x9a) palette;
#ifndef MSX2_TARGET
#include "color_lut.h"
#endif
static u8 lastkey,diskmode,ram_saved,phase,vram_bank,full_color;
u8 dirty[768],dirty_any;
extern u8 video[6144];
static u16 next_write;
u16 disk_sector;
u8 *disk_buffer;
volatile u16 faultpc;volatile u8 faultop;
volatile u8 waiting_kind;
volatile u16 frames_flushed;
u8 disk_transfer(u8 writing) __naked {
 writing;
 __asm
 push ix
 push iy
 ld hl,(_disk_buffer)
 ld de,(_disk_sector)
 ld bc,#0x02f9
 and a
 rra
 call 0x0144
 di
 ld a,#0
 adc a,#0
 xor #1
 pop iy
 pop ix
 ret
 __endasm;
}
u8 saveslot(u8 writing,u8 slot,u8 *buffer){if(diskmode){disk_sector=1400+((u16)(slot-1)<<1);disk_buffer=buffer;return disk_transfer(writing);}if(slot!=1)return 0;if(writing)ram_saved=1;return ram_saved;}
static void reg(u8 n,u8 v){vctrl=v;vctrl=0x80|n;}
static void addr(u16 a){
#ifdef MSX2_TARGET
 u8 bank=a>>14;if(bank!=vram_bank){reg(14,bank);vram_bank=bank;}
#endif
 vctrl=(u8)a;vctrl=0x40|((a>>8)&63);
}
void pixelbyte(u16 offset,u8 value){(void)value;dirty[offset>>3]|=1<<(offset&7);dirty_any=1;}
void video_changed(u16 offset,u16 length){u16 first=offset>>3,last=(offset+length-1)>>3;memset(dirty+first,255,last-first+1);dirty_any=1;}
void video_mode(u8 full_screen){if(full_color!=full_screen){full_color=full_screen;memset(dirty,255,sizeof(dirty));dirty_any=1;}}
static void render(u16 offset){u8 value=video[offset];u8 y=offset>>5;
#ifdef MSX2_TARGET
 static const u8 artifact[4]={0x11,0x44,0x88,0xff};
 static const u8 mono[4]={0x11,0x1f,0xf1,0xff};
 const u8 *lut=(full_color||(y>=9&&y<104))?artifact:mono;
 {u16 p=offset<<2;if(p!=next_write||!(p&0x3fff))addr(p);next_write=p+4;}vdata=lut[value>>6];vdata=lut[(value>>4)&3];vdata=lut[(value>>2)&3];vdata=lut[value&3];
#else
 u16 p=(offset&0x1f00)|((offset&31)<<3)|((offset>>5)&7);u8 pattern=value,color=0xf1;
 if(full_color||(y>=9&&y<104)){pattern=color_pattern[value];color=phase?color_flipped[value]:color_attribute[value];}
 addr(p);vdata=pattern;addr(p+0x2000);vdata=color;
#endif
}
static void flush(void){u16 i,offset;u8 b,n;if(!dirty_any)return;dirty_any=0;next_write=65535;
 for(i=0;i<768;i++){b=dirty[i];if(!b)continue;dirty[i]=0;offset=i<<3;for(n=0;n<8;n++,offset++,b>>=1)if(b&1)render(offset);}
 frames_flushed++;
}
static void setphase(void){
#ifdef MSX2_TARGET
 reg(16,4);palette=phase?0x70:0x07;palette=4;
 reg(16,8);palette=phase?0x07:0x70;palette=4;
#else
 memset(dirty,255,sizeof(dirty));dirty_any=1;
#endif
}
void hostinit(void){u16 i;lastkey=255;phase=0;full_color=0;dirty_any=1;frames_flushed=0;waiting_kind=0;
 memset(dirty,255,sizeof(dirty));diskmode=*(const u8*)0xbffe==0xa5;ram_saved=0;
 reg(1,0);reg(7,1);
#ifdef MSX2_TARGET
 reg(0,6);reg(2,0x1f);reg(5,0xef);reg(6,0);reg(8,2);reg(9,0);reg(10,0);reg(11,1);reg(14,0);vram_bank=0;
 reg(16,1);palette=0;palette=0;reg(16,15);palette=0x77;palette=7;setphase();
 addr(0);for(i=0;i<24576;i++)vdata=0;vram_bank=255;
#else
 reg(0,2);reg(2,6);reg(3,255);reg(4,3);reg(5,0x36);reg(6,7);
 addr(0);for(i=0;i<16384;i++)vdata=0;
 addr(0x1800);for(i=0;i<768;i++)vdata=(u8)i;
 addr(0x1b00);vdata=208;
#endif
 reg(1,0x40);
}
void host_ready(void) __naked {__asm ret __endasm;}
u8 hostkey(void){u8 row,col,b,n,found=255,c=0;const char *table="0123456789-=\\[];'/,./?AB" "CDEFGHIJKLMNOPQRSTUVWXYZ";
 waiting_kind=cpu.pc==0xa390?2:1;flush();host_ready();
 rowselect=(rowselect&0xf0)|6;if(!(keys&32)){if(lastkey!=0xfe){phase^=1;setphase();}lastkey=0xfe;return 0;}
 if(!(keys&64)){if(lastkey!=0xfd)panasonic_turbo_set(!turbo_active);lastkey=0xfd;return 0;}
 for(row=0;row<9;row++){if(row==6)continue;rowselect=(rowselect&0xf0)|row;b=keys;for(col=0;col<8;col++)if(!(b&(1<<col))){n=row*8+col;if(row<6)c=table[n];else if(row==7)c=col==7?13:col==5?8:0;else c=col==0?' ':col==4?8:col==5?0x5e:col==6?10:col==7?9:0;if(c){found=n;break;}}if(found!=255)break;}
 if(found==lastkey)return 0;lastkey=found;if(c)waiting_kind=0;return c;
}
void hostfatal(u16 p,u8 op){faultpc=p;faultop=op;panasonic_turbo_restore();reg(7,6);while(1);}
extern void game(void);
void main(void){panasonic_turbo_init();game();panasonic_turbo_restore();for(;;);}
