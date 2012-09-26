#ifndef __SDL_EVENT_CONVERT_H__
#define __SDL_EVENT_CONVERT_H__

#include <caml/mlvalues.h>
#include <SDL.h>

/** convert ml to C or C to ml. */

/* convert received event to pointer to SDL_Event.
   To return SDL_Event have to apply free by received.
*/
SDL_Event* caml_convert_event_m2c(value);
value caml_convert_event_c2m(SDL_Event*);

#endif /* __SDL_EVENT_CONVERT_H__ */
