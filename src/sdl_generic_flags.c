#include <caml/mlvalues.h>

#include "common.h"
#include "sdl_generic_flags.h"

lookup_info ml_generic_button_table[] = {
  {0, 2},
  {Val_int(MLTAG_PRESSED), 1},
  {Val_int(MLTAG_RELEASED), 0}
};
