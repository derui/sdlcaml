#ifndef __SDL_STRUCT_STORE_H__
#define __SDL_STRUCT_STORE_H__

#include <caml/mlvalues.h>

value sdlcaml_display_store_display_mode(SDL_DisplayMode* mode);

value sdlcaml_display_store_rect(SDL_Rect* rect);

#endif
