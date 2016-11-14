(**
   Define a module to provide operations for handling game controller and
   for mapping joysticks to game controller semantics.

   @author derui
   @since 0.2
*)

open Ctypes
open Sdlcaml_structures
open Sdlcaml_flags

type t = Sdl_types.GameController.t
(** the type of SDL_GameController *)

type mapping = [ `Button of int | `Hat of (int * Sdlcaml_flags.Sdl_hat.t)| `Axis of int]

val add_mapping: guid:Joystick_guid.t -> name:string ->
  mappings:mapping list -> 
  [> `Added | `Updated] Sdl_types.Result.t
(** [add_mapping ~guid ~name ~mappings] add support for controllers that SDL is unaware of or to
   cause an existing controller to have a different binding.
   The labelled argument that is [name] is the name of mapping for adding this.
*)

val open_controller: int -> (t, 'b) Sdl_types.Resource.t
(** [open_controller index] open a gamecontroller for use with resource monad *)

val from_instance_id: Sdl_joystick.id -> (t, 'b) Sdl_types.Resource.t
(** [from_instance_id id] gget the game controller associated with an instance id  *)

val of_name: t -> string Sdl_types.Result.t
(** [get_name t] get the implementation dependent name for an opened game controller [t]. *)

val of_name_for_index: int -> string Sdl_types.Result.t
(** [get_name_for_index index] get the implementation dependent name for the game controller. *)

val is_attached: t -> bool
(** [is_attached t] check if a controller has been opened and is currently connected *)

val get_axis: t -> axis:Sdl_controller_axis.t -> int
(** [get_axis t ~axis] get the current state of an axis control on a game controller. *)

val get_bind_for_axis: t -> axis:Sdl_controller_axis.t -> Controller_button_bind.t
(** [get_bind_for_axis t ~axis] get the SDL joystick layer binding for a controller button mapping *)

val get_bind_for_button: t -> button:Sdl_game_controller_button.t -> Controller_button_bind.t
(** [get_bind_for_button t ~button] get the SDL joystick layer binding for a controller button mapping *)

val is_pressed: t -> button:Sdl_game_controller_button.t -> bool
(** [get_button t ~button] get the current state of a button on a game controller *)

val with_mapping: t -> f:(string -> 'a) -> 'a
(** [with_mapping t ~f] apply function with the current mapping the current mapping of a game controller.
   This function free a string applied [f] with SDL_free.
*)

val update: unit -> unit
(** [update ()] manually pump game controller updateds if not using the loop. *)

val ignore_events: unit -> unit
(** [ignore_events ()] ignore events dealing with Game controllers. *)

val enable_events: unit -> unit
(** [enable_events ()] enable events dealing with Game controllers. *)

val event_state: unit -> bool
  (* [event_state ()] get the current state of events dealing with game controllers. *)

val is_game_controller: int -> bool
(** [is_game_controller index] check if the given joystick is supported by the game controller interface *)
