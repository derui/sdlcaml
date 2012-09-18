#include <caml/mlvalues.h>

CAMLprim value variant_hash(value variant) {
  return Val_int(caml_hash_variant(variant));
}
