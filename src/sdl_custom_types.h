#ifndef __SDL_CUSTOM_TYPES_H__
#define __SDL_CUSTOM_TYPES_H__

#include <SDL.h>

/* Encapsulation of opaque SDL Window (of type SDL_Window *)
   as Caml custom blocks
 */
static struct custom_operations sdl_window_ops = {
  "sdlcaml.sdl_window",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_Surface * part of a Caml custom block */
#define Window_val(v) (*((SDL_Window**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_Surface *  */
static value alloc_window(SDL_Window* surface);

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
static value alloc_surface(SDL_Surface* surface);

#endif
