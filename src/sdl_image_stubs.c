#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include "common.h"

#ifdef SDLCAML_IMAGE_ENABLE
#include <SDL_image.h>
#include "sdl_image_flags.h"
#include "sdl_image_stubs.enable.inc"
#else
#include "sdl_image_stubs.disable.inc"
#endif
