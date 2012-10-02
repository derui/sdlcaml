(**
 * this module provide lowlevel SDL bindings for SDL Joystick. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

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


(**
   Wrapped to raw {b SDL_Joystick}.
*)
type joystick

(**
   Get counts the number of joysticks attached to the system

   @return the number of attached joysticks
*)
external get_num: unit -> int = "sdlcaml_num_joystick"

(**
   Get implementation dependent name of joystick. Tne {!index}
   parameter refers to the N'th joystick on the system.

   @param index refer N'th joystick
   @return joystick name
*)
external get_name: int -> string = "sdlcaml_joystick_name"

(**
   Open a joystick for use within SDL.
   Returned joystick from this function have to apply
   to {!joystick_close} end of program or unwanted.

   @param index index refers to N'th joystick in the system
   @return return Some if on success
*)
external joystick_open:int -> joystick option =
  "sdlcaml_joystick_open"

(**
   Closes a previously opened joystick.

   @param joystick opened joystick
*)
external joystick_close:joystick -> unit = "sdlcaml_joystick_close"

(**
   Determine if a joystick has been opened.

   @param index refers to the N'th joystick on the system
   @return true if the joystick has been opened
*)
external opened: int -> bool = "sdlcaml_joystick_opened"

(**
   Get the index of given joystick.

   @param joystick opened joystick
   @return index number of the joystick
*)
external index: joystick -> int = "sdlcaml_joystick_index"

(**
   Get the number of joystick axis.

   @param joystick previously opened joystick
   @return axis number of the joystick
*)
external num_axis: joystick -> int = "sdlcaml_joystick_num_axis"

(**
   Get the number of joystick trackballs.

   @param joystick previously opened joystick
   @return trackball number of the joystick
*)
external num_balls: joystick -> int = "sdlcaml_joystick_num_balls"

(**
   Get the number of joystick hats.

   @param joystick previously opened joystick
   @return hats number of the joystick
*)
external num_hats: joystick -> int = "sdlcaml_joystick_num_hats"

(**
   Get the number of joystick buttons.

   @param joystick previously opened joystick
   @return buttons number of the joystick
*)
external num_buttons: joystick -> int = "sdlcaml_joystick_num_buttons"

(**
   Update the state(position, buttons, etc.) of all open joysticks.
   If joystick events have been enabled with {!event_state} then this is
   called automatically in the event loop
*)
external update: unit -> unit = "sdlcaml_joystick_update"

(**
   Get the current state of an axis. The value returned by this
   function is a signed int of 16bit representing the current position
   of the axis.

   @param js a joystick
   @param axis any {!axis} to want to take.
   @return current state of an axis
*)
external get_axis: js:joystick -> axis:axis -> int = "sdlcaml_joystick_get_axis"

(**
   Get the current state of a joystick hat.

   @param js joystick
   @param hat index of hat on joystick
   @return one or more listed {!hat}
*)
external get_hat: js:joystick -> hat:int -> hat list = "sdlcaml_joystick_get_hat"

(**
   Get relative trackball motion.
   Return relative motion since the last call this, these motion are
   tuple as (dx, dy).

   @param js joystick is surmounted by trackball
   @param ball index of trackball on the joystick
   @return relative motion since the last call this.
*)
external get_ball: js:joystick -> ball:int -> int * int = "sdlcaml_joystick_get_ball"

(**
   Get the current state of a given button on a given joystick.

   @param js joystick
   @param button number of button on the joystick
   @return true if pressed, false if released
*)
external get_button: js:joystick -> button:int -> bool = "sdlcaml_joystick_get_button"
