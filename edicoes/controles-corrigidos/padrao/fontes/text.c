/* Native Z80-compiled replacements for the original $391A/$3990 text paths.
 * Word wrapping, 8x8 font, cursor positions and scrolling retain the source
 * bitmap layout. No instruction decoder is used by these routines.
 */
#include "cpu.h"
extern void native_video_write(u16 p,u8 ch);
extern void native_video_scroll(void);
extern void native_video_fill(u16 first,u16 last,u8 value);
static void glyph(u16 p,u8 ch){u8 i;u16 f=0x3b26+((u16)(u8)(ch-32)<<3);u8 inv=rd(0x6c37);for(i=0;i<8;i++,p+=32)native_video_write(p,rd(f++)^inv);}
static void resetword(void){wr(0x6c39,0);wr(0x6c3a,0);}
void native_wrap(u8 ch){u8 n,i,count;u16 p,x;
 if(ch<=32){resetword();return;}
 n=rd(0x6c39);if(n<=14){wr(0x6c3b+n,ch);wr(0x6c39,++n);}
 p=rw(0x6c35);
 if((p&31)||!rd(0x6c3a)){wr(0x6c3a,1);return;}
 if(n>14){resetword();return;}
 x=p-rw(0x6c38);x=(x&0xff00)|(x&31);
 count=n?n:256; /* n is at least 2 on the normal wrap path. */
 i=0;do{glyph(x++,' ');}while(++i!=count);
 ww(0x6c50,cpu.u);count=n-1;i=0;
 do{glyph(p++,rd(0x6c3b+i));}while(++i!=count);
 ww(0x6c35,p);resetword();
}
static void cursor(u16 p){u8 a,r;
 if(p>=0xf20&&(p&255)>=32)p=(p&0xff00)+256;
 ww(0x6c35,p);a=p>>8;r=a-0x25;
 cpu.cc=(cpu.cc&~15)|(r?0:4)|(r&128?8:0)|(a<0x25?1:0)|(((a^0x25)&(a^r)&128)?2:0);
 if(a<=0x25)return;
 native_video_scroll();ww(0x6c35,0x2500);
 cpu.cc&=~15;
}
void native_putchar(u8 ch){u16 p;u8 r;
 native_wrap(ch);p=rw(0x6c35);
 if(ch==8){if(p==0x1b00)return;glyph(p,' ');p--;if(p&128)p-=0xe0;glyph(p,' ');cursor(p);return;}
 if(ch==13){do{glyph(p++,' ');}while(p&31);cursor(p+0xe0);return;}
 if(ch>=32){glyph(p,ch);cursor(p+1);return;}
 r=ch-32;cpu.cc=(cpu.cc&~15)|(r?0:4)|(r&128?8:0)|1;
}
void native_string(void){u8 c;while((c=rd(cpu.x++))!=0)native_putchar(c);cpu.a=0;cpu.cc=(cpu.cc&~14)|4;}
void native_text_clear(void){ww(0x6c35,0x1b00);native_video_fill(0x1b00,0x2600,255);resetword();cpu.x=0x2600;cpu.a=255;cpu.cc=(cpu.cc&~15)|5;}
