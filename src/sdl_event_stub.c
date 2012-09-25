#include <SDL.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include "common.h"
#include "sdl_generic.h"
#include "sdl_key_trans.h"
#include "sdl_input_trans.h"

enum EVENTTAG {
  ETAG_ACTIVE      = 0,
  ETAG_KEYDOWN     = 1,
  ETAG_KEYUP       = 2,
  ETAG_MOTION      = 3,
  ETAG_BUTTONDOWN  = 4,
  ETAG_BUTTONUP    = 5,
  ETAG_JAXIS       = 6,
  ETAG_JBALL       = 7,
  ETAG_JHAT        = 8,
  ETAG_JBUTTONDOWN = 9,
  ETAG_JBUTTONUP   = 10,
  ETAG_RESIZE      = 11,
  ETAG_EXPOSE      = 12,
  ETAG_QUIT        = 13,
  ETAG_USER        = 14,
  ETAG_SYSWM       = 15
};

CAMLprim value sdlcaml_pump_events(value unit) {
  CAMLparam0();

  SDL_PumpEvents();

  CAMLnoreturn;
  return Val_unit;
}

value caml_create_active_event(SDL_Event* event) {
  CAMLparam0();
  CAMLlocal2(event_tag, active);
  event_tag     = caml_alloc(1, ETAG_ACTIVE);
  active        = caml_alloc(2, 0);

  Store_field(active, 0, event->active.gain == 1 ? Val_true : Val_false);
  switch (event->active.state) {
    case SDL_APPMOUSEFOCUS: Store_field(active, 1, Val_int(0)); break;
    case SDL_APPINPUTFOCUS: Store_field(active, 1, Val_int(1)); break;
    case SDL_APPACTIVE: Store_field(active, 1, Val_int(2)); break;
    default: caml_invalid_argument("invalid state in SDL_ACTIVEEVENT");
  }

  Store_field(event_tag, 0, active);
  CAMLreturn(event_tag);
}

value caml_create_keyboard_event(SDL_Event* event, int tag) {
  CAMLparam0();
  CAMLlocal4(event_tag, keyboard, keyinfo, modkey);
  event_tag = caml_alloc(1, tag);
  keyboard  = caml_alloc(1, 0);
  keyinfo   = caml_alloc(2, 0);
  modkey    = Val_emptylist;

  /* set data of keysym  */
  Store_field(keyinfo, 0, ml_lookup_from_c(ml_symkey_trans_table,
                                           event->key.keysym.sym));

  /* get current state of the modify keys including pressed now only */
  for (int i = ml_table_size(ml_modkey_trans_table); i > 0; --i) {
    if (event->key.keysym.mod & ml_modkey_trans_table[i].value) {
      modkey = add_head(modkey, Val_int(ml_modkey_trans_table[i].key));
    }
  }
  Store_field(keyinfo, 1, modkey);

  Store_field(keyboard, 0, keyinfo);
  Store_field(event_tag, 0, keyboard);

  CAMLreturn(event_tag);
}

value caml_create_mousemotion_event(SDL_Event* event) {
  CAMLparam0();
  CAMLlocal3(event_tag, motion, button);
  event_tag     = caml_alloc(1, ETAG_MOTION);
  motion        = caml_alloc(5, 0);
  button        = Val_emptylist;

  const int MAX_BUTTON = 32;
  int       button_states[MAX_BUTTON];

  memset(button_states, 0, sizeof(int) * MAX_BUTTON);

  Store_field(motion, 0, Val_int(event->motion.x));
  Store_field(motion, 1, Val_int(event->motion.y));
  Store_field(motion, 2, Val_int(event->motion.xrel));
  Store_field(motion, 3, Val_int(event->motion.yrel));

  /* get mouse state of as many as possible buttons */
  for (int i = MAX_BUTTON; i > 0; --i) {
    CAMLlocal1(state);
    state = caml_alloc(2, 0);
    Store_field(state, 0, Val_int(i));
    Store_field(state, 1, ml_lookup_from_c(ml_generic_button_table,
                                           event->motion.state & SDL_BUTTON(i)));

    button = add_head(button, state);
  }
  Store_field(motion, 4, button);

  Store_field(event_tag, 0, motion);

  CAMLreturn(event_tag);
}

value caml_create_mousebutton_event(SDL_Event* event, int tag) {
  CAMLparam0();
  CAMLlocal3(event_tag, statelist, button);
  event_tag = caml_alloc(1, tag);
  statelist = caml_alloc(3, 0);
  button    = Val_emptylist;

  const int                              MAX_BUTTON = 32;
  int                                    button_states[MAX_BUTTON];
  memset(button_states, 0, sizeof(int) * MAX_BUTTON);

  Store_field(statelist, 0, Val_int(event->button.x));
  Store_field(statelist, 1, Val_int(event->button.y));

  /* get mouse state of as many as possible buttons */
  for (int i = MAX_BUTTON; i > 0; --i) {
    CAMLlocal1(state);
    state = caml_alloc(2, 0);
    Store_field(state, 0, Val_int(i));
    Store_field(state, 1, ml_lookup_from_c(ml_generic_button_table,
                                           event->button.state & SDL_BUTTON(i)));

    button = add_head(button, state);
  }
  Store_field(statelist, 2, button);

  Store_field(event_tag, 0, statelist);

  CAMLreturn(event_tag);
}

value caml_create_joyaxismotion_event(SDL_Event* event) {
  CAMLparam0();
  CAMLlocal2(event_tag, axis);
  event_tag  = caml_alloc(1, ETAG_JAXIS);
  axis = caml_alloc(3, 0);

  Store_field(axis, 0, Val_int(event->jaxis.which));
  Store_field(axis, 1, Val_int(event->jaxis.axis));
  Store_field(axis, 2, Val_int(event->jaxis.value));

  Store_field(event_tag, 0, axis);

  CAMLreturn(event_tag);
}

value caml_create_joyballmotion_event(SDL_Event* event) {
  CAMLparam0();
  CAMLlocal2(event_tag, ball);
  event_tag = caml_alloc(1, ETAG_JBALL);
  ball      = caml_alloc(4, 0);

  Store_field(ball, 0, Val_int(event->jball.which));
  Store_field(ball, 1, Val_int(event->jball.ball));
  Store_field(ball, 2, Val_int(event->jball.xrel));
  Store_field(ball, 3, Val_int(event->jball.yrel));

  Store_field(event_tag, 0, ball);

  CAMLreturn(event_tag);
}

value caml_create_joyhatmotion_event(SDL_Event* event) {
  CAMLparam0();
  CAMLlocal3(event_tag, hat, switchlist);
  event_tag  = caml_alloc(1, ETAG_JHAT);
  hat        = caml_alloc(3, 0);
  switchlist = Val_emptylist;
  int state  = event->jhat.value;

  Store_field(hat, 0, Val_int(event->jhat.which));
  Store_field(hat, 1, Val_int(event->jhat.hat));

  /* check all hat position in current state, but list contains
     only bit masking result of 1.
   */
  for (int i = ml_table_size(ml_joyhat_trans_table); i > 0; --i) {
    if (state & ml_joyhat_trans_table[i].value) {
      switchlist = add_head(switchlist, Val_int(ml_joyhat_trans_table[i].key));
    }
  }
  Store_field(hat, 2, switchlist);

  Store_field(event_tag, 0, hat);

  CAMLreturn(event_tag);
}

value caml_create_joybutton_event(SDL_Event* event, int tag) {
  CAMLparam0();
  CAMLlocal2(event_tag, button);
  event_tag = caml_alloc(1, tag);
  button    = caml_alloc(2, 0);

  Store_field(button, 0, Val_int(event->jbutton.which));
  Store_field(button, 1, Val_int(event->jbutton.button));

  Store_field(event_tag, 0, button);

  CAMLreturn(event_tag);
}

value caml_create_resize_event(SDL_Event* event) {
  CAMLparam0();
  CAMLlocal2(event_tag, resize);
  event_tag = caml_alloc(1, ETAG_RESIZE);
  resize    = caml_alloc(2, 0);

  Store_field(resize, 0, Val_int(event->resize.w));
  Store_field(resize, 1, Val_int(event->resize.h));

  Store_field(event_tag, 0, resize);

  CAMLreturn(event_tag);
}

value caml_create_expose_event(SDL_Event* event) {
  return Val_int(ETAG_EXPOSE);
}

value caml_create_quit_event(SDL_Event* event) {
  return Val_int(ETAG_QUIT);
}

value caml_create_user_event(SDL_Event* event) {
  /* TODO: I have to implement somehow */
  return Val_int(ETAG_USER);
}

value caml_create_syswm_event(SDL_Event* event) {
  /* TODO: I decide to implement or not. */
  return Val_int(ETAG_SYSWM);
}

/* create and return Event Structure for OCaml */
value caml_create_event_struct(SDL_Event *event) {
  switch (event->type) {
    case SDL_ACTIVEEVENT:     return caml_create_active_event(event);
    case SDL_KEYDOWN:         return caml_create_keyboard_event(event, ETAG_KEYDOWN);
    case SDL_KEYUP:           return caml_create_keyboard_event(event, ETAG_KEYUP);
    case SDL_MOUSEMOTION:     return caml_create_mousemotion_event(event);
    case SDL_MOUSEBUTTONDOWN: return caml_create_mousebutton_event(event, ETAG_BUTTONDOWN);
    case SDL_MOUSEBUTTONUP:   return caml_create_mousebutton_event(event, ETAG_BUTTONUP);
    case SDL_JOYAXISMOTION:   return caml_create_joyaxismotion_event(event);
    case SDL_JOYBALLMOTION:   return caml_create_joyballmotion_event(event);
    case SDL_JOYHATMOTION:    return caml_create_joyhatmotion_event(event);
    case SDL_JOYBUTTONDOWN:   return caml_create_joybutton_event(event, ETAG_JBUTTONDOWN);
    case SDL_JOYBUTTONUP:     return caml_create_joybutton_event(event, ETAG_JBUTTONUP);
    case SDL_VIDEORESIZE:     return caml_create_resize_event(event);
    case SDL_VIDEOEXPOSE:     return caml_create_expose_event(event);
    case SDL_QUIT:            return caml_create_quit_event(event);
    case SDL_USEREVENT:       return caml_create_user_event(event);
    case SDL_SYSWMEVENT:      return caml_create_syswm_event(event);
    default:
      caml_invalid_argument("unrecognized event type!");
  }
}

CAMLprim value sdlcaml_poll_event(value unit) {
  CAMLparam0();

  SDL_Event event;
  if (SDL_PollEvent(&event)) {
    CAMLlocal2(event_struct, option);
    event_struct = caml_create_event_struct(&event);

    option = caml_alloc(1,0);
    Store_field(option, 0, event_struct);
    CAMLreturn(option);
  } else {
    CAMLreturn(Val_int(0));
  }
}

CAMLprim value sdlcaml_wait_event(value unit) {
  CAMLparam0();

  SDL_Event event;
  if (SDL_WaitEvent(&event)) {
    CAMLlocal2(event_struct, option);
    event_struct = caml_create_event_struct(&event);

    option = caml_alloc(1,0);
    Store_field(option, 0, event_struct);
    CAMLreturn(option);
  } else {
    CAMLreturn(Val_int(0));
  }
}

CAMLprim value sdlcaml_event_state(value etype, value state) {
  CAMLparam2(etype, state);
  int event_state = SDL_IGNORE;
  switch (Int_val(state)) {
    case 0: event_state = SDL_IGNORE; break;
    case 1: event_state = SDL_ENABLE; break;
    case 2: event_state = SDL_QUERY; break;
    default: caml_invalid_argument("invalid event state in sdlcaml_event_state");
  }

  int event_type = 0;
  switch (Int_val(etype)) {
    case  0: event_type = SDL_ACTIVEEVENT; break;
    case  1: event_type = SDL_KEYDOWN; break;
    case  2: event_type = SDL_KEYUP; break;
    case  3: event_type = SDL_MOUSEMOTION; break;
    case  4: event_type = SDL_MOUSEBUTTONDOWN; break;
    case  5: event_type = SDL_MOUSEBUTTONUP; break;
    case  6: event_type = SDL_JOYAXISMOTION; break;
    case  7: event_type = SDL_JOYBALLMOTION; break;
    case  8: event_type = SDL_JOYHATMOTION; break;
    case  9: event_type = SDL_JOYBUTTONDOWN; break;
    case 10: event_type = SDL_JOYBUTTONUP; break;
    case 11: event_type = SDL_VIDEORESIZE; break;
    case 12: event_type = SDL_VIDEOEXPOSE; break;
    case 13: event_type = SDL_QUIT; break;
    case 14: event_type = SDL_USEREVENT; break;
    case 15: event_type = SDL_SYSWMEVENT; break;
    default: caml_invalid_argument("invalid event type in sdlcaml_event_state");
  }

  /* responce only return if event_state is only SDL_QUERY */
  int response = SDL_EventState(event_type, event_state);
  if (event_state == SDL_QUERY) {
    CAMLlocal1(responce_val);
    responce_val = caml_alloc(1,0);
    Store_field(responce_val, 0, Val_int(response));
    CAMLreturn(responce_val);
  } else {
    CAMLreturn(Val_none);
  }
}

CAMLprim value sdlcaml_get_app_state(value unit) {
  CAMLparam0();
  CAMLlocal1(current_state);
  current_state = Val_emptylist;

  int appstate = SDL_GetAppState();

  if (appstate & SDL_APPMOUSEFOCUS) {
    current_state = add_head(current_state, Val_int(0));
  }

  if (appstate & SDL_APPINPUTFOCUS) {
    current_state = add_head(current_state, Val_int(1));
  }

  if (appstate & SDL_APPACTIVE) {
    current_state = add_head(current_state, Val_int(2));
  }

  CAMLreturn(current_state);
}
