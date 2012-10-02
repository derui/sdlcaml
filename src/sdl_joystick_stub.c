#include <SDL.h>
#include <SDL_joystick.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/custom.h>

#include "common.h"

/* Encapsulation of opaque SDL surface (of type SDL_Joystick *)
   as Caml custom blocks
 */
static struct custom_operations sdl_joystick_ops = {
  "sdlcaml.sdl_joystick",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default
};

/* Accessing the SDL_Joystick * part of a Caml custom block */
#define Joystick_val(v) (*((SDL_Joystick**)Data_custom_val(v)))

/* Allocating a Caml custom block to hold the given SDL_Joystick *  */
static value alloc_joystick(SDL_Joystick* joystick) {
  value v = alloc_custom(&sdl_joystick_ops, sizeof(SDL_Joystick*), 0, 1);
  Joystick_val(v) = joystick;
  return v;
}

CAMLprim value sdlcaml_num_joystick(value unit) {
  CAMLparam1(unit);

  CAMLreturn(Val_int(SDL_NumJoysticks()));
}

CAMLprim value sdlcaml_joystick_name(value index) {
  CAMLparam1(index);
  CAMLlocal1(name);

  if (Int_val(index) > 0 && Int_val(index) <= SDL_NumJoysticks()) {
    const char* stick_name = SDL_JoystickName(Int_val(index));
    name = caml_copy_string(stick_name);
  } else {
    name = caml_copy_string("");
  }

  CAMLreturn(name);
}

CAMLprim value sdlcaml_joystick_open(value index) {
  CAMLparam1(index);

  SDL_Joystick* joy = SDL_JoystickOpen(Int_val(index));

  if (joy == NULL) {
    CAMLreturn(Val_none);
  } else {
    CAMLreturn(Val_some(alloc_joystick(joy)));
  }
}

CAMLprim value sdlcaml_joystick_close(value joystick) {
  CAMLparam1(joystick);

  SDL_JoystickClose(Joystick_val(joystick));
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_joystick_opened(value index) {
  CAMLparam1(index);

  if (Int_val(index) > 0 && Int_val(index) <= SDL_NumJoysticks()) {
    int opened = SDL_JoystickOpened(Int_val(index));
    CAMLreturn(opened == 1 ? Val_true : Val_false);
  } else {
    CAMLreturn(Val_false);
  }
}

CAMLprim value sdlcaml_joystick_index(value joystick) {
  CAMLparam1(joystick);

  CAMLreturn(Val_int(SDL_JoystickIndex(Joystick_val(joystick))));
}

CAMLprim value sdlcaml_joystick_num_axis(value joystick) {
  CAMLparam1(joystick);

  CAMLreturn(Val_int(SDL_JoystickNumAxes(Joystick_val(joystick))));
}

CAMLprim value sdlcaml_joystick_num_balls(value joystick) {
  CAMLparam1(joystick);

  CAMLreturn(Val_int(SDL_JoystickNumBalls(Joystick_val(joystick))));
}

CAMLprim value sdlcaml_joystick_num_hats(value joystick) {
  CAMLparam1(joystick);

  CAMLreturn(Val_int(SDL_JoystickNumHats(Joystick_val(joystick))));
}

CAMLprim value sdlcaml_joystick_num_buttons(value joystick) {
  CAMLparam1(joystick);

  CAMLreturn(Val_int(SDL_JoystickNumButtons(Joystick_val(joystick))));
}

CAMLprim value sdlcaml_joystick_update(value unit) {
  CAMLparam1(unit);

  SDL_JoystickUpdate();
  CAMLreturn(Val_unit);
}

CAMLprim value sdlcaml_joystick_get_axis(value js, value axis) {
  CAMLparam2(js, axis);
  CAMLreturn(
      Val_int(
          SDL_JoystickGetAxis(Joystick_val(js), Int_val(axis))));
}

static int sdlcaml_hat_list[] = {
  SDL_HAT_CENTERED
  ,SDL_HAT_UP
  ,SDL_HAT_RIGHT
  ,SDL_HAT_DOWN
  ,SDL_HAT_LEFT
  ,SDL_HAT_RIGHTUP
  ,SDL_HAT_RIGHTDOWN
  ,SDL_HAT_LEFTUP
  ,SDL_HAT_LEFTDOWN
};

CAMLprim value sdlcaml_joystick_get_hat(value js, value hat) {
  CAMLparam2(js, hat);
  CAMLlocal1(hats);

  hats = Val_emptylist;

  int raw_hat = SDL_JoystickGetHat(Joystick_val(js), Int_val(hat));

  for (int i = 0 ; i < sizeof(sdlcaml_hat_list); ++i) {
    if (raw_hat & sdlcaml_hat_list[i] ) {
      hats = add_head(hats, Val_int(i));
    }
  }

  CAMLreturn(hats);
}

CAMLprim value sdlcaml_joystick_get_ball(value js, value ball) {
  CAMLparam2(js, ball);
  CAMLlocal1(tuple);
  tuple = caml_alloc(2, 0);

  int x = 0,y = 0;
  SDL_JoystickGetBall(Joystick_val(js), Int_val(ball), &x, &y);
  Store_field(tuple, 0, Val_int(x));
  Store_field(tuple, 1, Val_int(y));
  CAMLreturn(tuple);
}

CAMLprim value sdlcaml_joystick_get_button(value js, value button) {
  CAMLparam2(js, button);
  int state = SDL_JoystickGetButton(Joystick_val(js), Int_val(button));

  CAMLreturn(state == 1?Val_true:Val_false);
}
