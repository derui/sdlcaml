#ifndef __SDL_TTF_FLAGS_H__
#define __SDL_TTF_FLAGS_H__

#include "common.h"

#define MLTAG_TTF_STYLE_NORMAL        (0)
#define MLTAG_TTF_STYLE_BOLD          (1)
#define MLTAG_TTF_STYLE_ITALIC        (2)
#define MLTAG_TTF_STYLE_UNDERLINE     (3)
#define MLTAG_TTF_STYLE_STRIKETHROUGH (4)

#define MLTAG_TTF_HINTING_NORMAL (0)
#define MLTAG_TTF_HINTING_LIGHT  (1)
#define MLTAG_TTF_HINTING_MONO   (2)
#define MLTAG_TTF_HINTING_NONE   (3)

extern lookup_info ml_ttf_flag_table[];
extern lookup_info ml_ttf_hinting_table[];

#endif /*__SDL_TTF_FLAGS_H__*/
