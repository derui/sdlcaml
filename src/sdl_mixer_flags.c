#include "sdl_mixer_flags.h"

#include <SDL_mixer.h>

lookup_info ml_mixer_flag_table[] = {
{0, 7},
{MLTAG_All, -1},
{MLTAG_Channel, 0},
{MLTAG_Unreserved, -1},
{MLTAG_FLAC, MIX_INIT_FLAC},
{MLTAG_MOD, MIX_INIT_MOD},
{MLTAG_MP3, MIX_INIT_MP3},
{MLTAG_OGG, MIX_INIT_OGG}
};
