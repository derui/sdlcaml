#include <SDL.h>
#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/misc.h>
#include <caml/memory.h>
#include "common.h"
#include "sdl_pixel_format_enum.h"
#include "sdl_struct_store.h"

CAMLprim value sdlcaml_display_disable_screen_saver(value unit){
  CAMLparam1(unit);

  SDL_DisableScreenSaver();

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_display_enable_screen_saver(value unit){
  CAMLparam1(unit);

  SDL_EnableScreenSaver();

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_display_get_desktop_display_mode(value index) {
  CAMLparam1(index);

  SDL_DisplayMode* raw_mode = NULL;
  int ret = SDL_GetDesktopDisplayMode(Int_val(index),
                                      raw_mode);

  if (ret != 0) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(sdlcaml_display_store_display_mode(raw_mode));
}

CAMLprim value sdlcaml_display_get_current_display_mode(value index) {
  CAMLparam1(index);

  SDL_DisplayMode* raw_mode = NULL;
  int ret = SDL_GetCurrentDisplayMode(Int_val(index),
                                      raw_mode);

  if (ret != 0) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(sdlcaml_display_store_display_mode(raw_mode));
}

CAMLprim value sdlcaml_display_get_display_bounds(value index) {
  CAMLparam1(index);
  CAMLlocal1(rect);

  SDL_Rect* raw_rect = NULL;
  int ret = SDL_GetDisplayBounds(Int_val(index),
                                 rect);

  if (ret != 0) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(sdlcaml_display_store_rect(rect));
}
  
CAMLprim value sdlcaml_display_get_display_mode(value index, value mode, value dummy) {
  CAMLparam3(index, mode, dummy);
  CAMLlocal1(mode);

  SDL_DisplayMode* raw_mode = NULL;
  int ret = SDL_GetDisplayMode(Int_val(index),
                               Int_val(mode),
                               raw_mode);

  if (ret != 0) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(sdlcaml_display_store_display_mode(raw_mode));
}

CAMLprim value sdlcaml_display_get_display_name(value index) {
  CAMLparam1(index);
  CAMLlocal1(name);

  const char* ret = SDL_GetDisplayName(Int_val(index));

  if (ret == NULL) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(caml_copy_string(ret));
}

CAMLprim value sdlcaml_display_get_num_display_modes(value index) {
  CAMLparam1(index);

  int ret = SDL_GetNumDisplayModes(Int_val(index));

  CAMLreturn(Val_int(ret));
}

CAMLprim value sdlcaml_display_get_num_video_displays(value dummy) {
  CAMLparam1(dummy);

  int ret = SDL_GetNumVideoDisplays();

  if (ret < 0) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(Val_int(ret));
}

CAMLprim value sdlcaml_display_get_num_video_drivers(value dummy) {
  CAMLparam1(dummy);

  int ret = SDL_GetNumVideoDrivers();

  if (ret < 0) {
    caml_raise_with_string(*caml_named_value("Sdl_display_exception"),
                           SDL_GetError());
  }

  CAMLreturn(Val_int(ret));
}

CAMLprim value sdlcaml_display_get_video_driver(value index) {
  CAMLparam1(index);

  const char* name = SDL_GetVideoDriver(Int_val(index));

  CAMLreturn(caml_copy_string(name));
}
