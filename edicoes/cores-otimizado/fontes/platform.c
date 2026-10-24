/* CoCo platform services replaced by MSX services. No CoCo ROM is included. */
#include "cpu.h"
#include <string.h>
#ifdef HOST_TEST
#include <stdio.h>
#include <stdlib.h>
static u8 payload[19361];
static unsigned long steps;
void graphic_checkpoint(void){static FILE *f;u16 i;if(!f){const char *p=getenv("MSX_TRACE_FILE");if(!p)return;f=fopen(p,"wb");}fwrite(&cpu.u,2,1,f);for(i=0xe00;i<0x2600;i++)fputc(rd(i),f);for(i=0x6c00;i<0x6c80;i++)fputc(rd(i),f);fflush(f);}
#endif
static u8 low[1536], stackram[512];
u8 video[6144], state[1281];
static u16 patchaddr[256];
static u8 patchval[256];
u16 patchcount;
static u8 rombank;
static u8 code_patched;
static u8 savebuffer[1024], saved;
extern u8 saveslot(u8 writing,u8 slot,u8 *buffer);
extern u8 hostkey(void);
extern void pixelbyte(u16 offset,u8 value);
extern void hostinit(void);
extern void hostfatal(u16 pc,u8 opcode);
extern void video_changed(u16 offset,u16 length);
extern void video_mode(u8 full_screen);
#ifndef HOST_TEST
extern u8 dirty[768],dirty_any;
static const u8 dirtybit[8]={1,2,4,8,16,32,64,128};
#endif
void native_video_write(u16 address,u8 value){u16 offset=address-0xe00;if(offset<6144){if(video[offset]!=value){video[offset]=value;
#ifdef HOST_TEST
pixelbyte(offset,value);
#else
dirty[offset>>3]|=dirtybit[offset&7];dirty_any=1;
#endif
}}else wr(address,value);}
void native_video_fill(u16 first,u16 last,u8 value){u16 offset=first-0xe00,n=last-first;memset(video+offset,value,n);video_changed(offset,n);}
void native_video_scroll(void){memmove(video+0xd00,video+0xe00,0xa00);memset(video+0x1700,255,256);video_changed(0xd00,0xb00);}
static u8 original(u16 a){
#ifdef HOST_TEST
 return payload[a-0x2460];
#else
 return *(const u8*)(0x7400+a-0x2460);
#endif
}
u8 rd(u16 a){u16 i;
 if(a>=0x2600&&a<0x3b26&&!code_patched)return original(a);
 if(a<sizeof(low))return low[a];
 if(a>=0xc00&&a<0xe00)return stackram[a-0xc00];
 if(a>=0xe00&&a<0x2600)return video[a-0xe00];
 if(a>=0x6c00&&a<=0x7100)return state[a-0x6c00];
 if(a>=0x2600&&a<0x6c00){for(i=0;i<patchcount;i++)if(patchaddr[i]==a)return patchval[i];return original(a);}
 if(a==0xa000||a==0xa00a||a==0xc004)return 0xff;
 if(a==0xa001)return 0x10;if(a==0xa00b)return 0x12;if(a==0xc005)return 0x14;
 if(a==0xff00)return 255;
 return 0;
}
void wr(u16 a,u8 v){u16 i;
 if(a<sizeof(low)){low[a]=v;return;}
 if(a>=0xc00&&a<0xe00){stackram[a-0xc00]=v;return;}
 if(a>=0xe00&&a<0x2600){i=a-0xe00;if(video[i]!=v){video[i]=v;pixelbyte(i,v);}return;}
 if(a>=0x6c00&&a<=0x7100){state[a-0x6c00]=v;return;}
 if(a>=0x2600&&a<0x6c00){for(i=0;i<patchcount;i++)if(patchaddr[i]==a){patchval[i]=v;return;}if(v==original(a))return;if(a<0x3b26)code_patched=1;if(patchcount==256){fatal(a,0xfe);return;}patchaddr[patchcount]=a;patchval[patchcount++]=v;return;}
 if(a>=0xff00)return;
 fatal(a,0xfd);
}
void fatal(u16 pc,u8 op){stopped=1;hostfatal(pc,op);}
static void tick(void);
extern void graphics(void);
extern void native_putchar(u8 ch);
extern void native_wrap(u8 ch);
extern void native_string(void);
extern void native_text_clear(void);
static void invoke(u16 address){Cpu saved=cpu;push16(&cpu.s,0xfffe);cpu.pc=address;while(cpu.pc!=0xfffe&&!stopped)tick();cpu=saved;}
static void emit(u8 a){cpu.a=a;invoke(0x3990);}
static void message(const char *s){while(*s)emit(*s++);emit(13);}
static void checkpoint(u8 writing){u16 i,sum=0,expect;u8 slot=rd(0x6c59),ok;
 if(slot==' ')slot='1';
 if(slot<'1'||slot>'9'){message("Use SAVE 1 or LOAD 1.");cpu.pc=0x2708;return;}
 if(writing){memset(savebuffer,0,sizeof(savebuffer));savebuffer[0]='M';savebuffer[1]='I';savebuffer[2]='S';savebuffer[3]=1;
  for(i=0;i<11;i++)savebuffer[4+i]=rd(0x6c5d+i);
  for(i=0;i<825;i++)savebuffer[15+i]=rd(0x4c7a+i);
  for(i=0;i<840;i++)sum+=savebuffer[i];savebuffer[840]=(u8)sum;savebuffer[841]=(u8)(sum>>8);
  ok=saveslot(1,slot-'0',savebuffer);if(ok){saved=1;message("Game saved.");}else message("SAVE failed. ROM uses slot 1.");cpu.pc=0x2708;
 }else{
  ok=saveslot(0,slot-'0',savebuffer);if(!ok){message("No saved game in this slot.");cpu.pc=0x2708;return;}
  for(i=0;i<840;i++)sum+=savebuffer[i];expect=savebuffer[840]|((u16)savebuffer[841]<<8);
  if(sum!=expect||savebuffer[0]!='M'||savebuffer[1]!='I'||savebuffer[2]!='S'||savebuffer[3]!=1){message("Invalid saved game.");cpu.pc=0x2708;return;}
  for(i=0;i<11;i++)wr(0x6c5d+i,savebuffer[4+i]);
  for(i=0;i<825;i++)wr(0x4c7a+i,savebuffer[15+i]);
  invoke(0x354d);invoke(0x35a9);invoke(0x32d9);invoke(0x3982);cpu.pc=0x2708;
 }
}
static void lineinput(void){u8 c,n=0,i;const char *word;
 while(!stopped){c=hostkey();if(!c)continue;
  if(!n&&(c==0x5e||c==10||c==9||c==8)){word=c==0x5e?"NORTH":c==10?"SOUTH":c==9?"EAST":"WEST";for(i=0;word[i];i++){wr(0x2dd+n++,word[i]);emit(word[i]);}c=13;}
  if(c==13){wr(0x2dd+n,0);emit(13);break;}
  if(c==8){if(n){--n;emit(8);}continue;}
  if(c>=32&&c<127&&n<63){if(c>='a'&&c<='z')c-=32;wr(0x2dd+n++,c);emit(c);}
 }
 cpu.x=0x2dd;cpu.a=0;cpu.cc=(cpu.cc&~0x0b)|4;ret();
}
static void tick(void){u16 p=cpu.pc;
#ifdef HOST_TEST
 if(++steps>20000000UL){fatal(p,0xfc);return;}
#ifdef REFERENCE_GRAPHICS
 if(p==0x369b)graphic_checkpoint();
#endif
 if(p==0x3990){u8 c=cpu.a;if(c==13)putchar('\n');else if(c>=32&&c<127)putchar(c);}
#endif
 switch(p){
#ifndef REFERENCE_TEXT
 case 0x3990:native_putchar(cpu.a);ret();return;
 case 0x391a:native_wrap(cpu.a);ret();return;
 case 0x3989:native_string();ret();return;
 case 0x3982:cpu.a=13;native_putchar(13);ret();return;
 case 0x3906:native_text_clear();ret();return;
#endif
 case 0x2df1:checkpoint(1);return;
 case 0x2d80:checkpoint(0);return;
#ifndef REFERENCE_GRAPHICS
 case 0x369b:if(cpu.u==0x5d9c)video_mode(1);graphics();ret();return;
#endif
#ifdef HOST_TEST
 case 0x377d:{u8 x=rd(0x6c6b),y=rd(0x6c6c),n=x&3,b;u16 a=((u16)rd(0x6c6a)<<8)+(x>>2)+((u16)y<<5)+0xf20;b=rd(a)&rd(0x5b95+n);wr(0x6c4b,b);b|=rd(0x6c69)&rd(0x5b91+n);wr(a,b);cpu.y=a;cpu.x=0x5b91;cpu.a=n;cpu.b=b;cpu.cc=(cpu.cc&~15)|(b?0:4)|(b&128?8:0);ret();return;}
 case 0x37de:{u16 n=cpu.b?cpu.b:256;while(n--)wr(cpu.y++,cpu.a);cpu.b=0;cpu.cc=(cpu.cc&~14)|4;cpu.pc=0x37e3;return;}
 case 0x3873:{u8 n=rd(0x6c6b)&3,b,t,r;u16 a=((u16)rd(0x6c6a)<<8)+(rd(0x6c6b)>>2)+rw(0x6c78);b=rd(a)&rd(0x5b91+n);t=rd(0x6c73+n);r=b-t;cpu.y=a;cpu.x=0x6c73;cpu.a=n;cpu.b=b;cpu.cc=(cpu.cc&~15)|(r?0:4)|(r&128?8:0)|(b<t?1:0)|(((b^t)&(b^r)&128)?2:0);ret();return;}
 case 0x388f:{u8 n=cpu.a,b=rd(cpu.y)&rd(0x5b95+n);wr(0x6c4b,b);b|=rd(0x6c72)&rd(0x5b91+n);wr(cpu.y,b);cpu.x=0x5b91;cpu.b=b;cpu.cc=(cpu.cc&~14)|(b?0:4)|(b&128?8:0);ret();return;}
#endif
 case 0x3a1e:{u16 f=0x3b26+((u16)(u8)(cpu.a-32)<<3),d=cpu.x;u8 n;for(n=0;n<8;n++){wr(d,rd(f++)^rd(0x6c37));d+=32;}cpu.cc=(cpu.cc&~14)|4;ret();return;}
 case 0x38ee:native_video_fill(cpu.x,0x2600,cpu.a);cpu.x=0x2600;cpu.cc&=~15;ret();return;
 case 0x38f6:video_mode(0);native_video_fill(0xe00,0x1ae0,0);cpu.x=0x1ae0;wr(0x6c37,0);cpu.cc=(cpu.cc&~15)|4;ret();return;
#ifdef HOST_TEST
 case 0x39fb:{u16 a;for(a=0x1c00;a<0x2600;a++)wr(a-256,rd(a));ww(0x6c35,0x2500);for(a=0x2500;a<0x2600;a++)wr(a,255);cpu.x=0x2600;cpu.u=0x2500;cpu.a=255;cpu.cc&=~15;cpu.pc=0x3a1d;return;}
#endif
 case 0x38c2:ret();return;
 case 0x38de:cpu.a=0;cpu.x=0;cpu.cc=(cpu.cc&~0x0e)|4;ret();return;
 case 0xff10:cpu.a=hostkey();cpu.cc=(cpu.cc&~0x0e)|(cpu.a?0:4)|(cpu.a&128?8:0);ret();return;
 case 0xff12:invoke(0x3990);ret();return;
 case 0xa390:lineinput();return;
 case 0xbdca:{u16 v=rw(0x68),div=10000;u8 seen=0;while(div){u8 d=0;while(v>=div){v-=div;d++;}if(d||seen||div==1){emit('0'+d);seen=1;}div/=10;}ret();return;}
 case 0xff14:fatal(p,0xfb);return;
 default:step();
 }
}
void game(void){u16 i;
 memset(&cpu,0,sizeof(cpu));memset(low,0,sizeof(low));memset(video,0,sizeof(video));memset(state,0,sizeof(state));patchcount=0;rombank=255;stopped=0;code_patched=0;
 for(i=0;i<224;i++)low[0x160+i]=original(0x2460+i);
 for(i=0;i<=0x400;i++)state[i]=original(0x6c00+i);
 /* Preserve the original anti-tamper comparison with the relocated vector. */
 cpu.s=0xdfe;cpu.pc=0x2610;cpu.cc=0x50;
#ifndef HOST_TEST
 /* Native startup replaces the CoCo hardware setup and decorative border
  * wipe. Start directly at the original title, keeping the game intro. */
 low[0x71]=0x55;low[0x72]=0x26;low[0x73]=0x10;low[0x182]=0x39;
 state[0x35]=0x25;state[0x36]=0;state[0x37]=0;state[0x38]=0;state[0x39]=0;state[0x3a]=0;state[0x5d]=0;
 cpu.pc=0x2653;
#endif
 hostinit();while(!stopped)tick();
}
#ifdef HOST_TEST
void pixelbyte(u16 a,u8 v){(void)a;(void)v;}
void video_changed(u16 a,u16 n){(void)a;(void)n;}
void video_mode(u8 mode){(void)mode;}
void hostinit(void){}
u8 saveslot(u8 writing,u8 slot,u8 *buffer){(void)buffer;if(slot!=1)return 0;return writing?1:saved;}
static void dump(void){const char *path=getenv("MSX_MEMORY_PATH");FILE*f=fopen(path?path:"work/msx/guest-memory.bin","wb");u16 i;for(i=0;i<0x8000;i++)fputc(rd(i),f);fclose(f);fprintf(stderr,"\npc=%04x s=%04x patches=%u steps=%lu\n",cpu.pc,cpu.s,patchcount,steps);}
void hostfatal(u16 p,u8 o){fprintf(stderr,"FAULT at %04x op=%02x currentPC=%04x\n",p,o,cpu.pc);dump();exit(2);}
u8 hostkey(void){int c=getchar();if(c==EOF){dump();exit(0);}return c=='\n'?13:(u8)c;}
int main(int argc,char **argv){FILE*f=fopen(argc>1?argv[1]:"outputs/MISTAR_fonte/MISTAR.raw","rb");if(!f)return 1;if(fread(payload,1,sizeof(payload),f)!=sizeof(payload))return 1;fclose(f);game();return 0;}
#endif
