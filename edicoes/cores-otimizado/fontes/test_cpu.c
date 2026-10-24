#include "cpu.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static u8 memory[65536];
u8 rd(u16 p){return memory[p];}void wr(u16 p,u8 v){memory[p]=v;}
void fatal(u16 p,u8 o){fprintf(stderr,"Unsupported test instruction %04x %02x\n",p,o);exit(1);}
static void program(const u8 *p,unsigned n){memset(&cpu,0,sizeof(cpu));memset(memory,0,sizeof(memory));memcpy(memory+0x2000,p,n);cpu.pc=0x2000;cpu.s=0xdfe;stopped=0;}
int main(void){
 const u8 math[]={0x86,0x7f,0x8b,1,0x86,0,0x1a,1,0x82,0};
 const u8 addressing[]={0xcc,0x12,0x34,0xfd,0x30,0,0x8e,0x30,0,0xa6,0x80,0xe6,0x84,0x10,0x8e,0x45,0x67};
 const u8 pcr[]={0xa6,0x8c,1,0x12,0x5a};
 const u8 stack[]={0x34,0x76,0x35,0x76};
 program(math,sizeof(math));step();step();assert(cpu.a==128&&(cpu.cc&15)==10);step();step();step();assert(cpu.a==255&&(cpu.cc&1));
 program(addressing,sizeof(addressing));step();step();assert(rw(0x3000)==0x1234);step();step();step();step();assert(cpu.a==0x12&&cpu.b==0x34&&cpu.x==0x3001&&cpu.y==0x4567);
 program(pcr,sizeof(pcr));step();assert(cpu.a==0x5a&&cpu.pc==0x2003);
 program(stack,sizeof(stack));cpu.a=0x12;cpu.b=0x34;cpu.x=0x4567;cpu.y=0x89ab;cpu.u=0xcdef;step();assert(cpu.s==0xdf6);cpu.a=cpu.b=0;cpu.x=cpu.y=cpu.u=0;step();assert(cpu.s==0xdfe&&cpu.a==0x12&&cpu.b==0x34&&cpu.x==0x4567&&cpu.y==0x89ab&&cpu.u==0xcdef);
 puts("6809 core: arithmetic flags, big endian access, indexed/PCR addressing and stack passed.");return 0;
}
