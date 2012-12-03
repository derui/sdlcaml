#include "sdl_image_flags.h"

#ifdef SDLCAML_IMAGE_ENABLE
#include <SDL_image.h>

lookup_info ml_image_flag_table[] = {
  {0, 3}
  ,{Val_int( MLTAG_IMG_INIT_JPG), IMG_INIT_JPG}
  ,{Val_int( MLTAG_IMG_INIT_PNG), IMG_INIT_PNG}
  ,{Val_int( MLTAG_IMG_INIT_TIF), IMG_INIT_TIF}
};
#endif
