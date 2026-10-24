#ifndef MISTAR_CPU_H
#define MISTAR_CPU_H
#include <stdint.h>
typedef uint8_t u8;
typedef uint16_t u16;
typedef int8_t s8;
typedef int16_t s16;
typedef struct {u16 x,y,u,s,pc;u8 a,b,dp,cc;} Cpu;
extern Cpu cpu;
extern u8 stopped;
u8 rd(u16 address);
void wr(u16 address,u8 value);
u16 rw(u16 address);
void ww(u16 address,u16 value);
void step(void);
void ret(void);
void push16(u16 *stack,u16 value);
u16 pop16(u16 *stack);
void fatal(u16 address,u8 opcode);
#endif
