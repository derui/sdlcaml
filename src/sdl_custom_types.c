#include <SDL.h>
#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/misc.h>
#include <caml/memory.h>
#include "common.h"
#include "sdl_custom_types.h"

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_window(SDL_Window* surface) {
  value v = alloc_custom(&sdl_window_ops, sizeof(SDL_Window*), 0, 1);
  Window_val(v) = surface;
  return v;
}

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_surface(SDL_Surface* surface) {
  value v = alloc_custom(&sdl_surface_ops, sizeof(SDL_Surface*), 0, 1);
  Surface_val(v) = surface;
  return v;
}

