/* Panasonic expanded-I/O protocol: manufacturer 8, capability bit 2 active
 * low, speed bit 0 active low. The other control bits and the selected
 * expanded-I/O device are preserved. No R800 or generic overclock is used.
 */
#include "turbo.h"
__sfr __at(0x40) expanded_id;
__sfr __at(0x41) panasonic_control;
__sfr __at(0xaa) keyboard_row;
__sfr __at(0xa9) keyboard_matrix;
volatile u8 turbo_available,turbo_active,turbo_initial,turbo_bypassed;
static u8 select_panasonic(u8 *previous,u8 *control){
 *previous=~expanded_id;
 expanded_id=8;
 if(expanded_id!=0xf7){expanded_id=*previous;return 0;}
 *control=panasonic_control;
 if(*control&4){expanded_id=*previous;return 0;}
 return 1;
}
void panasonic_turbo_set(u8 enabled){u8 previous,control;
 if(!select_panasonic(&previous,&control)){turbo_available=0;turbo_active=0;return;}
 turbo_available=1;
 panasonic_control=enabled?(control&0xfe):(control|1);
 turbo_active=(panasonic_control&1)==0;
 expanded_id=previous;
}
void panasonic_turbo_init(void){u8 previous,control,row,shift;
 turbo_available=turbo_active=turbo_initial=turbo_bypassed=0;
 row=keyboard_row;keyboard_row=(row&0xf0)|6;shift=(keyboard_matrix&1)==0;keyboard_row=row;
 if(!select_panasonic(&previous,&control))return;
 turbo_available=1;turbo_initial=(control&1)==0;turbo_active=turbo_initial;expanded_id=previous;
 if(shift){turbo_bypassed=1;panasonic_turbo_set(0);}
 else panasonic_turbo_set(1);
}
void panasonic_turbo_restore(void){if(turbo_available)panasonic_turbo_set(turbo_initial);}
