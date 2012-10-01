#include <SDL.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>

#include "common.h"
#include "sdl_generic_flags.h"
#include "sdl_key_trans.h"
#include "sdl_input_trans.h"
#include "sdl_event_trans.h"
#include "sdl_event_convert.h"

value caml_convert_c2m_active_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal3(event_tag, active, states);
  event_tag     = caml_alloc(1, Int_val(tag));
  active        = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);
  states = Val_emptylist;

  Store_field(active, EVENT_STRUCT_GAIN,
              event->active.gain == 1 ? Val_true : Val_false);

  if (event->active.state & SDL_APPMOUSEFOCUS) {
    states = add_head(states, Val_int(0));
  }

  if (event->active.state & SDL_APPINPUTFOCUS) {
    states = add_head(states, Val_int(1));
  }

  if (event->active.state & SDL_APPACTIVE) {
    states = add_head(states, Val_int(2));
  }
  Store_field(active, EVENT_STRUCT_APP_STATE, states);

  Store_field(event_tag, 0, active);
  CAMLreturn(event_tag);
}

value caml_convert_c2m_keyboard_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal4(event_tag, keyboard, keyinfo, modkey);
  event_tag = caml_alloc(1, Int_val(tag));
  keyboard  = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);
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

  Store_field(keyboard, EVENT_STRUCT_KEYSYM, keyinfo);
  Store_field(event_tag, 0, keyboard);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_mousemotion_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal3(event_tag, motion, button);
  event_tag     = caml_alloc(1, Int_val(tag));
  motion        = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);
  button        = Val_emptylist;

  const int MAX_BUTTON = 32;

  Store_field(motion, EVENT_STRUCT_X, Val_int(event->motion.x));
  Store_field(motion, EVENT_STRUCT_Y, Val_int(event->motion.y));
  Store_field(motion, EVENT_STRUCT_RELX, Val_int(event->motion.xrel));
  Store_field(motion, EVENT_STRUCT_RELY, Val_int(event->motion.yrel));

  /* get mouse state of as many as possible buttons if it pressed only.
   */
  for (int i = MAX_BUTTON; i > 0; --i) {
    CAMLlocal1(state);
    if (event->motion.state & SDL_BUTTON(i)) {
      state = caml_alloc(2, 0);
      Store_field(state, 0, Val_int(i));
      Store_field(state, 1, ml_lookup_from_c(ml_generic_button_table,
                                             event->motion.state & SDL_BUTTON(i)));

      button = add_head(button, state);
    }
  }
  Store_field(motion, EVENT_STRUCT_BUTTON_STATE, button);

  Store_field(event_tag, 0, motion);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_mousebutton_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal2(event_tag, statelist);
  event_tag = caml_alloc(1, Int_val(tag));
  statelist = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);

  Store_field(statelist, EVENT_STRUCT_X, Val_int(event->button.x));
  Store_field(statelist, EVENT_STRUCT_Y, Val_int(event->button.y));
  Store_field(statelist, EVENT_STRUCT_INDEX, Val_int(event->button.button));

  Store_field(event_tag, 0, statelist);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_joyaxismotion_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal2(event_tag, axis);
  event_tag  = caml_alloc(1, Int_val(tag));
  axis = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);

  Store_field(axis, EVENT_STRUCT_INDEX, Val_int(event->jaxis.which));
  Store_field(axis, EVENT_STRUCT_AXIS, Val_int(event->jaxis.axis));
  Store_field(axis, EVENT_STRUCT_VALUE, Val_int(event->jaxis.value));

  Store_field(event_tag, 0, axis);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_joyballmotion_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal2(event_tag, ball);
  event_tag = caml_alloc(1, Int_val(tag));
  ball      = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);

  Store_field(ball, EVENT_STRUCT_INDEX, Val_int(event->jball.which));
  Store_field(ball, EVENT_STRUCT_BALL, Val_int(event->jball.ball));
  Store_field(ball, EVENT_STRUCT_RELX, Val_int(event->jball.xrel));
  Store_field(ball, EVENT_STRUCT_RELY, Val_int(event->jball.yrel));

  Store_field(event_tag, 0, ball);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_joyhatmotion_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal3(event_tag, hat, switchlist);
  event_tag  = caml_alloc(1, Int_val(tag));
  hat        = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);
  switchlist = Val_emptylist;
  int state  = event->jhat.value;

  Store_field(hat, EVENT_STRUCT_INDEX, Val_int(event->jhat.which));
  Store_field(hat, EVENT_STRUCT_HAT, Val_int(event->jhat.hat));

  /* check all hat position in current state, but list contains
     only bit masking result of 1.
  */
  for (int i = ml_table_size(ml_joyhat_trans_table); i > 0; --i) {
    if (state & ml_joyhat_trans_table[i].value) {
      switchlist = add_head(switchlist, Val_int(ml_joyhat_trans_table[i].key));
    }
  }
  Store_field(hat, EVENT_STRUCT_HAT_STATE, switchlist);

  Store_field(event_tag, 0, hat);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_joybutton_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal2(event_tag, button);
  event_tag = caml_alloc(1, Int_val(tag));
  button    = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);

  Store_field(button, EVENT_STRUCT_INDEX, Val_int(event->jbutton.which));
  Store_field(button, EVENT_STRUCT_BUTTON, Val_int(event->jbutton.button));

  Store_field(event_tag, 0, button);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_resize_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLlocal2(event_tag, resize);
  event_tag = caml_alloc(1, Int_val(tag));
  resize    = caml_alloc(EVENT_STRUCT_FIELD_NUM, 0);

  Store_field(resize, EVENT_STRUCT_WIDTH, Val_int(event->resize.w));
  Store_field(resize, EVENT_STRUCT_HEIGHT, Val_int(event->resize.h));

  Store_field(event_tag, 0, resize);

  CAMLreturn(event_tag);
}

value caml_convert_c2m_expose_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLreturn(tag);
}

value caml_convert_c2m_quit_event(SDL_Event* event, value tag) {
  CAMLparam1(tag);
  CAMLreturn(tag);
}

value caml_convert_c2m_user_event(SDL_Event* event, value tag) {
  /* TODO: I have to implement somehow */
  CAMLparam1(tag);
  CAMLreturn(tag);
}

value caml_convert_c2m_syswm_event(SDL_Event* event, value tag) {
  /* TODO: I decide to implement or not. */
  CAMLparam1(tag);
  CAMLreturn(tag);
}

typedef value (*convert_c2m)(SDL_Event* , value);
/* indexed MLTAG_* value in sdl_event_trans.h */
generic_lookup_info conversion_c2m_funcs[] = {
  {16                                   , 0},
  {SDL_ACTIVEEVENT                      , caml_convert_c2m_active_event        },
  {SDL_KEYDOWN                          , caml_convert_c2m_keyboard_event      },
  {SDL_KEYUP                            , caml_convert_c2m_keyboard_event      },
  {SDL_MOUSEMOTION                      , caml_convert_c2m_mousemotion_event   },
  {SDL_MOUSEBUTTONDOWN                  , caml_convert_c2m_mousebutton_event   },
  {SDL_MOUSEBUTTONUP                    , caml_convert_c2m_mousebutton_event   },
  {SDL_JOYAXISMOTION                    , caml_convert_c2m_joyaxismotion_event },
  {SDL_JOYBALLMOTION                    , caml_convert_c2m_joyballmotion_event },
  {SDL_JOYHATMOTION                     , caml_convert_c2m_joyhatmotion_event  },
  {SDL_JOYBUTTONUP                      , caml_convert_c2m_joybutton_event     },
  {SDL_JOYBUTTONDOWN                    , caml_convert_c2m_joybutton_event     },
  {SDL_VIDEORESIZE                      , caml_convert_c2m_resize_event        },
  {SDL_VIDEOEXPOSE                      , caml_convert_c2m_expose_event        },
  {SDL_QUIT                             , caml_convert_c2m_quit_event          },
  {SDL_USEREVENT                        , caml_convert_c2m_user_event          },
  {SDL_SYSWMEVENT                       , caml_convert_c2m_syswm_event         },
};

/* create and return Event Structure for OCaml */
value caml_convert_event_c2m(SDL_Event *event) {
  CAMLparam0();
  CAMLlocal1(type);
  if (event == NULL) {
    caml_invalid_argument("invalid event received : caml_convert_event_c2m");
  }

  /* this type is value of MLTAG_* in sdl_event_trans.h.
     Nevertheless, this function switching is based on MLTAG_* value,
     I think bad of it...
  */

  type = ml_lookup_from_c(ml_event_tag_table, event->type);
  convert_c2m func = (convert_c2m)ml_generic_lookup(conversion_c2m_funcs,
                                                    event->type);
  CAMLreturn((*func)(event, type));
}

/*******************************************************************/
/* convert event to SDL_Event */

SDL_Event* caml_convert_m2c_active_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_ACTIVEEVENT;
  e->active.gain = Int_val(Field(ml_event, EVENT_STRUCT_GAIN));
  e->active.state = 0;

  value state_list = Field(ml_event, EVENT_STRUCT_APP_STATE);
  while (is_not_nil(state_list)) {
    switch (Int_val(head(state_list))) {
      case 0: e->active.state |= SDL_APPMOUSEFOCUS; break;
      case 1: e->active.state |= SDL_APPINPUTFOCUS; break;
      case 2: e->active.state |= SDL_APPACTIVE; break;
    }

    state_list = tail(state_list);
  }

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_keyup_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_KEYUP;
  e->key.state = SDL_RELEASED;

  e->key.keysym.sym = 0;
  e->key.keysym.mod = KMOD_NONE;

  value synonym = Field(Field(ml_event, EVENT_STRUCT_KEYSYM), 0);
  e->key.keysym.sym = ml_lookup_to_c(ml_symkey_trans_table, synonym);

  value mod_list = Field(Field(ml_event, EVENT_STRUCT_KEYSYM), 1);
  while (is_not_nil(mod_list)) {
    e->key.keysym.mod |= ml_lookup_to_c(ml_modkey_trans_table,
                                        head(mod_list));
    mod_list = tail(mod_list);
  }

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_keydown_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_KEYDOWN;
  e->key.state = SDL_PRESSED;

  e->key.keysym.sym = 0;
  e->key.keysym.mod = KMOD_NONE;

  value synonym = Field(Field(ml_event, EVENT_STRUCT_KEYSYM), 0);
  e->key.keysym.sym = ml_lookup_to_c(ml_symkey_trans_table, synonym);

  value mod_list = Field(Field(ml_event, EVENT_STRUCT_KEYSYM), 1);
  while (is_not_nil(mod_list)) {
    e->key.keysym.mod |= ml_lookup_to_c(ml_modkey_trans_table,
                                        head(mod_list));
    mod_list = tail(mod_list);
  }

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_mousemotion_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_MOUSEMOTION;

  const int MAX_BUTTON = 32;

  e->motion.x = Int_val(Field(ml_event, EVENT_STRUCT_X));
  e->motion.y = Int_val(Field(ml_event, EVENT_STRUCT_Y));
  e->motion.xrel = Int_val(Field(ml_event, EVENT_STRUCT_RELX));
  e->motion.yrel = Int_val(Field(ml_event, EVENT_STRUCT_RELY));

  value button_state = Field(ml_event, EVENT_STRUCT_BUTTON_STATE);
  while (is_not_nil(button_state)) {
    value hd = head(button_state);
    int num = Int_val(hd);
    int state = ml_lookup_to_c(ml_generic_button_table, Field(hd, 1));

    if (num >= MAX_BUTTON || num < 1) {
      /* do nothing */
    } else if (state) {
      e->motion.state |= SDL_BUTTON(num);
    } else {
      e->motion.state &= !SDL_BUTTON(num);
    }

    button_state = tail(button_state);
  }

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_mousebuttonup_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_MOUSEBUTTONUP;
  e->button.x = Int_val(Field(ml_event, EVENT_STRUCT_X));
  e->button.y = Int_val(Field(ml_event, EVENT_STRUCT_Y));
  e->button.button = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_mousebuttondown_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_MOUSEBUTTONDOWN;
  e->button.x = Int_val(Field(ml_event, EVENT_STRUCT_X));
  e->button.y = Int_val(Field(ml_event, EVENT_STRUCT_Y));
  e->button.button = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_joyaxismotion_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_JOYAXISMOTION;

  e->jaxis.which = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));
  e->jaxis.axis  = Int_val(Field(ml_event, EVENT_STRUCT_AXIS));
  e->jaxis.value = Int_val(Field(ml_event, EVENT_STRUCT_VALUE));

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_joyballmotion_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_JOYBALLMOTION;

  e->jball.which = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));
  e->jball.ball  = Int_val(Field(ml_event, EVENT_STRUCT_BALL));
  e->jball.xrel  = Int_val(Field(ml_event, EVENT_STRUCT_RELX));
  e->jball.yrel  = Int_val(Field(ml_event, EVENT_STRUCT_RELY));

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_joyhatmotion_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e  = malloc(sizeof(SDL_Event));
  e->type       = SDL_JOYHATMOTION;;
  e->jhat.which = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));
  e->jhat.hat   = Int_val(Field(ml_event, EVENT_STRUCT_HAT));

  Uint8 hatbutton_value = 0;

  /* restore hat switch value from OCaml value */
  value hatbutton = Field(ml_event, EVENT_STRUCT_HAT_STATE);
  while (is_not_nil(hatbutton)) {
    hatbutton_value |= ml_lookup_to_c(ml_event_tag_table, head(hatbutton));
    hatbutton = tail(hatbutton);
  }

  e->jhat.value = hatbutton_value;

  CAMLreturnT(SDL_Event*, e);
}

/* TODO: integrate jbuttondown/up function some day... */
SDL_Event* caml_convert_m2c_jbuttondown_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_JOYBUTTONDOWN;

  e->jbutton.which = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));
  e->jbutton.button = Int_val(Field(ml_event, EVENT_STRUCT_BUTTON));

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_jbuttonup_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_JOYBUTTONUP;

  e->jbutton.which = Int_val(Field(ml_event, EVENT_STRUCT_INDEX));
  e->jbutton.button = Int_val(Field(ml_event, EVENT_STRUCT_BUTTON));

  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_resize_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_VIDEORESIZE;

  e->resize.w = Int_val(Field(ml_event, EVENT_STRUCT_WIDTH));
  e->resize.h = Int_val(Field(ml_event, EVENT_STRUCT_HEIGHT));
  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_expose_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));

  e->type = SDL_VIDEOEXPOSE;
  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_quit_event(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_QUIT;
  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_user_event(value ml_event) {
  /* TODO: I have to implement somehow */
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_USEREVENT;
  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_m2c_syswm_event(value ml_event) {
  /* TODO: I decide to implement or not. */
  CAMLparam1(ml_event);
  SDL_Event* e = malloc(sizeof(SDL_Event));
  e->type = SDL_SYSWMEVENT;
  CAMLreturnT(SDL_Event*, e);
}

SDL_Event* caml_convert_event_m2c(value ml_event) {
  CAMLparam1(ml_event);
  SDL_Event* event = NULL;

  if (Is_long(ml_event)) {
    switch (Int_val(ml_event)) {
      case MLTAG_EXPOSE: event = caml_convert_m2c_expose_event(ml_event);
        break;
      case MLTAG_QUIT: event   = caml_convert_m2c_quit_event(ml_event); break;
    }
  } else {
    value e_struct = Field(ml_event, 0);
    switch (Tag_val(ml_event)) {
      case MLTAG_ACTIVE: event      = caml_convert_m2c_active_event(e_struct); break;
      case MLTAG_KEYDOWN: event     = caml_convert_m2c_keydown_event(e_struct); break;
      case MLTAG_KEYUP: event       = caml_convert_m2c_keyup_event(e_struct); break;
      case MLTAG_MOTION: event      = caml_convert_m2c_mousemotion_event(e_struct); break;
      case MLTAG_BUTTONDOWN: event  = caml_convert_m2c_mousebuttondown_event(e_struct); break;
      case MLTAG_BUTTONUP: event    = caml_convert_m2c_mousebuttonup_event(e_struct); break;
      case MLTAG_JAXIS: event       = caml_convert_m2c_joyaxismotion_event(e_struct); break;
      case MLTAG_JBALL: event       = caml_convert_m2c_joyballmotion_event(e_struct); break;
      case MLTAG_JHAT: event        = caml_convert_m2c_joyhatmotion_event(e_struct); break;
      case MLTAG_JBUTTONDOWN: event = caml_convert_m2c_jbuttondown_event(e_struct); break;
      case MLTAG_JBUTTONUP: event   = caml_convert_m2c_jbuttonup_event(e_struct); break;
      case MLTAG_RESIZE: event      = caml_convert_m2c_resize_event(e_struct); break;
      case MLTAG_USER: event        = caml_convert_m2c_user_event(e_struct); break;
      case MLTAG_SYSWM: event       = caml_convert_m2c_syswm_event(e_struct); break;
    }
  }

  CAMLreturnT(SDL_Event*, event);
}
