(**
 * this module provide lowlevel SDL bindings for Mouse. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(**
   variant for some mouse button. These variant is pair of
   that correspond each SDL's mouse button.
   {!MOUSE_X} is for extra mouse buttons.
*)
type button =
| MOUSE_LEFT
| MOUSE_MIDDLE
| MOUSE_RIGHT
| MOUSE_WHEELUP
| MOUSE_WHEELDOWN
| MOUSE_X of int

(**
 * State of the mouse Buttons.
 * This type has all mouse button state whether is pressed or released.
 *)
type mouse_button_state = {
  index:button;                            (** mouse button index  *)
  state:Sdl_generic.button_state;       (** current button state  *)
}

(**
 * Returning from {!get_mouse_state}. This only uses to check currently state.
 *)
type mouse_state = {
  x:int; y:int;             (** The X/Y cooridnates function called *)
  button_states:mouse_button_state list  (** see {!mouse_button_state} *)
}

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
