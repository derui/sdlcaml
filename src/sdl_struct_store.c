#include <SDL.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/misc.h>
#include <caml/memory.h>
#include "common.h"
#include "sdl_struct_store.h"
#include "sdl_pixel_format_enum.h"

value sdlcaml_display_store_display_mode(SDL_DisplayMode* mode) {
  CAMLlocal1(ret);

  ret = caml_alloc(4, 0);
  Store_field(ret, 0, ml_lookup_from_c(ml_pixel_format_enum_table, mode->format));
  Store_field(ret, 1, Val_int(mode->width));
  Store_field(ret, 2, Val_int(mode->height));
  Store_field(ret, 3, Val_int(mode->refresh_rate));
 
  CAMLreturn(ret);
}

value sdlcaml_display_store_rect(SDL_Rect* rect) {
  CAMLlocal1(ret);

  ret = caml_alloc(4, 0);
  Store_field(ret, 0, Val_int(rect->x));
  Store_field(ret, 1, Val_int(rect->y));
  Store_field(ret, 2, Val_int(rect->w));
  Store_field(ret, 3, Val_int(rect->h));
 
  CAMLreturn(ret);
}


