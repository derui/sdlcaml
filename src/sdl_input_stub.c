#include <SDL.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>

#include "common.h"
#include "sdl_generic_flags.h"
#include "sdl_key_trans.h"

CAMLprim value sdlcaml_get_key_state(value unit) {
  CAMLparam0();
  CAMLlocal3(preconvert_array, tuple, converted);
  int numkey = 0;

  Uint8* keystates = SDL_GetKeyState(&numkey);
  preconvert_array = Val_emptylist;

  int key_trans_size = ml_table_size(ml_symkey_trans_table);
  for (int i = 1; i <= numkey && i <= key_trans_size; ++i) {
    tuple = caml_alloc(2, 0);

    int current_key = ml_lookup_to_c(ml_symkey_trans_table, Val_int(i - 1));
    Store_field(tuple, 0, Val_int(i - 1));
    Store_field(tuple, 1, ml_lookup_from_c(
        ml_generic_button_table, keystates[current_key]));

    preconvert_array = add_head(preconvert_array, tuple);
  }

  /* convert to state_map with making use of callback function */
  static value* converter = NULL;
  if (converter == NULL) {
    converter = caml_named_value("sdlcaml_ml_convert_state_map");
  }
  converted = caml_callback(*converter, preconvert_array);
  CAMLreturn(converted);
}

CAMLprim value sdlcaml_set_mod_state(value list) {
  CAMLparam1(list);

  int keystate = KMOD_NONE;

  while (is_not_nil(list)) {
    CAMLlocal1(modkey);
    modkey = head(list);
    keystate |= ml_lookup_to_c(ml_modkey_trans_table, modkey);
    list = tail(list);
  }

  SDL_SetModState(keystate);
  CAMLnoreturn;
  return Val_unit;
}

CAMLprim value sdlcaml_get_mod_state(value unit) {
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
