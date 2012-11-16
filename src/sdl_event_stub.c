#include <SDL.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/callback.h>
#include "common.h"
#include "sdl_event_trans.h"
#include "sdl_event_convert.h"

CAMLprim value sdlcaml_pump_events(value unit) {
  CAMLparam1(unit);

  SDL_PumpEvents();

  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_poll_event(value unit) {
  CAMLparam1(unit);

  SDL_Event event;
  if (SDL_PollEvent(&event)) {
    CAMLreturn(Val_some(caml_convert_event_c2m(&event)));
  } else {
    CAMLreturn(Val_none);
  }
}

CAMLprim value sdlcaml_wait_event(value unit) {
  CAMLparam1(unit);

  SDL_Event event;
  if (SDL_WaitEvent(&event) >= 0) {
    CAMLreturn(Val_some(caml_convert_event_c2m(&event)));
  } else {
    CAMLreturn(Val_none);
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
    CAMLreturn(Val_some(Int_val(response)));
  } else {
    CAMLreturn(Val_none);
  }
}

CAMLprim value sdlcaml_get_app_state(value unit) {
  CAMLparam1(unit);
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
      event = NULL;
    }
    caml_raise_with_string(*caml_named_value("SDL_event_exception"),
                           SDL_GetError());
  }

  if (event != NULL) {
    free(event);
    event = NULL;
  }

  CAMLreturn(Val_unit);
}
