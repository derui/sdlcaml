#include <SDL.h>
#include <SDL_video.h>

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include "sdl_video_flags.h"
#include "common.h"

static int ml_make_video_setting_flag(value flags) {
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    int converted_tag = ml_lookup_to_c(ml_video_flag_table, head(list));
    flag |= converted_tag;
    list = tail(list);
  }
  return flag;
}

CAMLprim value sdlcaml_set_video_mode(value width, value height,
                                      value depth, value flag_list) {
  SDL_Surface* surface = NULL;
  int flag = ml_make_video_setting_flag(flag_list);

  surface = SDL_SetVideoMode(Int_val(width), Int_val(height), Int_val(depth),
                             flag);
  if (surface == NULL) {
    caml_raise_with_string(caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }
  return (value)surface;
}

CAMLprim value sdlcaml_free_surface(value surface) {
  SDL_Surface* sur = (SDL_Surface*)surface;

  SDL_FreeSurface(sur);
  return Val_unit;
}

CAMLprim value sdlcaml_get_pixelformat(value surface) {
  SDL_PixelFormat *format = ((SDL_Surface*)surface)->format;
  value pixelformat = caml_alloc(16, 0);

  Store_field(pixelformat,  0, Val_int(format->BitsPerPixel));
  Store_field(pixelformat,  1, Val_int(format->BytesPerPixel));
  Store_field(pixelformat,  2, Val_int(format->Rloss));
  Store_field(pixelformat,  3, Val_int(format->Gloss));
  Store_field(pixelformat,  4, Val_int(format->Bloss));
  Store_field(pixelformat,  5, Val_int(format->Aloss));
  Store_field(pixelformat,  6, Val_int(format->Rshift));
  Store_field(pixelformat,  7, Val_int(format->Gshift));
  Store_field(pixelformat,  8, Val_int(format->Bshift));
  Store_field(pixelformat,  9, Val_int(format->Ashift));
  Store_field(pixelformat, 10, Val_int(format->Rmask));
  Store_field(pixelformat, 11, Val_int(format->Gmask));
  Store_field(pixelformat, 12, Val_int(format->Bmask));
  Store_field(pixelformat, 13, Val_int(format->Amask));
  Store_field(pixelformat, 14, Val_int(format->colorkey));
  Store_field(pixelformat, 15, Val_int(format->alpha));

  return pixelformat;
}
