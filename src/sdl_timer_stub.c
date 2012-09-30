#include <SDL.h>
#include <SDL_timer.h>

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include "common.h"

CAMLprim value sdlcaml_getticks(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Val_int(SDL_GetTicks()));
}

CAMLprim value sdlcaml_delay(value times) {
  CAMLparam1(times);
  int millseconds = Int_val(times);

  SDL_Delay(millseconds);

  CAMLreturn(Val_unit);
}
