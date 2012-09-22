#include <SDL.h>
#include <SDL_video.h>

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include "sdl_video_flags.h"
#include "common.h"

static int ml_make_video_setting_flag(value flags) {
  CAMLparam1(flags);
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    int converted_tag = ml_lookup_to_c(ml_video_flag_table, Int_val(head(list)));
    flag |= converted_tag;
    list = tail(list);
  }
  CAMLnoreturn;
  return flag;
}

CAMLprim value sdlcaml_set_video_mode(value width, value height,
                                      value depth, value flag_list) {
  CAMLparam4(width, height, depth, flag_list);
  SDL_Surface* surface = NULL;
  int flag = ml_make_video_setting_flag(flag_list);

  surface = SDL_SetVideoMode(Int_val(width), Int_val(height), Int_val(depth),
                             flag);
  if (surface == NULL) {
    caml_raise_with_string(*caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }

  /* this surface don't apply garbage collection */
  CAMLnoreturn;
  return (value)surface;
}

CAMLprim value sdlcaml_free_surface(value surface) {
  SDL_Surface* sur = (SDL_Surface*)surface;

  SDL_FreeSurface(sur);
  return Val_unit;
}

CAMLprim value sdlcaml_get_pixelformat(value surface) {
  /* surface isn't included garbage collection */
  CAMLparam0();

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

  CAMLreturn(pixelformat);
}

CAMLprim value sdlcaml_blit_surface(value src, value dist, value srect, value drect) {
  /* surfaces  mustn't include garbage colleciton! */
  CAMLparam2(srect, drect);
  SDL_Rect src_rect = {0,0,0,0};
  SDL_Rect dist_rect = {0,0,0,0};
  SDL_Rect *srectp = NULL, *drectp = NULL;

  if (is_some(srect)) {
    value extracted = Field(srect, 0);
    src_rect.x = Field(extracted, 0);
    src_rect.y = Field(extracted, 1);
    src_rect.w = Field(extracted, 2);
    src_rect.h = Field(extracted, 3);
    srectp = &src_rect;
  }

  if (is_some(drect)) {
    value extracted = Field(drect, 0);
    dist_rect.x = Field(extracted, 0);
    dist_rect.y = Field(extracted, 1);
    dist_rect.w = Field(extracted, 2);
    dist_rect.h = Field(extracted, 3);
    drectp = &dist_rect;
  }

  int blit_result = SDL_BlitSurface((SDL_Surface*)src,
                                    srectp,
                                    (SDL_Surface*)dist,
                                    drectp);
  switch (blit_result) {
    case -1: CAMLreturn(Val_int(1));         /* Failed */
    case -2: CAMLreturn(Val_int(2));         /* Surface Lost */
    default: CAMLreturn(Val_int(0));         /* Success */
  }
}

CAMLprim value sdlcaml_fill_rect(value dist, value fill, value drect) {
  /* surfaces  mustn't include garbage colleciton! */
  CAMLparam2(fill, drect);
  SDL_Rect dist_rect = {0,0,0,0};
  SDL_Rect *dist_rectp = NULL;

  if (is_some(drect)) {
    dist_rect.x = Field(drect, 0);
    dist_rect.y = Field(drect, 1);
    dist_rect.w = Field(drect, 2);
    dist_rect.h = Field(drect, 3);
    dist_rectp = &dist_rect;
  }

  SDL_PixelFormat* format = ((SDL_Surface*)dist)->format;

  Uint32 color =
      Int_val(Field(fill, 0)) << format->Rshift |
      Int_val(Field(fill, 1)) << format->Gshift |
      Int_val(Field(fill, 2)) << format->Bshift |
      Int_val(Field(fill, 3)) << format->Ashift;

  SDL_FillRect((SDL_Surface*)dist, dist_rectp, color);

  CAMLreturn(Val_unit);
}


CAMLprim value sdlcaml_create_surface(value width, value height,
                                      value flags) {
  CAMLparam3(width, height, flags);
  const int depth = 32;
  int surface_width = Int_val(width);
  int surface_height = Int_val(height);

  /* add SDL_SRCALPHA always. */
  int init_flag = ml_make_video_setting_flag(flags) | SDL_SRCALPHA;
  int rmask, gmask, bmask, amask;

  /* decide masks to depend on current endian  */
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
  rmask = 0xff000000;
  gmask = 0x00ff0000;
  bmask = 0x0000ff00;
  amask = 0x000000ff;
#else
  rmask = 0x000000ff;
  gmask = 0x0000ff00;
  bmask = 0x00ff0000;
  amask = 0xff000000;
#endif

  SDL_Surface* surface = SDL_CreateRGBSurface(init_flag,
      surface_width, surface_height, depth,
      rmask, gmask, bmask, amask);
  if (surface == NULL) {
    caml_raise_with_string(*caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }
  CAMLnoreturn;
  /* surface mustn't include garbage collection! */
  return (value)surface;
}

CAMLprim value sdlcaml_update_rect(value ox, value oy,
                                   value owidth, value oheight, value surface) {
  CAMLparam4(ox, oy, owidth, oheight);
  int x = 0, y = 0;
  SDL_Surface* screen = (SDL_Surface*)surface;

  int w = screen->w, h = screen->h;

  if (is_some(ox)) {
    x = Int_val(Field(ox, 0));
  }

  if (is_some(oy)) {
    y = Int_val(Field(oy, 0));
  }

  if (is_some(owidth)) {
    w = Int_val(Field(owidth, 0));
  }

  if (is_some(oheight)) {
    h = Int_val(Field(oheight, 0));
  }

  SDL_UpdateRect(screen, x, y, w, h);
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_flip(value surface) {
  CAMLparam0();
  if (SDL_Flip((SDL_Surface*)surface)) {
    caml_raise_with_string(*caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }

  CAMLreturn(Val_unit);
}
