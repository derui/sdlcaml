#include <SDL.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>

#include "common.h"
#include "sdl_generic.h"
#include "sdl_key_trans.h"

CAMLprim value sdlcaml_get_key_state(value unit) {
  CAMLparam0();

  int numkey = 0;

  Uint8* keystates = SDL_GetKeyState(&numkey);
  CAMLlocal2(preconvert_array, tuple);
  preconvert_array = caml_alloc(numkey, 0);

  int key_trans_size = ml_table_size(ml_symkey_trans_table);
  for (int i = 0; i < numkey && i < key_trans_size; ++i) {
    tuple = caml_alloc(2, 0);

    int current_key = ml_lookup_to_c(ml_symkey_trans_table, Val_int(i));
    Store_field(tuple, 0, Val_int(i));
    Store_field(tuple, 1, ml_lookup_from_c(
        ml_generic_button_table, keystates[current_key]));

    Store_field(preconvert_array, i, tuple);
  }

  /* convert to state_map with making use of callback function */
  static value* converter = NULL;
  if (converter == NULL) {
    converter = caml_named_value("sdlcaml_ml_convert_state_map");
  }
  CAMLreturn(caml_callback(*converter, preconvert_array));
}

CAMLprim value get_mod_state(value unit) {
  CAMLparam0();
  CAMLlocal1(mod_list);
  mod_list = Val_emptylist;

  int mod_current_state = SDL_GetModState();

  int key_trans_size = ml_table_size(ml_modkey_trans_table);
  for (int i = 0; i < key_trans_size; ++i) {

    /* contains pressing modify key only */
    int current_key = ml_lookup_to_c(ml_modkey_trans_table, Val_int(i));
    if (mod_current_state & current_key) {
      mod_list = add_head(
          mod_list,
          ml_lookup_from_c(ml_modkey_trans_table, current_key));
    }
  }

  CAMLreturn(mod_list);
}

CAMLprim value sdlcaml_enable_key_repeat(value delay, value interval) {
  CAMLparam2(delay, interval);

  int ret = SDL_EnableKeyRepeat(Int_val(delay), Int_val(interval));

  if (ret == 0) {
    CAMLreturn(Val_true);
  } else {
    CAMLreturn(Val_false);
  }
}

CAMLprim value sdlcaml_get_mouse_state(value unit) {
  CAMLparam0();
  CAMLlocal2(button_state, mouse_state);

  int x = 0, y = 0;
  int current_buttons_state = SDL_GetMouseState(&x, &y);

  const int MAX_BUTTON = 32;

  /* get mouse state of as many as possible buttons */
  for (int i = MAX_BUTTON; i > 0; --i) {
    CAMLlocal1(state);
    state = caml_alloc(2, 0);
    Store_field(state, 0, Val_int(i));
    Store_field(state, 1, ml_lookup_from_c(ml_generic_button_table,
                                           current_buttons_state & SDL_BUTTON(i)));

    button_state = add_head(button_state, state);
  }

  mouse_state = caml_alloc(3, 0);
  Store_field(mouse_state, 0, Val_int(x));
  Store_field(mouse_state, 1, Val_int(y));
  Store_field(mouse_state, 2, button_state);

  CAMLreturn(mouse_state);
}
