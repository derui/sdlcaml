#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include "common.h"

#ifdef SDLCAML_TTF_ENABLE
#include "sdl_ttf_stubs.enable.inc"
#else
#include "sdl_ttf_stubs.disable.inc"
#endif
