/* Hand-rewritten arcade rules executed as native Z80 code. */
#include "game.h"
volatile u8 arcade_kind;
u16 arcade_player,arcade_enemy[12];
s8 arcade_velocity[12];
u8 arcade_tick,arcade_lives;
static u8 platform_x;
static s8 platform_dx;
static u8 bitmap(u16 p){return p>=0xe00&&p<0x2600?video[p-0xe00]:255;}
static void platform(void){
 native_video_write(0x1a00+platform_x,0);
 platform_x+=platform_dx;
 if(platform_x<=2||platform_x>=29){platform_dx=-platform_dx;platform_x+=platform_dx;}
 native_video_write(0x1a00+platform_x,0xaa);arcade_tick++;
}
static void arcade_message(u16 message){drawing[0x37]=255;text_clear();text_resource(message);text_resource(0x4062);wait_any();}
static void ship(u16 p,u8 erase){glyph(p,erase?' ':0x86);glyph(p+1,erase?' ':0x87);}
u8 docking(void){u8 i,d,n,collision;u16 q,p;arcade_kind=1;
 scene_clear();draw(0x5c46);drawing[0x37]=0;
 for(i=0;i<12;i++){arcade_enemy[i]=assetword(0x4b18+(u16)i*2);glyph(arcade_enemy[i],0x88);}
 arcade_player=0x1243;ship(arcade_player,0);arcade_tick=0;platform_x=15;platform_dx=1;
 arcade_message(0x497b);drawing[0x37]=0;
 for(;;){
  d=hoststick();q=arcade_player;
  if(d&8)q--;else if(d&4)q++;
  if(d&2)q-=256;else if(d&1)q+=256;
  if(d){
   n=q&31;
   if(!n||n>=29||q<0x1040){arcade_kind=0;return 0;}
   ship(arcade_player,1);collision=0;
   for(i=0;i<8;i++){p=q+(u16)i*32;collision|=bitmap(p)|bitmap(p+1);}
   if(collision){arcade_kind=0;return 2;}
   arcade_player=q;ship(q,0);
   if(q==0x1853){
    for(i=0;i<20;i++){platform();}
    arcade_message(0x40b9);arcade_kind=0;return 1;
   }
  }
  for(i=0;i<12;i++){
   q=arcade_enemy[i];
   if(!(arcade_tick&7)){glyph(q,' ');q-=256;if(q<0x1040)q+=0x800;arcade_enemy[i]=q;}
   if(q==arcade_player||q==arcade_player+1){arcade_kind=0;return 2;}
   glyph(q,0x88);
  }
  p=0x1953;for(i=0;i<2;i++,p+=32){native_video_write(p,bitmap(p)^255);native_video_write(p+1,bitmap(p+1)^255);}
  platform();
 }
}
static u8 robot_collision(void){u8 i;for(i=0;i<5;i++)if(arcade_player==arcade_enemy[i])return 1;return 0;}
static void robots(void){u8 i,col;u16 p;
 for(i=0;i<5;i++){
  p=arcade_enemy[i];glyph(p,' ');
  if(!bitmap(p+256))p+=512;
  else{
   col=(p&31)+arcade_velocity[i];
   if(!col||col>=31){
    if((p>>8)==0x17)p=col==0?0x0f9d:0x0f81;
    else arcade_velocity[i]=-arcade_velocity[i];
   }else p+=arcade_velocity[i];
  }
  arcade_enemy[i]=p;glyph(p,0x84);
 }
}
u8 security(u8 from_above){u8 i,d,col,killed,won;u16 q;
 arcade_kind=2;arcade_lives=3;
 while(arcade_lives){
  scene_clear();draw(0x5c8c);drawing[0x37]=0;glyph(0xe3a,0x85);glyph(0xe3c,'0'+arcade_lives);
  for(i=0;i<5;i++){
   arcade_enemy[i]=assetword(0x4b06+(u16)i*3);
   arcade_velocity[i]=(i&1)?-1:1;if(!from_above)arcade_velocity[i]=-arcade_velocity[i];
   glyph(arcade_enemy[i],asset(0x4b08+(u16)i*3));
  }
  arcade_player=0x178f;glyph(arcade_player,0x85);arcade_tick=0;platform_x=15;platform_dx=1;
  arcade_message(0x4a10);drawing[0x37]=0;
  for(;;){
   robots();killed=robot_collision();d=hoststick();q=arcade_player;won=0;
   if(d){
    glyph(q,' ');
    if((d&2)&&!bitmap(q-32)){q-=512;if(q<=0x1080)won=1;}
    else if((d&1)&&!bitmap(q+256))q+=512;
    else{if(d&4)q++;else q--;col=q&31;if(!col||col==31)q=arcade_player;}
    arcade_player=q;glyph(q,0x85);killed|=robot_collision();
   }
   platform();
   if(won){arcade_message(0x4acd);arcade_kind=0;return 1;}
   if(killed)break;
  }
  arcade_lives--;
  if(arcade_lives)arcade_message(0x4a62);
 }
 arcade_kind=0;return 0;
}
