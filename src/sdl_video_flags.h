#ifndef __SDL_VIDEO_FLAGS_H__
#define __SDL_VIDEO_FLAGS_H__

#include "common.h"

#define MLTAG_SDL_SWSURFACE (0)
#define MLTAG_SDL_HWSURFACE (1)
#define MLTAG_SDL_ASYNCBLIT (2)
#define MLTAG_SDL_ANYFORMAT (3)
#define MLTAG_SDL_HWPALETTE (4)
#define MLTAG_SDL_DOUBLEBUF (5)
#define MLTAG_SDL_FULLSCREEN (6)
#define MLTAG_SDL_OPENGL (7)
#define MLTAG_SDL_OPENGLBLIT (8)
#define MLTAG_SDL_RESIZABLE (9)
#define MLTAG_SDL_HWACCEL (10)
#define MLTAG_SDL_SRCCOLORKEY (11)
#define MLTAG_SDL_RLEACCEL (12)
#define MLTAG_SDL_SRCALPHA (13)
#define MLTAG_SDL_PREALLOC (14)

extern lookup_info ml_video_flag_table[];

#endif /*__SDL_VIDEO_FLAGS_H__*/
