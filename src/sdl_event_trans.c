#include <caml/mlvalues.h>
#include <SDL.h>

#include "sdl_event_trans.h"

lookup_info ml_event_tag_table[] = {
  {0, 16},
  {Val_int(MLTAG_ACTIVE)      , SDL_ACTIVEEVENT},
  {Val_int(MLTAG_KEYDOWN)     , SDL_KEYDOWN},
  {Val_int(MLTAG_KEYUP)       , SDL_KEYUP},
  {Val_int(MLTAG_MOTION)      , SDL_MOUSEMOTION},
  {Val_int(MLTAG_BUTTONDOWN)  , SDL_MOUSEBUTTONDOWN},
  {Val_int(MLTAG_BUTTONUP)    , SDL_MOUSEBUTTONUP},
  {Val_int(MLTAG_JAXIS)       , SDL_JOYAXISMOTION},
  {Val_int(MLTAG_JBALL)       , SDL_JOYBALLMOTION},
  {Val_int(MLTAG_JHAT)        , SDL_JOYHATMOTION},
  {Val_int(MLTAG_JBUTTONDOWN) , SDL_JOYBUTTONDOWN},
  {Val_int(MLTAG_JBUTTONUP)   , SDL_JOYBUTTONUP},
  {Val_int(MLTAG_RESIZE)      , SDL_VIDEORESIZE},
  {Val_int(MLTAG_EXPOSE)      , SDL_VIDEOEXPOSE},
  {Val_int(MLTAG_QUIT)        , SDL_QUIT},
  {Val_int(MLTAG_USER)        , SDL_USEREVENT},
  {Val_int(MLTAG_SYSWM)       , SDL_SYSWMEVENT}
};
