#include "sdl_ttf_flags.h"

#ifdef SDLCAML_TTF_ENABLE
#include <SDL_ttf.h>

lookup_info ml_ttf_flag_table[] = {
  {0, 5}
  ,{Val_int(MLTAG_TTF_STYLE_NORMAL       ), TTF_STYLE_NORMAL       }
  ,{Val_int(MLTAG_TTF_STYLE_BOLD         ), TTF_STYLE_BOLD         }
  ,{Val_int(MLTAG_TTF_STYLE_ITALIC       ), TTF_STYLE_ITALIC       }
  ,{Val_int(MLTAG_TTF_STYLE_UNDERLINE    ), TTF_STYLE_UNDERLINE    }
  ,{Val_int(MLTAG_TTF_STYLE_STRIKETHROUGH), TTF_STYLE_STRIKETHROUGH}
};

lookup_info ml_ttf_hinting_table[] = {
  {0, 4}
  ,{Val_int(MLTAG_TTF_HINTING_NORMAL), TTF_HINTING_NORMAL}
  ,{Val_int(MLTAG_TTF_HINTING_LIGHT ), TTF_HINTING_LIGHT }
  ,{Val_int(MLTAG_TTF_HINTING_MONO  ), TTF_HINTING_MONO  }
  ,{Val_int(MLTAG_TTF_HINTING_NONE  ), TTF_HINTING_NONE  }
};


#endif
