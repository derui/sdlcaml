#include <SDL_mixer.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include "common.h"
#include "sdl_mixer_flags.h"

#ifdef SDLCAML_MIXER_ENABLE
#include "sdl_mixer_stub.enable.inc"
#else
#include "sdl_mixer_stub.disable.inc"
#endif
