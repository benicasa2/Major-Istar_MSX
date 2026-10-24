#ifndef MAJOR_ISTAR_NATIVE_H
#define MAJOR_ISTAR_NATIVE_H
#include <stdint.h>
#include <string.h>
typedef uint8_t u8;
typedef int8_t s8;
typedef uint16_t u16;
#define ASSET_BASE 0x8c00
#define OBJECT_COUNT 33
#ifdef __SDCC
#define PACKED
#else
#define PACKED __attribute__((packed))
#endif
typedef struct PACKED {
 char key[4];u8 name_hi,name_lo,room,examine_hi,examine_lo;
 u8 reveal1,letter1,reveal2,letter2,read_hi,read_lo;
 u8 tool,on,battery,warning,destination,open,takeable,triggers,art_hi,art_lo;
} Object;
typedef struct {u8 room,last_room,items,dark_moves,pill_taken,redraw_only,ended;u16 turns;} Adventure;
extern Object objects[OBJECT_COUNT];
extern Adventure adventure;
extern u8 video[6144],drawing[128];
extern volatile u8 waiting_kind,arcade_kind;
extern volatile u16 input_sequence;
extern u16 arcade_player,arcade_enemy[12];
extern s8 arcade_velocity[12];
extern u8 arcade_tick,arcade_lives;
u8 asset(u16 address);
u16 assetword(u16 address);
u16 pair(u8 hi,u8 lo);
void setpair(u8 *hi,u16 value);
void draw(u16 resource);
void glyph(u16 position,u8 ch);
void native_video_write(u16 address,u8 value);
void native_video_fill(u16 first,u16 last,u8 value);
void native_video_scroll(void);
void native_putchar(u8 ch);
void text_at(u16 position);
void text_clear(void);
void text_resource(u16 address);
void text_string(const char *s);
void newline(void);
void scene_clear(void);
void wait_any(void);
void input_line(char *buffer);
u8 hostkey(void);
u8 hoststick(void);
u8 hosttrigger(void);
void hostsound(void);
void hostinit(void);
void hostfatal(u16 address,u8 error);
void host_ready(void);
void flush(void);
void video_changed(u16 offset,u16 length);
void video_mode(u8 full_screen);
u8 saveslot(u8 writing,u8 slot,u8 *buffer);
void game(void);
u8 docking(void);
u8 security(u8 from_above);
void draw_room(void);
#endif
