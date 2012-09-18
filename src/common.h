#ifndef __COMMON_H__
#define __COMMON_H__

#include <caml/mlvalues.h>

typedef struct lookup_info {
  value key;
  int value;
} lookup_info;

/** 
 * lookup from key of OCaml to value of C, or from value of C to key OCaml 
 * To be able to receive table is constructed that first is key equal zero and 
 * value is length of table without itself.
 */
int ml_lookup_to_c(lookup_info *table, value key);
value ml_lookup_from_c(lookup_info *table, int value);

/** list operation helper used from C */
value head(value list);
value tail(value list);
int is_not_nil(value list);

#endif /* __COMMON_H__ */

