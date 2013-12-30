(**
   Define a module to provide operations for handling keyboard inputs.

   @author derui
   @since 0.2
*)

open Sdlcaml_flags

val get_key_from_name: string -> Sdl_keycode.t Sdl_types.Result.t
(* [get_key_from_name name] get a key code from a human-readble name *)

val get_key_from_scan_code: Sdl_scancode.t -> Sdl_keycode.t
(* [get_key_from_scan_code scancode] get a key code from a [scancode] *)

val get_name: Sdl_keycode.t -> string
(* [get_name keycode] get a human-readble name of a [keycode] *)

val get_keyboard_focus: unit -> Sdl_types.Window.t
(* [get_keyboard_focus ()] get the window which currently has keyboard focus. *)

val is_pressed: Sdl_scancode.t -> bool
(* [is_pressed scancode] get current state of [scancode] that is pressed or not. *)

val is_released: Sdl_scancode.t -> bool
(* [is_released scancode] get current state of [scancode] that is released or not. *)

val get_mod_state: unit -> Sdl_keymod.t
(* [get_mod_state ()] get the current key modifier state for the keyboard. *)

val has_screen_keyboard_support: unit -> bool
(* [has_screen_keyboard_support ()] check whether the platform has some screen keyboard support. *)

val is_screen_keyboard_shown: Sdl_types.Window.t -> bool
(* [is_screen_keyboard_shown w] check whether the screen keyboard is shown for given window. *)

val is_text_input_active: unit -> bool
(* [is_text_input_active ()] check whether or not Unicode text input events are enabled *)

val start_text_input: unit -> unit
(* [start_text_input ()] start accepting Unicode text input events *)

val stop_text_input: unit -> unit
(* [stop_text_input ()] stop receiving any text input events *)
