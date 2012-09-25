#ifndef __SDL_INPUT_TRANS_H__
#define __SDL_INPUT_TRANS_H__

#include "common.h"

#define MLTAG_HAT_CENTERED  (0)
#define MLTAG_HAT_UP        (1)
#define MLTAG_HAT_RIGHT     (2)
#define MLTAG_HAT_DOWN      (3)
#define MLTAG_HAT_LEFT      (4)
#define MLTAG_HAT_RIGHTUP   (5)
#define MLTAG_HAT_RIGHTDOWN (6)
#define MLTAG_HAT_LEFTUP    (7)
#define MLTAG_HAT_LEFTDOWN  (8)

extern lookup_info ml_joyhat_trans_table[];

#endif /* __SDL_INPUT_TRANS_H__ */
