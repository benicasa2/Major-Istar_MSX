/* Native Z80 game services. No processor registers, opcodes or guest stack. */
#include "game.h"
u8 video[6144],drawing[128];
extern u8 dirty[768],dirty_any;
static const u8 dirtybit[8]={1,2,4,8,16,32,64,128};
volatile u16 input_sequence;
u16 pair(u8 hi,u8 lo){return ((u16)hi<<8)|lo;}
void setpair(u8 *hi,u16 v){hi[0]=v>>8;hi[1]=(u8)v;}
u8 asset(u16 a){
 if(a>=0x6c00&&a<0x6c80)return drawing[a-0x6c00];
 if(a<0x3b26||a>=0x6c35)return 0;
 return *(const u8*)(ASSET_BASE+a-0x3b26);
}
u16 assetword(u16 a){return pair(asset(a),asset(a+1));}
void native_video_write(u16 p,u8 v){u16 i=p-0xe00;if(i<6144&&video[i]!=v){video[i]=v;dirty[i>>3]|=dirtybit[i&7];dirty_any=1;}}
void native_video_fill(u16 a,u16 b,u8 v){if(a<0xe00||b>0x2600||b<a){hostfatal(a,1);return;}memset(video+a-0xe00,v,b-a);if(b>a)video_changed(a-0xe00,b-a);}
void native_video_scroll(void){memmove(video+0xd00,video+0xe00,0xa00);memset(video+0x1700,255,256);video_changed(0xd00,0xb00);}
void glyph(u16 p,u8 c){u16 f=0x3b26+((u16)(u8)(c-32)<<3);u8 i;for(i=0;i<8;i++,p+=32)native_video_write(p,asset(f++)^drawing[0x37]);}
static u16 cursor(void){return pair(drawing[0x35],drawing[0x36]);}
void text_at(u16 p){setpair(drawing+0x35,p);drawing[0x39]=drawing[0x3a]=0;}
static void move_cursor(u16 p){
 if(p>=0xf20&&(p&255)>=32)p=(p&0xff00)+256;
 setpair(drawing+0x35,p);
 if(p>=0x2600){native_video_scroll();setpair(drawing+0x35,0x2500);}
}
static void wrap(u8 c){u8 n,i;u16 p,x;
 if(c<=32){drawing[0x39]=drawing[0x3a]=0;return;}
 n=drawing[0x39];if(n<=14){drawing[0x3b+n]=c;drawing[0x39]=++n;}
 p=cursor();if((p&31)||!drawing[0x3a]){drawing[0x3a]=1;return;}
 if(n>14){drawing[0x39]=drawing[0x3a]=0;return;}
 x=p-pair(drawing[0x38],drawing[0x39]);x=(x&0xff00)|(x&31);
 for(i=0;i<n;i++)glyph(x++,' ');
 for(i=0;i+1<n;i++)glyph(p++,drawing[0x3b+i]);
 setpair(drawing+0x35,p);drawing[0x39]=drawing[0x3a]=0;
}
void native_putchar(u8 c){u16 p;wrap(c);p=cursor();
 if(c==8){if(p==0x1b00)return;glyph(p,' ');p--;if(p&128)p-=0xe0;glyph(p,' ');move_cursor(p);}
 else if(c==13){do{glyph(p++,' ');}while(p&31);move_cursor(p+0xe0);}
 else if(c>=32){glyph(p,c);move_cursor(p+1);}
}
void text_resource(u16 p){u8 c;while((c=asset(p++))!=0)native_putchar(c);}
void text_string(const char *s){while(*s)native_putchar(*s++);}
void newline(void){native_putchar(13);}
void text_clear(void){text_at(0x1b00);native_video_fill(0x1b00,0x2600,255);}
void scene_clear(void){video_mode(0);native_video_fill(0xe00,0x1ae0,0);drawing[0x37]=0;}
void wait_any(void){u8 k;waiting_kind=1;do{k=hostkey();}while(!k&&!hosttrigger());waiting_kind=0;newline();newline();}
void input_line(char *b){u8 c,n=0,i;const char *word;input_sequence++;waiting_kind=2;
 for(;;){c=hostkey();if(!c)continue;
  if(!n&&(c==0x5e||c==10||c==9||c==8)){word=c==0x5e?"NORTH":c==10?"SOUTH":c==9?"EAST":"WEST";for(i=0;word[i];i++){b[n++]=word[i];native_putchar(word[i]);}c=13;}
  if(c==13){b[n]=0;newline();break;}
  if(c==8){if(n){n--;native_putchar(8);}continue;}
  if(c>=32&&c<127&&n<63){if(c>='a'&&c<='z')c-=32;b[n++]=c;native_putchar(c);}
 }
 waiting_kind=0;
}
