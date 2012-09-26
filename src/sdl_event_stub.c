#include <SDL.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include "common.h"
#include "sdl_generic.h"
#include "sdl_event_trans.h"
#include "sdl_event_convert.h"

CAMLprim value sdlcaml_pump_events(value unit) {
  CAMLparam0();

  SDL_PumpEvents();

  CAMLnoreturn;
  return Val_unit;
}

CAMLprim value sdlcaml_poll_event(value unit) {
  CAMLparam0();

  SDL_Event event;
  if (SDL_PollEvent(&event)) {
    CAMLlocal2(event_struct, option);
    event_struct = caml_convert_event_c2m(&event);

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
    event_struct = caml_convert_event_c2m(&event);

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

  int event_type = ml_lookup_to_c(ml_event_tag_table, etype);

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

CAMLprim value sdlcaml_push_event(value ml_event) {
  CAMLparam1(ml_event);

  SDL_Event* event = caml_convert_event_m2c(ml_event);

  if (SDL_PushEvent(event)) {
    if (event != NULL) {
      free(event);
    }
    caml_raise_with_string(caml_named_value("SDL_event_exception"),
                           SDL_GetError());
  }

  if (event != NULL) {
    free(event);
  }

  CAMLnoreturn;
  return Val_unit;
}
