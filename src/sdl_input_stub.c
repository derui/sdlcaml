#include <SDL.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>


#include "common.h"
#include "sdl_input_trans.h"

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
        ml_generic_button_state_table, keystates[current_key]));

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

}
