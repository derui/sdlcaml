#include <caml/mlvalues.h>
#include <SDL.h>

#include "common.h"
#include "sdl_input_trans.h"

lookup_info ml_joyhat_trans_table[] = {
{0, 9},
{Val_int(MLTAG_HAT_CENTERED)  , SDL_HAT_CENTERED},
{Val_int(MLTAG_HAT_UP)        , SDL_HAT_UP},
{Val_int(MLTAG_HAT_RIGHT)     , SDL_HAT_RIGHT},
{Val_int(MLTAG_HAT_DOWN)      , SDL_HAT_DOWN},
{Val_int(MLTAG_HAT_LEFT)      , SDL_HAT_LEFT},
{Val_int(MLTAG_HAT_RIGHTUP)   , SDL_HAT_RIGHTUP},
{Val_int(MLTAG_HAT_RIGHTDOWN) , SDL_HAT_RIGHTDOWN},
{Val_int(MLTAG_HAT_LEFTUP)    , SDL_HAT_LEFTUP},
{Val_int(MLTAG_HAT_LEFTDOWN)  , SDL_HAT_LEFTDOWN}
};
