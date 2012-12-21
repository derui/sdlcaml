#include <SDL.h>

#include <caml/alloc.h>
#include <caml/bigarray.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include <caml/custom.h>
#include "sdl_video_flags.h"
#include "common.h"


/* Encapsulation of opaque SDL surface (of type SDL_Surface *)
   as Caml custom blocks
 */
static struct custom_operations sdl_surface_ops = {
  "sdlcaml.sdl_surface",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_Surface * part of a Caml custom block */
#define Surface_val(v) (*((SDL_Surface**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_surface(SDL_Surface* surface) {
  value v = alloc_custom(&sdl_surface_ops, sizeof(SDL_Surface*), 0, 1);
  Surface_val(v) = surface;
  return v;
}

int ml_convert_gl_attr_to_c(value attr) {
  CAMLparam1(attr);

  switch (Int_val(attr)) {
    case  0: CAMLreturnT(int, SDL_GL_RED_SIZE);
    case  1: CAMLreturnT(int, SDL_GL_GREEN_SIZE);
    case  2: CAMLreturnT(int, SDL_GL_BLUE_SIZE);
    case  3: CAMLreturnT(int, SDL_GL_ALPHA_SIZE);
    case  4: CAMLreturnT(int, SDL_GL_DOUBLEBUFFER);
    case  5: CAMLreturnT(int, SDL_GL_BUFFER_SIZE);
    case  6: CAMLreturnT(int, SDL_GL_DEPTH_SIZE);
    case  7: CAMLreturnT(int, SDL_GL_STENCIL_SIZE);
    case  8: CAMLreturnT(int, SDL_GL_ACCUM_RED_SIZE);
    case  9: CAMLreturnT(int, SDL_GL_ACCUM_GREEN_SIZE);
    case 10: CAMLreturnT(int, SDL_GL_ACCUM_BLUE_SIZE);
    case 11: CAMLreturnT(int, SDL_GL_ACCUM_ALPHA_SIZE);
  }
  caml_failwith("Can not convert between attr of C and attr of Caml");
}

static int ml_make_video_setting_flag(value flags) {
  CAMLparam1(flags);
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    int converted_tag = ml_lookup_to_c(ml_video_flag_table, head(list));
    flag |= converted_tag;
    list = tail(list);
  }
  CAMLnoreturn;
  return flag;
}

CAMLprim value sdlcaml_set_video_mode(value width, value height,
                                      value depth, value flag_list) {
  CAMLparam4(width, height, depth, flag_list);
  SDL_Surface* raw_surface = NULL;
  int flag = ml_make_video_setting_flag(flag_list);

  raw_surface = SDL_SetVideoMode(Int_val(width), Int_val(height), Int_val(depth),
                                 flag);
  if (raw_surface == NULL) {
    caml_raise_with_string(*caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }

  CAMLreturn(alloc_surface(raw_surface));
}

CAMLprim value sdlcaml_free_surface(value surface) {
  CAMLparam1(surface);

  SDL_FreeSurface(Surface_val(surface));
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_get_pixelformat(value surface) {
  CAMLparam1(surface);

  SDL_PixelFormat *format = (Surface_val(surface))->format;
  CAMLlocal1(pixelformat);
  pixelformat = caml_alloc(16, 0);

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
  CAMLparam4(srect, drect, dist, src);
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

  int blit_result = SDL_BlitSurface(Surface_val(src),
                                    srectp,
                                    Surface_val(dist),
                                    drectp);
  switch (blit_result) {
    case -1: CAMLreturn(Val_int(1));         /* Failed */
    case -2: CAMLreturn(Val_int(2));         /* Surface Lost */
    default: CAMLreturn(Val_int(0));         /* Success */
  }
}

CAMLprim value sdlcaml_fill_rect(value dist, value fill, value drect) {
  CAMLparam3(fill, drect, dist);
  CAMLlocal1(vrect);
  SDL_Rect dist_rect = {0,0,0,0};
  SDL_Rect *dist_rectp = NULL;

  if (is_some(drect)) {
    vrect = Field(drect, 0);
    dist_rect.x = Int_val(Field(vrect, 0));
    dist_rect.y = Int_val(Field(vrect, 1));
    dist_rect.w = Int_val(Field(vrect, 2));
    dist_rect.h = Int_val(Field(vrect, 3));
    dist_rectp = &dist_rect;
  }

  SDL_PixelFormat* format = (Surface_val(dist))->format;

  Uint32 color =
      Int_val(Field(fill, 0)) << format->Rshift |
      Int_val(Field(fill, 1)) << format->Gshift |
      Int_val(Field(fill, 2)) << format->Bshift |
      Int_val(Field(fill, 3)) << format->Ashift;

  SDL_FillRect(Surface_val(dist), dist_rectp, color);

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

  SDL_Surface* raw_surface = SDL_CreateRGBSurface(init_flag,
      surface_width, surface_height, depth,
      rmask, gmask, bmask, amask);
  if (raw_surface == NULL) {
    caml_raise_with_string(*caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }
  CAMLreturn(alloc_surface(raw_surface));
}

CAMLprim value sdlcaml_update_rect(value ox, value oy,
                                   value owidth, value oheight, value surface) {
  CAMLparam5(ox, oy, owidth, oheight, surface);
  int x = 0, y = 0;

  int w = (Surface_val(surface))->w, h = (Surface_val(surface))->h;

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

SDL_UpdateRect(Surface_val(surface), x, y, w, h);
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_flip(value surface) {
  CAMLparam1(surface);
  if (SDL_Flip(Surface_val(surface))) {
    caml_raise_with_string(*caml_named_value("SDL_video_exception"),
                           SDL_GetError());
  }

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_clear(value fill, value dist) {
  CAMLparam2(fill, dist);
  SDL_PixelFormat* format = (Surface_val(dist))->format;

  Uint32 color = 0;

  if (is_some(fill)) {
    color =
        Int_val(Field(Field(fill, 0), 0)) << format->Rshift |
        Int_val(Field(Field(fill, 0), 1)) << format->Gshift |
        Int_val(Field(Field(fill, 0), 2)) << format->Bshift |
        Int_val(Field(Field(fill, 0), 3)) << format->Ashift;
  }

  SDL_FillRect(Surface_val(dist), NULL, color);
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_video_get_pixels(value surface) {
  CAMLparam1(surface);
  CAMLlocal1(res);
  SDL_Surface* surf = Surface_val(surface);

  long dims[3] = {
    surf->w,
    surf->h,
    surf->format->BytesPerPixel
  };

  res = caml_ba_alloc(
      BIGARRAY_UINT8 | BIGARRAY_C_LAYOUT,
      3, (unsigned char*)surf->pixels, dims);
  CAMLreturn(res);
}

CAMLprim value sdlcaml_video_get_size(value surface) {
  CAMLparam1(surface);
  CAMLlocal1(res);
  SDL_Surface* surf = Surface_val(surface);

  res = caml_alloc(2, 0);
  Store_field(res, 0, Val_int(surf->w));
  Store_field(res, 1, Val_int(surf->h));
  CAMLreturn(res);
}

CAMLprim value sdlcaml_video_gl_set_attribute(value attr, value v) {
  CAMLparam2(attr, v);

  int ret = SDL_GL_SetAttribute(ml_convert_gl_attr_to_c(attr),
                                Int_val(v));
  CAMLreturn(ret == 0 ? Val_true : Val_false);
}

CAMLprim value sdlcaml_video_gl_get_attribute(value attr) {
  CAMLparam1(attr);

  int val = 0;
  SDL_GL_GetAttribute(ml_convert_gl_attr_to_c(attr),
                      &val);
  CAMLreturn(Val_int(val));
}

CAMLprim value sdlcaml_video_gl_swap_buffer(value unit) {
  CAMLparam1(unit);
  SDL_GL_SwapBuffers();
  CAMLreturn(Val_unit);
}
