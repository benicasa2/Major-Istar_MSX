/* Native drawing primitives. The stream encodes vector art, not CPU instructions. */
#include "game.h"
static u16 drawing_stream;
#define RESOURCE(a) (*(const u8*)(ASSET_BASE+(a)-0x3b26))
static void draw_word(u16 index,u16 value){drawing[index]=value>>8;drawing[index+1]=(u8)value;}

static u8 get(void){u16 p=drawing_stream++;return p>=0x6c00?drawing[p-0x6c00]:RESOURCE(p);}
static u16 getw(void){u16 v=(u16)get()<<8;return v|get();}
static u16 pointaddr(void){return 0xf20+((u16)drawing[0x6a]<<8)+((u16)drawing[0x6c]<<5)+(drawing[0x6b]>>2);}
static void plot(u8 color){u8 n=drawing[0x6b]&3,b;u16 a=pointaddr();b=video[a-0xe00]&RESOURCE(0x5b95+n);(drawing[0x4b]=(b));native_video_write(a,b|(color&RESOURCE(0x5b91+n)));}
static void character(u16 x,u8 ch){u8 n;u16 f=0x3b26+((u16)(u8)(ch-32)<<3);for(n=0;n<8;n++,x+=32)native_video_write(x,RESOURCE(f++)^drawing[0x37]);}
static void graphics(void){u8 op,a,b,n,x,y,dx,dy,sx,sy,minorx,minory,err,count,oldx,pat,match;u16 p,f,q,w,h,save;
 while(1){
  op=get();if(!op)break;
  switch(op){
  case 1:(drawing[0x69]=(get()));break;
  case 2:draw_word(0x6b,getw());plot(drawing[0x69]);break;
  case 3:
   a=get();b=get();(drawing[0x6d]=(a));(drawing[0x6e]=(b));x=drawing[0x6b];y=drawing[0x6c];
   dx=a-x;dy=b-y;sx=sy=1;minorx=0;minory=1;
   if(a<x){sx=255;dx=0-dx;}if(b<y){sy=255;dy=0-dy;minory=255;}
   if(dx<dy){n=dx;dx=dy;dy=n;minorx=sx;minory=0;sx=0;}
   err=dx>>1;count=1;
   for(;;){(drawing[0x6b]=(x));(drawing[0x6c]=(y));plot(drawing[0x69]);if(count>dx)break;x+=sx;y+=(sx==0?sy:0);err+=dy;count++;if(err>dx){err-=dx;x+=minorx;y+=minory;}}
   break;
  case 4:
   draw_word(0x6b,getw());a=get();b=get();for(n=0;n<4;n++)(drawing[0x73+n]=(a&RESOURCE(0x5b91+n)));(drawing[0x71]=(b<<3));
   for(y=drawing[0x6c];y<=191;y++){(drawing[0x6c]=(y));pat=RESOURCE(0x5b99+(y&7)+drawing[0x71]);(drawing[0x72]=(pat));oldx=drawing[0x6b];x=oldx;match=0;
    for(;x<128;x++){(drawing[0x6b]=(x));n=x&3;if((video[pointaddr()-0xe00]&RESOURCE(0x5b91+n))==drawing[0x73+n])break;plot(pat);match=1;}
    if(x!=oldx)for(x=oldx;x>0;){--x;(drawing[0x6b]=(x));n=x&3;if((video[pointaddr()-0xe00]&RESOURCE(0x5b91+n))==drawing[0x73+n])break;plot(pat);}
    (drawing[0x6b]=(oldx));if(!match)break;(drawing[0x6c]=(y+1));
   }
   break;
  case 5:
   x=get();y=get();(drawing[0x6b]=(x));(drawing[0x6c]=(y));p=0xf20+((u16)drawing[0x6a]<<8)+x+((u16)y<<5);w=get();h=get();pat=get()<<3;
   do{a=RESOURCE(0x5b99+(y&7)+pat);q=p;n=(u8)w;do{native_video_write(q++,a);}while(--n);p+=32;y++;}while(--h);
   (drawing[0x6c]=(y));break;
  case 6:case 8:
   if(op==6)(drawing[0x37]=(0));p=getw();
   while((a=get())!=0){if(a==255)p=getw();else character(p++,a);}
   if(op==6)(drawing[0x37]=(255));break;
  case 7:p=getw();save=drawing_stream;draw_word(0x6f,save);drawing_stream=p;graphics();drawing_stream=save;break;
  case 9:
   p=getw();f=getw();w=asset(f++);h=asset(f++);do{q=p;n=(u8)h;do{native_video_write(q,asset(f++));q+=32;}while(--n);p++;}while(--w);break;
  default:hostfatal(drawing_stream-1,op);return;
  }
 }
 
}

void draw(u16 resource){drawing_stream=resource;graphics();}
