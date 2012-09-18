#include "sdl_video_flags.h"

#include <SDL_video.h>

lookup_info ml_video_flag_table[] = {
  {0, 15}
  ,{Val_int(MLTAG_SDL_SWSURFACE),SDL_SWSURFACE}
  ,{Val_int(MLTAG_SDL_HWSURFACE),SDL_HWSURFACE}
  ,{Val_int(MLTAG_SDL_ASYNCBLIT),SDL_ASYNCBLIT}
  ,{Val_int(MLTAG_SDL_ANYFORMAT),SDL_ANYFORMAT}
  ,{Val_int(MLTAG_SDL_HWPALETTE),SDL_HWPALETTE}
  ,{Val_int(MLTAG_SDL_DOUBLEBUF),SDL_DOUBLEBUF}
  ,{Val_int(MLTAG_SDL_FULLSCREEN),SDL_FULLSCREEN}
  ,{Val_int(MLTAG_SDL_OPENGL),SDL_OPENGL}
  ,{Val_int(MLTAG_SDL_OPENGLBLIT),SDL_OPENGLBLIT}
  ,{Val_int(MLTAG_SDL_RESIZABLE),SDL_RESIZABLE}
  ,{Val_int(MLTAG_SDL_HWACCEL),SDL_HWACCEL}
  ,{Val_int(MLTAG_SDL_SRCCOLORKEY),SDL_SRCCOLORKEY}
  ,{Val_int(MLTAG_SDL_RLEACCEL),SDL_RLEACCEL}
  ,{Val_int(MLTAG_SDL_SRCALPHA),SDL_SRCALPHA}
  ,{Val_int(MLTAG_SDL_PREALLOC),SDL_PREALLOC}
};
