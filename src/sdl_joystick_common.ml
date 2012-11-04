(**
   joystick axis. almost modern joystick has no less than 3 axis and
   more.
   Axis index in the modern joystick are X is 0, Y is 1, Z is 2...
   but few joysticks has different index of axis then use OTHER_AXIS.
*)
type axis =
| X_AXIS
| Y_AXIS
| Z_AXIS
| OTHER_AXIS of int

(** Variant for hat values *)
type hat =
| HAT_CENTERED
| HAT_UP
| HAT_RIGHT
| HAT_DOWN
| HAT_LEFT
| HAT_RIGHTUP
| HAT_RIGHTDOWN
| HAT_LEFTUP
| HAT_LEFTDOWN

(** joystick button state.  *)
type button = {
  num:int;
  state:bool;
}

(**
   Wrapped to raw {b SDL_Joystick}.
*)
type joystick
