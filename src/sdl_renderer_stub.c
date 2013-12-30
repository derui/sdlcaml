#include <SDL.h>
#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/misc.h>
#include <caml/memory.h>
#include "common.h"
#include "sdl_renderer_flags.h"

/* Encapsulation of opaque SDL Window (of type SDL_Window *)
   as Caml custom blocks
 */
static struct custom_operations sdl_renderer_ops = {
  "sdlcaml.sdl_window",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_Surface * part of a Caml custom block */
#define Renderer_val(v) (*((SDL_Renderer**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_renderer(SDL_Renderer* surface) {
  value v = alloc_custom(&sdl_renderer_ops, sizeof(SDL_Renderer*), 0, 1);
  Renderer_val(v) = surface;
  return v;
}


CAMLprim value sdl_wm_create_renderer(value window, value index, value flags) {
  CAMLparam3(window, index, flags);

  SDL_Renderer* renderer = SDL_CreateRenderer(
      Window_val(window),
      Int_val(index),
      ml_make_conbined_flag(ml_renderer_flags_table, flags));

  if (renderer == NULL) {
    caml_raise_with_string(*caml_named_value("SDL_renderer_exception"),
                           SDL_GetError());
  }

  CAMLreturn(alloc_renderer(renderer));
}

CAMLprim value sdlcaml_wm_destroy_renderer(value renderer) {
  CAMLparam1(renderer);

  SDL_DestroyRenderer(Renderer_val(renderer));

  CAMLreturn(Val_unit);
}
