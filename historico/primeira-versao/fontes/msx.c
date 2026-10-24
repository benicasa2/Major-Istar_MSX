#include "cpu.h"
__sfr __at(0x98) vdata;
__sfr __at(0x99) vctrl;
__sfr __at(0xa9) keys;
__sfr __at(0xaa) rowselect;
__sfr __at(0x9a) palette;
static u8 lastkey;
static u8 diskmode,ram_saved;
u16 disk_sector;
u8 *disk_buffer;
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
volatile u16 faultpc;volatile u8 faultop;
static void addr(u16 a){vctrl=(u8)a;vctrl=0x40|(a>>8);}
static void reg(u8 n,u8 v){vctrl=v;vctrl=0x80|n;}
void pixelbyte(u16 offset,u8 value){u16 p=(offset&0x1f00)|((offset&31)<<3)|((offset>>5)&7);addr(p);vdata=value;}
void hostinit(void){u16 i;lastkey=255;reg(1,0);reg(0,2);reg(2,6);reg(3,255);reg(4,3);reg(5,0x36);reg(6,7);reg(7,0xf1);
 diskmode=*(const u8*)0xbffe==0xa5;ram_saved=0;
#ifdef MSX2_TARGET
 reg(16,1);palette=0x02;palette=0x01;
 reg(16,15);palette=0x77;palette=0x07;
#endif
 addr(0);for(i=0;i<16384;i++)vdata=0;
 addr(0x1800);for(i=0;i<768;i++)vdata=(u8)i;
 addr(0x2000);for(i=0;i<6144;i++)vdata=0xf1;
 addr(0x1b00);vdata=208;
 reg(1,0x40);
}
u8 hostkey(void){u8 row,col,b,n,found=255,c=0;const char *table="0123456789-=\\[];'/,./?AB" "CDEFGHIJKLMNOPQRSTUVWXYZ";
 for(row=0;row<9;row++){if(row==6)continue;rowselect=(rowselect&0xf0)|row;b=keys;for(col=0;col<8;col++)if(!(b&(1<<col))){n=row*8+col;if(row<6)c=table[n];else if(row==7)c=col==7?13:col==5?8:0;else c=col==0?' ':col==4?8:col==5?0x5e:col==6?10:col==7?9:0;if(c){found=n;break;}}if(found!=255)break;}
 if(found==lastkey)return 0;lastkey=found;return c;
}
void hostfatal(u16 p,u8 op){faultpc=p;faultop=op;u8 i;const char *h="0123456789ABCDEF";addr(0x1800);for(i=0;i<4;i++){vdata=h[(p>>12)&15];p<<=4;}reg(7,6);(void)op;while(1);}
extern void game(void);
void main(void){game();for(;;);}
