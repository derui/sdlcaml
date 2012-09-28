#include <SDL.h>
#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/misc.h>
#include <caml/memory.h>
#include "common.h"

CAMLprim value sdlcaml_wm_set_caption(value title, value icon, value dummy) {
  CAMLparam3(title, icon, dummy);
  char *buf_icon_name = NULL;
  char *buf_title = NULL;
  char *current_icon_name = NULL;
  char *current_title = NULL;

  if (is_some(icon)) {
    int len = caml_string_length(Field(icon, 0)) + 1;
    buf_icon_name = malloc(len * sizeof(char));
    memcpy(buf_icon_name, String_val(Field(icon, 0)), len);
    current_icon_name = buf_icon_name;
  }

  if (is_some(title)) {
    int len = caml_string_length(Field(title, 0)) + 1;
    buf_title = malloc(len * sizeof(char));
    memcpy(buf_title, String_val(Field(title, 0)), len);
    current_title = buf_title;
  }

  SDL_WM_SetCaption(current_title, current_icon_name);

  if (buf_icon_name != NULL) {
    free(buf_icon_name);
  }

  if (buf_title != NULL) {
    free(buf_title);
  }

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_wm_get_caption(value unit) {
  CAMLparam1(unit);
  char *current_icon_name = NULL;
  char *current_title = NULL;

  SDL_WM_GetCaption(&current_title, &current_icon_name);

  CAMLlocal1(tuple);
  tuple = caml_alloc(2, 0);
  if (current_title != NULL) {
    Store_field(tuple, 0, caml_copy_string((const char*)current_title));
  } else {
    Store_field(tuple, 0, caml_copy_string(""));
  }
  if (current_icon_name != NULL) {
    Store_field(tuple, 1, caml_copy_string((const char*)current_icon_name));
  } else {
    Store_field(tuple, 1, caml_copy_string(""));
  }

  CAMLreturn(tuple);
}

CAMLprim value sdlcaml_wm_get_title(value unit) {
  CAMLparam0();
  char *current_icon_name = NULL;
  char *current_title = NULL;

  SDL_WM_GetCaption(&current_title, &current_icon_name);

  if (current_title == NULL) {
    CAMLreturn(caml_copy_string(""));
  } else {
    CAMLreturn(caml_copy_string(current_title));
  }
}

CAMLprim value sdlcaml_wm_get_icon_name(value unit) {
  CAMLparam0();
  char *current_icon_name = NULL;
  char *current_title = NULL;

  SDL_WM_GetCaption(&current_title, &current_icon_name);

  if (current_icon_name == NULL) {
    CAMLreturn(caml_copy_string(""));
  } else {
    CAMLreturn(caml_copy_string(current_icon_name));
  }
}

CAMLprim value sdlcaml_wm_iconify_window(value unit) {
  CAMLparam0();
  int result = SDL_WM_IconifyWindow();

  if (result) {
    CAMLreturn(Val_true);
  } else {
    CAMLreturn(Val_false);
  }
}

CAMLprim value sdlcaml_wm_toggle_fullscreen(value unit) {
  CAMLparam0();
  int result = SDL_WM_ToggleFullScreen(SDL_GetVideoSurface());

  if (result) {
    CAMLreturn(Val_true);
  } else {
    CAMLreturn(Val_false);
  }
}

CAMLprim value sdlcaml_wm_grab_input(value mode) {
  CAMLparam0();
  SDL_GrabMode c_mode = SDL_GRAB_QUERY;
  switch (Int_val(mode)) {
    case 0: c_mode = SDL_GRAB_QUERY; break;
    case 1: c_mode = SDL_GRAB_ON; break;
    case 2: c_mode = SDL_GRAB_OFF; break;
    default: caml_invalid_argument("without grab_mode value!");
  }

  CAMLreturn(Val_int(SDL_WM_GrabInput(c_mode)));
}
