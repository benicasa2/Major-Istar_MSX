/* Host unit tests of native adventure rules; no processor emulation. */
#include <stdio.h>
#include <assert.h>
#include "adventure.c"
static u8 resources[0x6c35-0x3b26],slotbytes[1024],slotvalid;
u8 video[6144],drawing[128];
volatile u8 waiting_kind,arcade_kind;
volatile u16 input_sequence;
u16 arcade_player,arcade_enemy[12];s8 arcade_velocity[12];u8 arcade_tick,arcade_lives;
u8 asset(u16 a){return a>=0x3b26&&a<0x6c35?resources[a-0x3b26]:0;}
u16 pair(u8 hi,u8 lo){return ((u16)hi<<8)|lo;}
u16 assetword(u16 a){return pair(asset(a),asset(a+1));}
void setpair(u8 *hi,u16 v){hi[0]=v>>8;hi[1]=v;}
void draw(u16 a){(void)a;}
void glyph(u16 p,u8 ch){(void)p;(void)ch;}
void native_video_write(u16 a,u8 v){(void)a;(void)v;}
void native_video_fill(u16 a,u16 b,u8 v){(void)a;(void)b;(void)v;}
void native_video_scroll(void){}
void native_putchar(u8 c){(void)c;}
void text_at(u16 a){(void)a;}
void text_clear(void){}
void text_resource(u16 a){(void)a;}
void text_string(const char*s){(void)s;}
void newline(void){}
void scene_clear(void){}
void wait_any(void){}
void input_line(char*b){b[0]=0;}
u8 hostkey(void){return ' ';}
u8 hoststick(void){return 0;}
u8 hosttrigger(void){return 0;}
void hostsound(void){}
void hostinit(void){}
void hostfatal(u16 p,u8 e){(void)p;(void)e;assert(0);}
void host_ready(void){}
void flush(void){}
void video_changed(u16 a,u16 b){(void)a;(void)b;}
void video_mode(u8 a){(void)a;}
u8 saveslot(u8 w,u8 s,u8*b){if(s!=1)return 0;if(w){memcpy(slotbytes,b,1024);slotvalid=1;}else if(slotvalid)memcpy(b,slotbytes,1024);return slotvalid;}
u8 docking(void){return 1;}
u8 security(u8 a){(void)a;return 1;}
static u8 command(const char*s){strcpy(line,s);return execute();}
int main(int argc,char**argv){FILE*f;assert(argc==2);f=fopen(argv[1],"rb");assert(f);assert(fread(resources,1,sizeof(resources),f)==sizeof(resources));fclose(f);assert(sizeof(Object)==25);
 restart();assert(adventure.room==1&&adventure.items==0&&adventure.turns==0);
 assert(command("DOWN")==CHANGE&&adventure.room==4);
 restart();adventure.room=29;assert(command("GET GRID")==CHANGE&&objects[GRID].room==0&&adventure.items==1);
 adventure.room=40;assert(command("FIX COMPUTER WITH GRID")==TURN);assert(object_name(COMPUTER)==0x52b5&&objects[GRID].key[0]==' '&&objects[GRID].room==255&&adventure.items==0);
 assert(command("USE COMPUTER")==CHANGE&&objects[CARD].key[0]=='C');assert(command("GET CARD")==CHANGE&&objects[CARD].room==0);
 restart();adventure.room=31;assert(command("OPEN BOX WITH CROWBAR")==TURN&&objects[BOX].open==255);
 objects[CROWBAR].room=0;objects[CROWBAR].key[0]='C';adventure.items=1;assert(command("OPEN BOX WITH CROWBAR")==TURN&&objects[BOX].open==1);
 assert(command("LOOK BOX")==TURN&&objects[PAPER].key[0]=='P');assert(command("LOOK BOX")==TURN&&objects[HELMET].key[0]=='H');assert(command("GET HELMET")==CHANGE&&objects[HELMET].room==0);
 restart();adventure.room=88;assert(command("CUT SEAWEED WITH CUTTERS")==TURN&&objects[SEAWEED].room==88);
 objects[CUTTERS].room=0;objects[CUTTERS].key[0]='C';adventure.items=1;assert(command("CUT SEAWEED WITH CUTTERS")==CHANGE&&objects[SEAWEED].room==0&&objects[SEAWEED].tool==0);
 objects[MUSHROOM].room=0;adventure.items++;assert(command("COMBINE MUSHROOM WITH SEAWEED")==TURN&&objects[PILL].key[0]=='P'&&objects[PILL].room==0&&adventure.items==2);
 assert(command("EAT PILL")==TURN&&adventure.pill_taken&&adventure.items==1);
 restart();adventure.room=92;adventure.items=5;assert(command("GET STONE")==TURN&&objects[STONE].room==92);
 restart();adventure.room=54;assert(command("GET FLASHLIGHT")==CHANGE);assert(command("ON")==TURN&&objects[FLASHLIGHT].on);battery_tick();assert(objects[FLASHLIGHT].battery==78);
 adventure.room=63;objects[FLASHLIGHT].room=0;assert(lit());objects[FLASHLIGHT].on=0;assert(!lit());environment();environment();assert(!adventure.ended);environment();assert(adventure.ended);
 restart();adventure.room=66;environment();assert(adventure.ended);restart();adventure.room=66;adventure.pill_taken=1;environment();assert(!adventure.ended);
 restart();adventure.turns=123;assert(command("SAVE 1")==PROMPT);adventure.room=4;adventure.turns=124;assert(command("LOAD 1")==PROMPT&&adventure.room==1&&adventure.turns==123);
 slotbytes[25]^=1;adventure.room=4;assert(command("LOAD 1")==PROMPT&&adventure.room==4);
 restart();adventure.room=40;assert(command("PUSH BUTTON")==PROMPT&&adventure.ended);
 restart();adventure.room=40;objects[MODULE].key[0]=' ';assert(command("PUSH BUTTON")==PROMPT&&adventure.ended);
 restart();assert(objects[MODULE].key[0]=='M'&&objects[GRID].key[0]=='G'&&objects[BOX].open==255&&adventure.room==1);
 puts("Native rules passed: movement, repair, tools, containers, inventory, pill, capacity, light, hazards, saves, checksum, ending and restart.");return 0;
}
