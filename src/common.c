#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include "common.h"

int ml_lookup_to_c(lookup_info *table, value key) {
  CAMLparam1(key);
  if (table == NULL) {
    CAMLreturnT(int, 0);
  }
  int length = table[0].value;

  int i = 0;
  for (i = 1; i <= length; ++i) {
    if (key == table[i].key) {
      CAMLreturnT(int, table[i].value);
    }
  }

  /* not found */
  CAMLreturnT(int, 0);
}

value ml_lookup_from_c(lookup_info *table, int val) {
  CAMLparam0 ();
  if (table == NULL) {
    CAMLreturn(Val_int(0));
  }
  int length = table[0].value;

  int i = 0;
  for (i = 1; i <= length; ++i) {
    if (val == table[i].value) {
      CAMLreturn(table[i].key);
    }
  }

  /* not found */
  CAMLreturn(Val_int(0));
}

int ml_table_size(lookup_info* table) {
  CAMLparam0();
  if (table == NULL) {
    return 0;
  }

  CAMLreturnT(int, table[0].value);
}

/* this is pure C function. */
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
  CAMLparam1(list);

  if (list != Val_emptylist) {
    CAMLreturn(Field(list, 0));
  } else {
    CAMLreturn(Val_emptylist);
  }
}

value tail(value list) {
  CAMLparam1(list);

  if (list != Val_emptylist) {
    CAMLreturn(Field(list, 1));
  } else {
    CAMLreturn(Val_emptylist);
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
  CAMLparam1(list);
  CAMLreturnT(int, list != Val_emptylist);
}

/****************************************************/

value Val_some( value v ) {
  CAMLparam1( v );
  CAMLlocal1( some );
  some = caml_alloc(1, 0);
  Store_field( some, 0, v );
  CAMLreturn( some );
}

int is_none(value opt) {
  CAMLparam1(opt);
  CAMLreturnT(int, opt == Val_int(0));
}

int is_some(value opt) {
  CAMLparam1(opt);
  CAMLreturnT(int, !is_none(opt));
}

value Val_left(value v) {
  CAMLparam1(v);
  CAMLlocal1(left);
  left = caml_alloc(1, 0);
  Store_field(left, 0, v);
  CAMLreturn(left);
}

value Val_right(value v) {
  CAMLparam1(v);
  CAMLlocal1(right);
  right = caml_alloc(1, 1);
  Store_field(right, 0, v);
  CAMLreturn(right);
}
