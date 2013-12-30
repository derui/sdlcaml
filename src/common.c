#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/bigarray.h>
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

static int ml_make_init_flag(lookup_info* table, value flags) {
  CAMLparam1(flags);
  CAMLlocal1(tag);
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    tag = head(list);
    int converted_tag = ml_lookup_to_c(table, tag);
    flag |= converted_tag;
    list = tail(list);
  }
  CAMLnoreturn;
  return flag;
}

int ml_table_size(lookup_info* table) {
  CAMLparam0();
  if (table == NULL) {
    return 0;
  }

  CAMLreturnT(int, table[0].value);
}

value ml_make_list_from_combined_flag(lookup_info* table, int flag) {
  CAMLparam0();
  CAMLlocal2(list, f);
  list = Val_int(0);

  for (int i = 0; i < ml_table_size(table); ++i) {
    if (table[i + 1].value & flag) {
      f = ml_lookup_from_c(table, table[i + 1].value & flag);
      list = add_head(list, f);
    }
  }

  CAMLreturn(list);
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


value array_from_c(value* array, int size) {
  CAMLparam0();
  CAMLlocal1(ret);
  ret = caml_alloc(size, 0);

  for (int i = 0; i < size; ++i) {
    Store_field(ret, i, array[i]);
  }
  CAMLreturn(ret);
}

int get_bigarray_kind_size(value bigarray) {
  CAMLparam1(bigarray);

  int size = 0;
  switch (Bigarray_val(bigarray)->flags & BIGARRAY_KIND_MASK) {
    case BIGARRAY_FLOAT32:
      size = sizeof(float);
      break;
    case BIGARRAY_FLOAT64:
      size = sizeof(double);
      break;
    case BIGARRAY_SINT8:
      size =  sizeof(char);
      break;
    case BIGARRAY_UINT8:
      size =  sizeof(unsigned char);
      break;
    case BIGARRAY_SINT16:
      size = sizeof(short);
      break;
    case BIGARRAY_UINT16:
      size = sizeof(unsigned short);
      break;
    case BIGARRAY_INT32:
      size = sizeof(int);
      break;
    case BIGARRAY_INT64:
      size = sizeof(long);
      break;
    case BIGARRAY_CAML_INT:
      size = sizeof(int) - 1;
      break;
    case BIGARRAY_NATIVE_INT:
      size = sizeof(int);
      break;
    default:
      break;
  }
  
  CAMLreturnT(int, size);
}

int ml_make_combined_flag(lookup_info* table, value flags) {
  
  CAMLparam1(flags);
  CAMLlocal1(tag);
  value list = flags;
  int flag = 0;

  while (is_not_nil(list)) {
    tag = head(list);
    int converted_tag = ml_lookup_to_c(table, tag);
    flag |= converted_tag;
    list = tail(list);
  }

  CAMLreturnT(int, flag);
}
