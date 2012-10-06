#include <stdio.h>

#include <caml/mlvalues.h>

CAMLprim value variant_hash(value variant) {

  printf("(%d)", caml_hash_variant(String_val(variant)));
  fflush(stdout);
  return Val_unit;
}

/* convert variant to int  */
CAMLprim value variant_tag(value variant) {
  return Val_int(Long_val(variant));
}
