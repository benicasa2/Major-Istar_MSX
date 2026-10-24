/* Major Istar adventure rewritten as native game rules, not instruction translation. */
#include "game.h"
Object objects[OBJECT_COUNT];
Adventure adventure;
enum {BOX,PAPER,HELMET,CHEST,CROWBAR,CUTTERS,STONE,MUSHROOM,SEAWEED,MUTANT,BLASTER,MIRROR,POSTER,COMPUTER,CARD,GRID,MODULE,FLASHLIGHT,DOOR,REACTOR_DOOR,HATCH,NOTE,FISH,ROCK,BOULDER,PIPE,SHUTTER,LETTER,PILL,BUTTON,REACTOR,POOL,WRECKAGE};
enum {V_TAKE,V_DROP,V_GO,V_LOOK,V_READ,V_SHOOT,V_COMBINE,V_EAT,V_PUSH,V_SAVE,V_LOAD,V_OPEN,V_LIGHT,V_TURN,V_ON,V_OFF,V_INVENTORY,V_MOVE,V_HELP,V_SCORE,V_QUIT,V_REPAIR,V_USE,V_SWEAR,V_UNKNOWN};
typedef struct {char key[5];u8 action;} Verb;
#include "verbs.h"
enum {PROMPT,TURN,REDRAW,CHANGE,RESTART};
static char line[64],noun[4];
static u8 parsepos,random_seed;
static u8 savebuffer[1024];
static u16 object_name(u8 i){return pair(objects[i].name_hi,objects[i].name_lo);}
static u16 object_art(u8 i){return pair(objects[i].art_hi,objects[i].art_lo);}
static u8 place(void){return adventure.room<=22?103:adventure.room;}
static void say(u16 p){text_resource(p);}
static u8 answer(u16 p,u8 result){say(p);return result;}
static void pause_message(u16 p){say(p);say(0x4062);wait_any();}
static void number(u16 v){u16 d=10000;u8 n,seen=0;while(d){n=0;while(v>=d){v-=d;n++;}if(n||seen||d==1){native_putchar('0'+n);seen=1;}d/=10;}}
static u8 same(const char *a,const char *b){return memcmp(a,b,4)==0;}
static u8 word(char *dst){u8 n=0;char c;memset(dst,' ',4);while(line[parsepos]==' ')parsepos++;while((c=line[parsepos])!=0&&c!=' '){parsepos++;if(n<4)dst[n++]=c;}return n!=0;}
static u8 preposition(void){u16 p;for(p=0x52f6;p<0x5366;p+=4)if(noun[0]==asset(p)&&noun[1]==asset(p+1)&&noun[2]==asset(p+2)&&noun[3]==asset(p+3))return 1;return 0;}
static u8 get_noun(void){while(word(noun)){if(!preposition())return 1;}return 0;}
static u8 second_noun(void){if(get_noun())return 1;say(0x3f13);input_line(line);parsepos=0;return get_noun();}
static s8 lookup(void){u8 i;s8 distant=-1;for(i=0;i<OBJECT_COUNT;i++)if(same(noun,objects[i].key)){if(objects[i].room==0||objects[i].room==place())return i;distant=i;}return distant<0?-1:-2;}
static u8 object_error(s8 i){say(i==-2?0x42b2:0x4292);return TURN;}
static u8 lit(void){Object *f=&objects[FLASHLIGHT];return adventure.room<63||adventure.room>75||(f->on&&(f->room==0||f->room==adventure.room));}
static void game_over(u16 message){if(message)pause_message(message);scene_clear();text_at(0xe20);say(0x3e73);say(0x5b34);text_clear();draw(0x68f9);adventure.ended=1;}
static void environment(void){
 if(adventure.room>=67&&objects[HELMET].room){game_over(0x43ca);return;}
 if(adventure.room==32&&adventure.last_room==33&&objects[MIRROR].room){game_over(0x435d);return;}
 if(!lit()){if(++adventure.dark_moves>2){game_over(0x43f1);return;}}else adventure.dark_moves=0;
 if(adventure.room==66&&!adventure.pill_taken)game_over(0x441a);
}
static void battery_tick(void){Object *f=&objects[FLASHLIGHT];if(!f->on)return;if(!f->battery){f->on=0;say(0x42ed);return;}if(f->battery--<=f->warning){say(0x412b);number(f->battery+1);say(0x3f73);}}
void draw_room(void){u8 i,found=0;u16 a;
 if(adventure.redraw_only){drawing[0x37]=0;native_video_fill(0xe00,0xf20,0);}else scene_clear();
 text_at(0xe20);say(0x3e73);
 if(!lit()){say(0x5a4b);text_clear();draw(0x6a7d);}
 else{say(assetword(0x597f+(u16)adventure.room*2));text_clear();if(!adventure.redraw_only)draw(assetword(0x5cd0+(u16)adventure.room*2));}
 adventure.redraw_only=0;
 a=0x5723+(u16)(adventure.room-1)*6;
 for(i=0;i<6;i++)if(asset(a+i))glyph(0xe3a+i,asset(0x5b88+i));
 drawing[0x37]^=255;say(0x3e88);
 if(lit())for(i=0;i<OBJECT_COUNT;i++)if(objects[i].room==place()&&objects[i].key[0]!=' '){
  if(found)say(0x5b8e);found=1;say(object_name(i));a=object_art(i);if(a)draw(a);
 }
 if(!found)say(0x3ebf);else native_putchar('.');newline();
}
static void restart(void){u16 a;u8 i,j,*p;
 for(i=0;i<OBJECT_COUNT;i++){p=(u8*)&objects[i];a=0x4c7a+(u16)i*25;for(j=0;j<25;j++)p[j]=asset(a+j);}
 memset(&adventure,0,sizeof(adventure));adventure.room=1;
 setpair(&objects[COMPUTER].name_hi,0x5203);setpair(&objects[REACTOR].name_hi,0x529f);
 setpair(&objects[BOX].art_hi,0x542c);setpair(&objects[CHEST].art_hi,0x54e3);
}
static u8 move_to(u8 destination){u8 old=adventure.room,result;
 if(!destination)return answer(0x422d,TURN);
 if(old==86&&destination==87&&objects[MUTANT].key[0]!=' ')return answer(0x4766,TURN);
 adventure.room=destination;adventure.last_room=old;adventure.redraw_only=old==destination;
 if(destination==23&&old==22){result=docking();if(result==0)adventure.room=22;else if(result==2){pause_message(0x49d5);adventure.room=1;}}
 else if((destination==53&&old==44)||(destination==65&&old==64)){
  if(!security(destination==53)){if(destination==53){adventure.room=23;pause_message(0x4a88);}else{adventure.room=61;objects[FLASHLIGHT].on=0;pause_message(0x4ae2);}}
 }
 else if((old==30&&destination==31)||(old==31&&destination==30)||(old==65&&destination==66)||(old==66&&destination==65)||(old==24&&destination==76)||(old==76&&destination==24)){
  hostsound();say(0x4102);
 }
 else if(old==22&&destination==23)say(0x40de);
 return CHANGE;
}
static u8 movement(char c){u8 i;u16 a=0x5723+(u16)(adventure.room-1)*6;for(i=0;i<6;i++)if(c==asset(0x5b88+i))return move_to(asset(a+i));return answer(0x422d,TURN);}
static u8 reveal(Object *o){u8 id,letter;if(o->reveal1){id=o->reveal1;letter=o->letter1;o->reveal1=0;}else if(o->reveal2){id=o->reveal2;letter=o->letter2;o->reveal2=0;}else return 0;if(id<=OBJECT_COUNT)objects[id-1].key[0]=letter;return 1;}
static u8 require_tool(u8 id){s8 t;if(!second_noun()){say(0x4292);return 0;}t=lookup();if(t<0){object_error(t);return 0;}if(objects[t].room){say(0x4270);return 0;}if(t+1!=id){say(0x42e0);return 0;}return 1;}
static void consume(u8 i){objects[i].key[0]=' ';objects[i].room=255;adventure.items--;}
static u8 take(void){s8 id;u8 i,any=0;Object *o;
 if(adventure.items>=5)return answer(0x4242,TURN);
 if(same(noun,"ALL ")||same(noun,"EVER")){
  for(i=0;i<OBJECT_COUNT&&adventure.items<5;i++){o=&objects[i];if(o->room==place()&&o->key[0]!=' '&&o->takeable&&!o->tool&&!o->reveal1&&!o->reveal2){o->room=0;adventure.items++;any=1;}}
  return any?CHANGE:answer(0x4292,TURN);
 }
 id=lookup();if(id<0)return object_error(id);o=&objects[id];
 if(!o->room)return answer(0x42c9,TURN);
 if((o->triggers&2)&&reveal(o))say(0x3ee1);
 if(!o->takeable)return answer(id==POSTER?0x4672:0x421a,TURN);
 if(o->tool){if(!require_tool(o->tool))return TURN;o->tool=0;}
 o->room=0;adventure.items++;return CHANGE;
}
static u8 drop(void){u8 i;s8 id;if(same(noun,"ALL ")||same(noun,"EVER")){for(i=0;i<OBJECT_COUNT;i++)if(!objects[i].room)objects[i].room=place();adventure.items=0;return CHANGE;}id=lookup();if(id<0)return object_error(id);if(objects[id].room)return answer(0x4270,TURN);objects[id].room=place();adventure.items--;return CHANGE;}
static u8 inspect(u8 reading,u8 has_noun){s8 id;Object *o;
 if(!has_noun)return REDRAW;
 id=lookup();if(id<0)return id==-1?REDRAW:object_error(id);o=&objects[id];
 if(reading){if(o->takeable&&o->room)return answer(0x4270,TURN);say(pair(o->read_hi,o->read_lo));}
 else{if((o->triggers&1)&&o->open>0&&o->open<128&&reveal(o))say(0x3ee1);else say(pair(o->examine_hi,o->examine_lo));}
 return TURN;
}
static u8 open_object(void){s8 id=lookup();Object *o;
 if(id<0)return object_error(id);o=&objects[id];
 if(o->tool&&!require_tool(o->tool))return TURN;
 if(o->open<128)return answer(o->open==2?0x421a:0x429d,TURN);
 if(o->destination){o->open=1;if(id==BOX||id==CHEST){setpair(&o->art_hi,id==BOX?0x5444:0x54f5);draw(object_art(id));}if(id==SHUTTER){game_over(0x4395);return PROMPT;}return answer(0x3f07,TURN);}
 if((o->triggers&4)&&reveal(o)){o->open=1;return answer(0x3ee1,TURN);}
 o->open=1;
 if(id==BOX||id==CHEST){setpair(&o->art_hi,id==BOX?0x5444:0x54f5);draw(object_art(id));}
 if(id==SHUTTER){game_over(0x4395);return PROMPT;}
 return answer(0x3f07,TURN);
}
static u8 repair(void){s8 id=lookup(),tool;u16 name;u8 wanted;
 if(id<0)return object_error(id);
 if(objects[id].room!=adventure.room||(id!=COMPUTER&&id!=REACTOR))return answer(0x4292,TURN);
 wanted=id==COMPUTER?GRID:MODULE;name=id==COMPUTER?0x52b5:0x52c6;
 if(!second_noun())return answer(0x4292,TURN);tool=lookup();if(tool<0)return object_error(tool);
 if((u8)tool!=wanted||objects[tool].room)return answer(0x4270,TURN);
 setpair(&objects[id].name_hi,name);consume(tool);return answer(0x4662,TURN);
}
static u8 use(void){s8 id=lookup();if(id<0)return object_error(id);
 if(id!=COMPUTER||objects[id].room!=adventure.room||objects[GRID].key[0]!=' ')return answer(0x4292,TURN);
 say(0x4080);draw(0x69c3);say(0x4062);wait_any();objects[CARD].key[0]='C';return CHANGE;
}
static u8 combine(void){s8 first=lookup(),second;if(first<0)return object_error(first);
 if((first!=MUSHROOM&&first!=SEAWEED)||objects[first].room)return answer(0x4270,TURN);
 if(!second_noun())return answer(0x4292,TURN);second=lookup();if(second<0)return object_error(second);
 if(objects[second].room||!((first==MUSHROOM&&second==SEAWEED)||(first==SEAWEED&&second==MUSHROOM)))return answer(0x4270,TURN);
 consume(MUSHROOM);consume(SEAWEED);objects[PILL].key[0]='P';objects[PILL].room=0;adventure.items++;return answer(0x4692,TURN);
}
static u8 eat(void){s8 id=lookup();if(id<0)return object_error(id);if(id!=PILL)return answer(0x4313,TURN);if(objects[id].room)return answer(0x4270,TURN);consume(PILL);adventure.pill_taken=1;return answer(0x409c,TURN);}
static u8 shoot(void){s8 id=lookup();if(objects[BLASTER].room)return answer(0x4292,PROMPT);if(id<0)return answer(0x4292,PROMPT);hostsound();if(adventure.room!=87)return answer(0x3fb6,PROMPT);
 if(id==BLASTER&&objects[MUTANT].key[0]!=' '){game_over(0x3fee);return PROMPT;}
 if(id==MUTANT&&objects[id].key[0]!=' '){pause_message(0x402c);objects[id].key[0]=' ';return CHANGE;}return answer(0x3fb6,PROMPT);
}
static u8 light(u8 enabled,u8 automatic){s8 id=automatic?FLASHLIGHT:lookup();Object *f=&objects[FLASHLIGHT];if(id!=FLASHLIGHT)return answer(0x4292,TURN);if(f->room!=0&&f->room!=place())return answer(0x4292,TURN);
 if(!enabled){f->on=0;say(0x3f7c);}else{if(!f->battery)return answer(0x42ed,TURN);f->on=1;say(0x3e7a);}return adventure.room>=63&&adventure.room<=75?CHANGE:TURN;
}
static u8 ending(void){s8 id=lookup();if(id<0)return object_error(id);if(id!=BUTTON||objects[id].room!=adventure.room)return answer(0x4292,TURN);
 if(objects[MODULE].key[0]!=' '){game_over(0x4446);return PROMPT;}
 scene_clear();text_at(0xe20);say(0x3e73);say(0x5b53);drawing[0x37]^=255;draw(0x5e33);text_clear();pause_message(0x47a9);text_clear();pause_message(0x4830);text_clear();say(0x48f3);adventure.ended=1;return PROMPT;
}
static u8 checkpoint(u8 writing){u8 slot=noun[0]-'0',ok;u16 i,sum=0;u8 *p=(u8*)objects;
 if(noun[0]==' ')slot=1;if(slot<1||slot>9){text_string("Use SAVE 1 or LOAD 1.");return PROMPT;}
 if(writing){
  memset(savebuffer,0,sizeof(savebuffer));memcpy(savebuffer,"MIZ2",4);
  savebuffer[4]=adventure.room;savebuffer[5]=adventure.last_room;savebuffer[6]=adventure.items;savebuffer[7]=adventure.dark_moves;savebuffer[8]=adventure.pill_taken;
  savebuffer[9]=adventure.turns;savebuffer[10]=adventure.turns>>8;
  memcpy(savebuffer+16,p,sizeof(objects));for(i=0;i<1000;i++)sum+=savebuffer[i];savebuffer[1000]=(u8)sum;savebuffer[1001]=sum>>8;
  ok=saveslot(1,slot,savebuffer);text_string(ok?"Game saved.":"SAVE failed. ROM uses slot 1.");
 }else{
  ok=saveslot(0,slot,savebuffer);if(!ok){text_string("No saved game in this slot.");return PROMPT;}
  for(i=0;i<1000;i++)sum+=savebuffer[i];if(memcmp(savebuffer,"MIZ2",4)||sum!=pair(savebuffer[1001],savebuffer[1000])){text_string("Invalid native saved game.");return PROMPT;}
  adventure.room=savebuffer[4];adventure.last_room=savebuffer[5];adventure.items=savebuffer[6];adventure.dark_moves=savebuffer[7];adventure.pill_taken=savebuffer[8];adventure.turns=pair(savebuffer[10],savebuffer[9]);
  memcpy(p,savebuffer+16,sizeof(objects));draw_room();
 }
 return PROMPT;
}
static u8 execute(void){char verb[4];u8 i,action=V_UNKNOWN,has_noun;u16 p;s8 id;Object *o;
 parsepos=0;word(verb);for(i=0;i<sizeof(verbs)/sizeof(verbs[0]);i++)if(same(verb,verbs[i].key)){action=verbs[i].action;break;}
 has_noun=get_noun();
 switch(action){
 case V_MOVE:return movement(verb[0]);
 case V_GO:
  if(noun[0]==' '||noun[0]=='N'||noun[0]=='S'||noun[0]=='E'||noun[0]=='W'||noun[0]=='U'||noun[0]=='D'){
   if(same(noun,"N   ")||same(noun,"NORT")||same(noun,"S   ")||same(noun,"SOUT")||same(noun,"E   ")||same(noun,"EAST")||same(noun,"W   ")||same(noun,"WEST")||same(noun,"U   ")||same(noun,"UP  ")||same(noun,"D   ")||same(noun,"DOWN"))return movement(noun[0]);
  }
  id=lookup();if(id<0)return object_error(id);o=&objects[id];if(o->open>=128||!o->open)return answer(o->open>=128?0x3f35:0x3ef9,TURN);return move_to(o->destination);
 case V_TAKE:return has_noun?take():answer(0x4292,TURN);
 case V_DROP:return has_noun?drop():answer(0x4292,TURN);
 case V_LOOK:return inspect(0,has_noun);
 case V_READ:return has_noun?inspect(1,1):answer(0x4292,TURN);
 case V_OPEN:return has_noun?open_object():answer(0x4292,TURN);
 case V_REPAIR:return has_noun?repair():answer(0x4292,TURN);
 case V_USE:return has_noun?use():answer(0x4292,TURN);
 case V_COMBINE:return has_noun?combine():answer(0x4292,TURN);
 case V_EAT:return has_noun?eat():answer(0x4292,TURN);
 case V_SHOOT:return has_noun?shoot():answer(0x4292,PROMPT);
 case V_PUSH:return has_noun?ending():answer(0x4292,TURN);
 case V_ON:return light(1,1);
 case V_OFF:return light(0,1);
 case V_LIGHT:return light(verb[0]!='U',0);
 case V_TURN:i=same(noun,"OFF ")?0:same(noun,"ON  ")?1:2;if(i==2)return answer(0x4292,TURN);if(!get_noun())return answer(0x4292,TURN);return light(i,0);
 case V_INVENTORY:
  newline();say(0x3ea9);if(!adventure.items)say(0x3ebf);else for(i=0;i<OBJECT_COUNT;i++)if(!objects[i].room){say(object_name(i));newline();}return PROMPT;
 case V_HELP:
  random_seed=random_seed*17+11;i=(random_seed&3)*2;if(adventure.room==61)i=10;else if(adventure.room==33)i=8;newline();say(assetword(0x4164+i));return TURN;
 case V_SCORE:say(0x3f63);number(adventure.turns);say(0x3f73);return PROMPT;
 case V_SAVE:return checkpoint(1);
 case V_LOAD:return checkpoint(0);
 case V_QUIT:say(0x3e93);input_line(line);if(line[0]!='Y')return CHANGE;say(0x3f43);input_line(line);if(line[0]=='Y')return RESTART;adventure.ended=1;return PROMPT;
 case V_SWEAR:return answer(0x4493,TURN);
 default:p=0x4205;say(p);return PROMPT;
 }
}
void game(void){u8 i,result=PROMPT;
 hostinit();memset(drawing,0,sizeof(drawing));for(i=0;i<0x35;i++)drawing[i]=*(const u8*)(ASSET_BASE+0x6c00-0x3b26+i);
 video_mode(1);draw(0x5d9c);wait_any();native_video_fill(0xe00,0x2600,255);
 scene_clear();text_at(0xe20);say(0x3e73);say(0x5b49);draw(0x5edd);drawing[0x37]^=255;text_clear();pause_message(0x46f2);
 for(;;){
  restart();draw_room();
  while(!adventure.ended){
   say(0x3e6e);input_line(line);result=execute();
   if(result==RESTART)break;
   if(result==CHANGE)environment();
   if(adventure.ended)break;
   if(result==CHANGE||result==REDRAW)draw_room();
   if(result!=PROMPT){adventure.turns++;battery_tick();}
  }
  if(result==RESTART)continue;
  say(0x3f8b);input_line(line);if(line[0]!='Y'){for(;;)hostkey();}
 }
}
