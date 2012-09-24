#include <caml/mlvalues.h>

CAMLprim value variant_hash(value variant) {
  return Val_int(caml_hash_variant(variant));
}

/* convert variant to int  */
CAMLprim value variant_tag(value variant) {
  return Val_int(Int_val(variant));
}
