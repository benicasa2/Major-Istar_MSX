/* Compact 6809 execution core for the Major Istar platform adaptation.
 * Written for this project. Registers and memory remain in 6809 byte order.
 * Interrupts, SYNC/CWAI and SWI are intentionally unsupported: the game's
 * hardware and ROM services are handled explicitly by platform.c.
 */
#include "cpu.h"
Cpu cpu;
u8 stopped;
#define C 1
#define V 2
#define Z 4
#define N 8
#define H 32
static u8 fetch(void){return rd(cpu.pc++);}
static u16 fetch16(void){u16 v=(u16)fetch()<<8;return v|fetch();}
u16 rw(u16 p){u16 v=(u16)rd(p)<<8;return v|rd(p+1);}
void ww(u16 p,u16 v){wr(p,(u8)(v>>8));wr(p+1,(u8)v);}
static u16 dreg(void){return ((u16)cpu.a<<8)|cpu.b;}
static void setd(u16 v){cpu.a=(u8)(v>>8);cpu.b=(u8)v;}
static void nz8(u8 v){cpu.cc=(cpu.cc&~(N|Z))|(v?0:Z)|(v&0x80?N:0);}
static void nz16(u16 v){cpu.cc=(cpu.cc&~(N|Z))|(v?0:Z)|(v&0x8000?N:0);}
static u8 load8(u8 v){cpu.cc&=~V;nz8(v);return v;}
static u16 load16(u16 v){cpu.cc&=~V;nz16(v);return v;}
static u8 add8(u8 a,u8 b,u8 carry){u16 r=(u16)a+b+carry;u8 t=(u8)r;cpu.cc=(cpu.cc&~(H|N|Z|V|C))|((r&256)?C:0)|((~(a^b)&(a^t)&128)?V:0)|(((a^b^t)&16)?H:0);nz8(t);return t;}
static u8 sub8(u8 a,u8 b,u8 carry){u16 r=(u16)a-b-carry;u8 t=(u8)r;cpu.cc=(cpu.cc&~(N|Z|V|C))|((r&256)?C:0)|(((a^b)&(a^t)&128)?V:0);nz8(t);return t;}
static u16 add16(u16 a,u16 b){u16 r=a+b;cpu.cc=(cpu.cc&~(N|Z|V|C))|((r<a)?C:0)|((~(a^b)&(a^r)&0x8000)?V:0);nz16(r);return r;}
static u16 sub16(u16 a,u16 b){u16 r=a-b;cpu.cc=(cpu.cc&~(N|Z|V|C))|((a<b)?C:0)|(((a^b)&(a^r)&0x8000)?V:0);nz16(r);return r;}
void push16(u16 *sp,u16 v){wr(--*sp,(u8)v);wr(--*sp,(u8)(v>>8));}
u16 pop16(u16 *sp){u16 v=rw(*sp);*sp+=2;return v;}
void ret(void){cpu.pc=pop16(&cpu.s);}
static u16 regget(u8 n){switch(n){case 0:return dreg();case 1:return cpu.x;case 2:return cpu.y;case 3:return cpu.u;case 4:return cpu.s;case 5:return cpu.pc;case 8:return 0xff00|cpu.a;case 9:return 0xff00|cpu.b;case 10:return 0xff00|cpu.cc;case 11:return 0xff00|cpu.dp;}return 0xffff;}
static void regset(u8 n,u16 v){switch(n){case 0:setd(v);break;case 1:cpu.x=v;break;case 2:cpu.y=v;break;case 3:cpu.u=v;break;case 4:cpu.s=v;break;case 5:cpu.pc=v;break;case 8:cpu.a=(u8)v;break;case 9:cpu.b=(u8)v;break;case 10:cpu.cc=(u8)v;break;case 11:cpu.dp=(u8)v;break;}}
static u16 indexed(void){u8 b=fetch(),n=b&15;u16 *r,p;switch((b>>5)&3){case 0:r=&cpu.x;break;case 1:r=&cpu.y;break;case 2:r=&cpu.u;break;default:r=&cpu.s;}
 if(!(b&128))return *r+(s16)((b&16)?(b&31)-32:b&31);
 p=*r;
 switch(n){case 0:*r+=1;break;case 1:*r+=2;break;case 2:p=--*r;break;case 3:*r-=2;p=*r;break;case 4:break;case 5:p+=(s8)cpu.b;break;case 6:p+=(s8)cpu.a;break;case 8:p+=(s8)fetch();break;case 9:p+=fetch16();break;case 11:p+=dreg();break;case 12:{s8 v=(s8)fetch();p=cpu.pc+v;break;}case 13:{u16 v=fetch16();p=cpu.pc+v;break;}case 15:p=fetch16();break;default:fatal(cpu.pc-1,b);}
 return (b&16)?rw(p):p;
}
static u16 ea(u8 op){switch((op>>4)&3){case 1:return ((u16)cpu.dp<<8)|fetch();case 2:return indexed();default:return fetch16();}}
static u8 cond(u8 op){u8 n=(cpu.cc&N)!=0,v=(cpu.cc&V)!=0;switch(op&15){case 0:return 1;case 1:return 0;case 2:return !(cpu.cc&(C|Z));case 3:return (cpu.cc&(C|Z))!=0;case 4:return !(cpu.cc&C);case 5:return cpu.cc&C;case 6:return !(cpu.cc&Z);case 7:return cpu.cc&Z;case 8:return !(cpu.cc&V);case 9:return cpu.cc&V;case 10:return !n;case 11:return n;case 12:return n==v;case 13:return n!=v;case 14:return n==v&&!(cpu.cc&Z);default:return n!=v||(cpu.cc&Z);}}
static u8 unary(u8 op,u8 a){u8 r=a,c;
 switch(op&15){case 0:return sub8(0,a,0);case 3:cpu.cc=(cpu.cc&~V)|C;r=~a;break;
 case 4:cpu.cc=(cpu.cc&~(C|N|Z))|(a&1);r=a>>1;nz8(r);return r;
 case 6:c=cpu.cc&C;cpu.cc=(cpu.cc&~C)|(a&1);r=(a>>1)|(c<<7);break;
 case 7:cpu.cc=(cpu.cc&~C)|(a&1);r=(a>>1)|(a&128);break;
 case 8:return add8(a,a,0);case 9:c=cpu.cc&C;r=add8(a,a,c);return r;
 case 10:r=a-1;cpu.cc=(cpu.cc&~V)|(a==128?V:0);break;
 case 12:r=a+1;cpu.cc=(cpu.cc&~V)|(a==127?V:0);break;
 case 13:cpu.cc&=~V;nz8(a);return a;
 case 15:cpu.cc=(cpu.cc&~(N|V|C))|Z;return 0;
 default:fatal(cpu.pc-1,op);}
 nz8(r);return r;
}
static void stackop(u8 op){u8 m=fetch();u16 *s=(op&2)?&cpu.u:&cpu.s;u16 *other=(op&2)?&cpu.s:&cpu.u;
 if(!(op&1)){if(m&128)push16(s,cpu.pc);if(m&64)push16(s,*other);if(m&32)push16(s,cpu.y);if(m&16)push16(s,cpu.x);if(m&8)wr(--*s,cpu.dp);if(m&4)wr(--*s,cpu.b);if(m&2)wr(--*s,cpu.a);if(m&1)wr(--*s,cpu.cc);}
 else {if(m&1)cpu.cc=rd((*s)++);if(m&2)cpu.a=rd((*s)++);if(m&4)cpu.b=rd((*s)++);if(m&8)cpu.dp=rd((*s)++);if(m&16)cpu.x=pop16(s);if(m&32)cpu.y=pop16(s);if(m&64)*other=pop16(s);if(m&128)cpu.pc=pop16(s);}
}
void step(void){u8 op=fetch(),page=0,lo,b,m,carry;u16 p=0,v,w,*r;u8 *ar;
 if(op==0x10||op==0x11){page=op;op=fetch();}
 if(op>=0x20&&op<=0x2f){v=page?fetch16():(u16)(s16)(s8)fetch();if(cond(op))cpu.pc+=v;return;}
 if(op>=0x80){lo=op&15;m=op>>4;ar=(op&0x40)?&cpu.b:&cpu.a;
  if(lo==13&&m<12){if(m==8){v=(u16)(s16)(s8)fetch();push16(&cpu.s,cpu.pc);cpu.pc+=v;}else{p=ea(op);push16(&cpu.s,cpu.pc);cpu.pc=p;}return;}
  if((lo==3)||(lo==12&&m<12)||(lo>=14)||(lo==12&&m>=12)||(lo==13&&m>=12)){
   if(lo>=14)r=page?((m<12)?&cpu.y:&cpu.s):((m<12)?&cpu.x:&cpu.u);else r=0;
   if((m&3)==0)v=fetch16();else {p=ea(op);v=rw(p);}
   if(lo==3){if(page==0x10)sub16(dreg(),v);else if(page==0x11)sub16(cpu.u,v);else if(m<12)setd(sub16(dreg(),v));else setd(add16(dreg(),v));}
   else if(lo==12&&m<12){sub16(page==0x10?cpu.y:page==0x11?cpu.s:cpu.x,v);}
   else if(lo==12)setd(load16(v));
   else if(lo==13)ww(p,load16(dreg()));
   else if(lo==14)*r=load16(v);else ww(p,load16(*r));
   return;
  }
  if((m&3)==0)b=fetch();else{p=ea(op);b=rd(p);}
  carry=(cpu.cc&C)!=0;
  switch(lo){case 0:*ar=sub8(*ar,b,0);break;case 1:sub8(*ar,b,0);break;case 2:*ar=sub8(*ar,b,carry);break;case 4:*ar=load8(*ar&b);break;case 5:load8(*ar&b);break;case 6:*ar=load8(b);break;case 7:wr(p,load8(*ar));break;case 8:*ar=load8(*ar^b);break;case 9:*ar=add8(*ar,b,carry);break;case 10:*ar=load8(*ar|b);break;case 11:*ar=add8(*ar,b,0);break;default:fatal(cpu.pc-1,op);}
  return;
 }
 if(op<0x10||(op>=0x40&&op<=0x7f)){
  if(op<16)p=((u16)cpu.dp<<8)|fetch();else if(op<0x60){ar=op&16?&cpu.b:&cpu.a;*ar=unary(op,*ar);return;}else p=(op<0x70)?indexed():fetch16();
  if((op&15)==14){cpu.pc=p;return;}
  b=unary(op,rd(p));if((op&15)!=13)wr(p,b);return;
 }
 switch(op){case 0x12:break;case 0x16:v=fetch16();cpu.pc+=v;break;case 0x17:v=fetch16();push16(&cpu.s,cpu.pc);cpu.pc+=v;break;
 case 0x19:{u8 a=cpu.a,c=cpu.cc&C;b=0;if((a&15)>9||(cpu.cc&H))b=6;if(a>0x99||c||((a&0xf0)>0x80&&(a&15)>9))b|=0x60;cpu.a=add8(a,b,0);cpu.cc|=c;break;}
 case 0x1a:cpu.cc|=fetch();break;case 0x1c:cpu.cc&=fetch();break;case 0x1d:cpu.a=cpu.b&128?255:0;nz16(dreg());break;
 case 0x1e:case 0x1f:b=fetch();v=regget(b>>4);w=regget(b&15);regset(b&15,v);if(op==0x1e)regset(b>>4,w);break;
 case 0x30:cpu.x=indexed();cpu.cc=(cpu.cc&~Z)|(cpu.x?0:Z);break;case 0x31:cpu.y=indexed();cpu.cc=(cpu.cc&~Z)|(cpu.y?0:Z);break;case 0x32:cpu.s=indexed();break;case 0x33:cpu.u=indexed();break;
 case 0x34:case 0x35:case 0x36:case 0x37:stackop(op);break;
 case 0x39:ret();break;case 0x3a:cpu.x+=cpu.b;break;case 0x3d:v=(u16)cpu.a*cpu.b;setd(v);cpu.cc=(cpu.cc&~(Z|C))|(v?0:Z)|(v&128?C:0);break;
 default:fatal(cpu.pc-1,op);
 }
}
