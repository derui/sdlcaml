(**
 * This module provide low level SDL binding for
 * input management functions for Mouse and Keyboard.
 * If needs to manage joystick, see {!Sdl_joystick}
 *
 * @author derui
 * @since 0.1
 *)

(**
 * State of the mouse Buttons.
 * This type has all mouse button state whether is pressed or released.
 *)
type mouse_button_state = {
  index:int;                            (** mouse button index  *)
  state:Sdl_generic.button_state;       (** current button state  *)
}

(**
 * Returning from {!get_mouse_state}. This only uses to check currently state.
 *)
type mouse_state = {
  x:int; y:int;             (** The X/Y cooridnates function called *)
  button_states:mouse_button_state list  (** see {!mouse_button_state} *)
}

(** Variant for hat values *)
type hat_state =
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
 * Return current snapshot of the current keyboard state.
 * Returning array from this function is {!Sdl_KeyStateMap.state_map} that is
 * mapped key with current state of it.
 * If you get some key state, you can apply {! Map.Make} functions to
 * returning it.
 * Key state is expressed only two state that true is pressed, false is not
 * pressed.
 *
 * @param num number of returing state. default get all current key state
 * @param unit dummy argument
 * @return map for snapshot of the current keyboard state
 *)
external get_key_state: unit -> Sdl_key.state_map
  = "sdlcaml_get_key_state"

(**
 * Get the state of modify keys.
 * States getting from this function is current pressing modifiy keys.
 * Now pressing modify keys when it is included to getting list.
 *
 * @param unit dummy argument
 * @return list of the state of modify keys.
 *)
external get_mod_state: unit -> Sdl_key.modify_key list =
 "sdlcaml_get_mod_state"

(**
   Set the current modify key states.
   This function inverse {!get_mod_state}. Simply pass your desired
   modifier state into modify_key list.

   @param mod_key_list modifier key list
*)
external set_mod_state: Sdl_key.modify_key list -> unit = "sdlcaml_set_mod_state"

(**
 * Enable of disable keyboard repeat rate.
 *
 * {i delay} specifies how long the key must be pressed before it
 * begins repeating, it then repeats at the speed specified by {i
 * interval}.
 * Both {i delay} and {i interval} are expressed in milliseconds.
 *
 * Setting {i delay} to 0, disable key repeating. If you want to
 * restore this setting to default, call {!detault_key_repeat}.
 *
 * @param delay how long key must be pressed
 * @param interval repeat speed
 * @return true if succeeded.
 *)
external enable_key_repeat: delay:int -> interval:int -> bool =
  "sdlcaml_enable_key_repeat"

(**
 * Get the current state of the  mouse.
 * Getting state of the mouse include which are cursot position of
 * mouse as  x and y,
 * and current state of button which pressed or unpressed.
 *
 * If you want to check state of some mouse button, you have to
 * call {! get_mouse_button_state} with this function returned.
 *
 * @return current state of the mouse
 *)
external get_mouse_state: unit -> mouse_state = "sdlcaml_get_mouse_state"
