#include "sdl_initflags.h"

#include <SDL.h>

lookup_info ml_init_flag_table[] = {
{0, 8},
{Val_int(MLTAG_TIMER), SDL_INIT_TIMER},
{Val_int(MLTAG_VIDEO), SDL_INIT_VIDEO},
{Val_int(MLTAG_AUDIO), SDL_INIT_AUDIO},
{Val_int(MLTAG_CDROM), SDL_INIT_CDROM},
{Val_int(MLTAG_JOYSTICK), SDL_INIT_JOYSTICK},
{Val_int(MLTAG_EVENTTHREAD), SDL_INIT_EVENTTHREAD},
{Val_int(MLTAG_NOPARACHUTE), SDL_INIT_NOPARACHUTE},
{Val_int(MLTAG_EVERYTHING), SDL_INIT_EVERYTHING}
};
