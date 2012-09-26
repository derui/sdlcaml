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
#define MLTAG_EXPOSE      (12)
#define MLTAG_QUIT        (13)
#define MLTAG_USER        (14)
#define MLTAG_SYSWM       (15)

extern lookup_info ml_event_tag_table[];

#endif /* __SDL_EVENT_TAGS_H__ */
