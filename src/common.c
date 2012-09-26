#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
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

int ml_table_size(lookup_info* table) {
  if (table == NULL) {
    return 0;
  }

  return table[0].value;
}

void* ml_generic_lookup(generic_lookup_info *table, int key) {
  if (table == NULL) {
    return NULL;
  }
  int length = table[0].key;

  for (int i = 1; i <= length; ++i) {
    if (key == table[i].key) {
      return table[i].value;
    }
  }

  /* not found */
  return NULL;
}


/*****************************************************/

value head(value list) {

  if (list != Val_emptylist) {
    return Field(list, 0);
  } else {
    return Val_emptylist;
  }
}

value tail(value list) {

  if (list != Val_emptylist) {
    return Field(list, 1);
  } else {
    return Val_emptylist;
  }
}

/* add cons to head of list */
value add_head(value list, value data) {
  CAMLparam2(list, data);
  CAMLlocal1(cons);
  cons = caml_alloc(2,0);
  Store_field(cons, 0, data);
  Store_field(cons, 1, list);
  CAMLreturn(cons);
}

int is_not_nil(value list) {
  return (list != Val_emptylist);
}

/****************************************************/

int is_none(value opt) {
  return opt == Val_int(0);
}

int is_some(value opt) {
  return !is_none(opt);
}
