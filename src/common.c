#include <caml/mlvalues.h>
#include "common.h"

int ml_lookup_to_c(lookup_info *table, value key) {
  if (table == NULL) {
    return 0;
  }
  int length = table[0].value;

  int i = 0;
  for (i = 1; i <= length; ++i) {
    if (key == table[i].key) {
      return table[i].value;
    }
  }

  /* not found */
  return 0;
}

value ml_lookup_from_c(lookup_info *table, int value) {
  if (table == NULL) {
    return Val_int(0);
  }
  int length = table[0].value;

  int i = 0;
  for (i = 1; i <= length; ++i) {
    if (value == table[i].value) {
      return table[i].key;
    }
  }

  /* not found */
  return Val_int(0);
}

/*****************************************************/

CAMLprim value head(value list) {

  if (list != Val_emptylist) {
    return Field(list, 0);
  } else {
    return Val_emptylist;
  }
}

CAMLprim value tail(value list) {

  if (list != Val_emptylist) {
    return Field(list, 1);
  } else {
    return Val_emptylist;
  }
}

int is_not_nil(value list) {
  return (list != Val_emptylist);
}
