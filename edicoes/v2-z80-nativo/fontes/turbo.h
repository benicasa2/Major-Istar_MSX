#ifndef MISTAR_TURBO_H
#define MISTAR_TURBO_H
#include "game.h"
extern volatile u8 turbo_available,turbo_active,turbo_initial,turbo_bypassed;
void panasonic_turbo_init(void);
void panasonic_turbo_set(u8 enabled);
void panasonic_turbo_restore(void);
#endif

