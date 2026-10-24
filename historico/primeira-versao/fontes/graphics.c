/* Reconstructed native implementation of 6809 routines $369B..$38C1.
 * Commands, fonts, patterns and scene data are read from the supplied game.
 */
#include "cpu.h"
static u8 get(void){return rd(cpu.u++);}
static u16 getw(void){u16 v=rw(cpu.u);cpu.u+=2;return v;}
static u16 pointaddr(void){return 0xf20+((u16)rd(0x6c6a)<<8)+((u16)rd(0x6c6c)<<5)+(rd(0x6c6b)>>2);}
static void plot(u8 color){u8 n=rd(0x6c6b)&3,b;u16 a=pointaddr();b=rd(a)&rd(0x5b95+n);wr(0x6c4b,b);wr(a,b|(color&rd(0x5b91+n)));}
static void character(u16 x,u8 ch){u8 n;u16 f=0x3b26+((u16)(u8)(ch-32)<<3);for(n=0;n<8;n++,x+=32)wr(x,rd(f++)^rd(0x6c37));}
void graphics(void){u8 op,a,b,n,x,y,dx,dy,sx,sy,minorx,minory,err,count,oldx,pat,match;u16 p,f,q,w,h,save;
 while(1){
#ifdef HOST_TEST
  extern void graphic_checkpoint(void);graphic_checkpoint();
#endif
  op=get();if(!op)break;
  switch(op){
  case 1:wr(0x6c69,get());break;
  case 2:ww(0x6c6b,getw());plot(rd(0x6c69));break;
  case 3:
   a=get();b=get();wr(0x6c6d,a);wr(0x6c6e,b);x=rd(0x6c6b);y=rd(0x6c6c);
   dx=a-x;dy=b-y;sx=sy=1;minorx=0;minory=1;
   if(a<x){sx=255;dx=0-dx;}if(b<y){sy=255;dy=0-dy;minory=255;}
   if(dx<dy){n=dx;dx=dy;dy=n;minorx=sx;minory=0;sx=0;}
   err=dx>>1;count=1;
   for(;;){wr(0x6c6b,x);wr(0x6c6c,y);plot(rd(0x6c69));if(count>dx)break;x+=sx;y+=(sx==0?sy:0);err+=dy;count++;if(err>dx){err-=dx;x+=minorx;y+=minory;}}
   break;
  case 4:
   ww(0x6c6b,getw());a=get();b=get();for(n=0;n<4;n++)wr(0x6c73+n,a&rd(0x5b91+n));wr(0x6c71,b<<3);
   for(y=rd(0x6c6c);y<=191;y++){wr(0x6c6c,y);pat=rd(0x5b99+(y&7)+rd(0x6c71));wr(0x6c72,pat);oldx=rd(0x6c6b);x=oldx;match=0;
    for(;x<128;x++){wr(0x6c6b,x);n=x&3;if((rd(pointaddr())&rd(0x5b91+n))==rd(0x6c73+n))break;plot(pat);match=1;}
    if(x!=oldx)for(x=oldx;x>0;){--x;wr(0x6c6b,x);n=x&3;if((rd(pointaddr())&rd(0x5b91+n))==rd(0x6c73+n))break;plot(pat);}
    wr(0x6c6b,oldx);if(!match)break;wr(0x6c6c,y+1);
   }
   break;
  case 5:
   x=get();y=get();wr(0x6c6b,x);wr(0x6c6c,y);p=0xf20+((u16)rd(0x6c6a)<<8)+x+((u16)y<<5);w=get();h=get();pat=get()<<3;
   do{a=rd(0x5b99+(y&7)+pat);q=p;n=(u8)w;do{wr(q++,a);}while(--n);p+=32;y++;}while(--h);
   wr(0x6c6c,y);break;
  case 6:case 8:
   if(op==6)wr(0x6c37,0);p=getw();
   while((a=get())!=0){if(a==255)p=getw();else character(p++,a);}
   if(op==6)wr(0x6c37,255);break;
  case 7:p=getw();save=cpu.u;ww(0x6c6f,save);cpu.u=p;graphics();cpu.u=save;break;
  case 9:
   p=getw();f=getw();w=rd(f++);h=rd(f++);do{q=p;n=(u8)h;do{wr(q,rd(f++));q+=32;}while(--n);p++;}while(--w);break;
  default:fatal(cpu.u-1,op);return;
  }
 }
 cpu.b=0;cpu.cc=(cpu.cc&~14)|4;
}
