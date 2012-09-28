#ifndef __SDL_EVENT_TAGS_H__
#define __SDL_EVENT_TAGS_H__

#include "common.h"

#define MLTAG_ACTIVE      ( 0)
#define MLTAG_KEYDOWN     ( 1)
#define MLTAG_KEYUP       ( 2)
#define MLTAG_MOTION      ( 3)
#define MLTAG_BUTTONDOWN  ( 4)
#define MLTAG_BUTTONUP    ( 5)
#define MLTAG_JAXIS       ( 6)
#define MLTAG_JBALL       ( 7)
#define MLTAG_JHAT        ( 8)
#define MLTAG_JBUTTONDOWN ( 9)
#define MLTAG_JBUTTONUP   (10)
#define MLTAG_RESIZE      (11)
#define MLTAG_EXPOSE      ( 0)
#define MLTAG_QUIT        ( 1)
#define MLTAG_USER        (12)
#define MLTAG_SYSWM       (13)

/* record index of event structure in OCaml.
   this only provide user with record index, so these
   doesn't have prefix MLTAG_.
 */
#define EVENT_STRUCT_GAIN             ( 0)
#define EVENT_STRUCT_APP_STATE        ( 1)
#define EVENT_STRUCT_KEYSYM           ( 2)
#define EVENT_STRUCT_X                ( 3)
#define EVENT_STRUCT_Y                ( 4)
#define EVENT_STRUCT_RELX             ( 5)
#define EVENT_STRUCT_RELY             ( 6)
#define EVENT_STRUCT_BUTTON_STATE     ( 7)
#define EVENT_STRUCT_INDEX            ( 8)
#define EVENT_STRUCT_AXIS             ( 9)
#define EVENT_STRUCT_VALUE            (10)
#define EVENT_STRUCT_BALL             (11)
#define EVENT_STRUCT_HAT              (12)
#define EVENT_STRUCT_HAT_STATE        (13)
#define EVENT_STRUCT_BUTTON           (14)
#define EVENT_STRUCT_WIDTH            (15)
#define EVENT_STRUCT_HEIGHT           (16)

extern lookup_info ml_event_tag_table[];

#endif /* __SDL_EVENT_TAGS_H__ */
