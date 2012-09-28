#include <SDL.h>
#include <SDL_version.h>

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include "sdl_initflags.h"
#include "common.h"

int ml_init_tag_to_flag(value tag) {
  return ml_lookup_to_c(ml_init_flag_table, tag);
}

static int ml_make_init_flag(value flags) {
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    int converted_tag = ml_init_tag_to_flag(head(list));
    flag |= converted_tag;
    list = tail(list);
  }
  return flag;
}

static void sdlcaml_inner_quit(void) {
  SDL_Quit();
}

CAMLprim value sdlcaml_init(value auto_clean, value flags) {
  CAMLparam2(auto_clean, flags);
  int init_flag = ml_make_init_flag(flags);

  if (SDL_Init(init_flag) < 0) {
    caml_raise_with_string(caml_named_value("SDL_init_exception"),
                           SDL_GetError());
  }

  if (is_none(auto_clean)) {
    atexit(sdlcaml_inner_quit);
  }

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_quit(value unit) {
  /* only calling inner function */
  CAMLparam0();
  sdlcaml_inner_quit();
  CAMLnoreturn;
  return Val_unit;
}

CAMLprim value sdlcaml_was_init(value subsystems) {
  /* only calling inner function */
  CAMLparam1(subsystems);
  int flag = ml_make_init_flag(subsystems);

  int initialized = SDL_WasInit(flag);

  CAMLreturn(initialized == flag ? Val_true : Val_false);
}

CAMLprim value sdlcaml_version(value unit) {
  CAMLparam0();
  CAMLlocal1(tuple);
  tuple = caml_alloc(3, 0);

  SDL_version version;
  SDL_VERSION(&version);

  /* mapping each number to tuple */
  Store_field( tuple, 0, Val_int(version.major));
  Store_field( tuple, 1, Val_int(version.minor));
  Store_field( tuple, 2, Val_int(version.patch));

  CAMLreturn(tuple);
}

CAMLprim value sdlcaml_init_subsystem(value flag) {
  CAMLparam1(flag);
  int c_flag = ml_lookup_to_c(ml_init_flag_table, flag);

  if (SDL_InitSubSystem(c_flag)) {
    caml_raise_with_string(caml_named_value("SDL_init_exception"),
                           SDL_GetError());
  }

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_quit_subsystem(value flag) {
  CAMLparam1(flag);
  int c_flag = ml_lookup_to_c(ml_init_flag_table, flag);

  SDL_QuitSubSystem(c_flag);
  CAMLreturn(Val_unit);
}
