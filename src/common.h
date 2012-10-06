#ifndef __COMMON_H__
#define __COMMON_H__

#include <caml/mlvalues.h>

#define Val_none (Val_int(0))

typedef struct lookup_info {
  value key;
  int value;
} lookup_info;

typedef struct generic_lookup_info {
  int key;
  void* value;
} generic_lookup_info;

/**
 * lookup from key of OCaml to value of C, or from value of C to key OCaml
 * To be able to receive table is constructed that first is key equal zero and
 * value is length of table without itself.
 */
int ml_lookup_to_c(lookup_info *table, value key);
value ml_lookup_from_c(lookup_info *table, int value);
int ml_table_size(lookup_info *table);

/* privide to look up data from table of associating key with generic data
   (void*).
   It only look up by key of int, but to be useful.
   If key can't look up from given table, return NULL.

   Noted: format of table is similer to table used with lookup_info,
          but first element of table is difference.
          It is must to be {number of table element, 0}.
 */
void* ml_generic_lookup(generic_lookup_info* table, int key);

/** list operation helper used from C */
value head(value list);
value tail(value list);
value add_head(value list, value cons);
int is_not_nil(value list);

/** operations for 'a option */
/* if given value is none, return 1.a*/
int is_none(value opt);
/* if given value is some, return 1.a*/
int is_some(value opt);

/* construct Some with the given value. this pair for Val_none */
value Val_some(value);

/* construct Left and Right with given value */
value Val_left(value);
value Val_right(value);

#endif /* __COMMON_H__ */
