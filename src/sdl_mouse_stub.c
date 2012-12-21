#include <SDL.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>

#include "common.h"

value value_of_mousebutton_state(Uint8 state) {
  CAMLparam0();
  value v = Val_emptylist;
  int i;
  const int buttons[] = {
    SDL_BUTTON_LEFT,
    SDL_BUTTON_MIDDLE,
    SDL_BUTTON_RIGHT,
  };

  for (i = SDL_TABLESIZE(buttons) - 1; i >= 0; i--) {
   if (state & SDL_BUTTON(buttons[i])) {
     v = add_head(v, Val_int(i));
    }
  }
  CAMLreturn(v);
}

CAMLprim value sdlcaml_get_mouse_state(value unit) {
  CAMLparam0();
  CAMLlocal2(button_state, mouse_state);

  int x = 0, y = 0;
  int current_buttons_state = SDL_GetMouseState(&x, &y);

  button_state = Val_emptylist;

  mouse_state = caml_alloc(3, 0);
  Store_field(mouse_state, 0, Val_int(x));
  Store_field(mouse_state, 1, Val_int(y));
  Store_field(mouse_state, 2, value_of_mousebutton_state(current_buttons_state));

  CAMLreturn(mouse_state);
}
