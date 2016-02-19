(**
   Define module to provide Mouse API wrapper and helpers.

   @author derui
   @since 0.1
*)

type system
type original
type current
type 'a t = Sdl_types.Cursor.t
(*** The type of Mouse instance *)

type show_state = [`SHOWN | `HIDDEN]

val enable_capture: unit -> unit Sdl_types.Result.t
(** [enable_capture ()] enable to capture the mouse and to track input outsize an SDL window *)

val disable_capture: unit -> unit Sdl_types.Result.t
(** [disable_capture ()] disable to capture the mouse and to track input outsize an SDL window *)

val create_system_cursor: Sdlcaml_flags.Sdl_system_cursor.t -> system t Sdl_types.Result.t
(** [create_system_cursor system_cursor] create a system cursor of type specified [system_cursor] *)

val free: original t -> unit
(** [free cursor]  *)

val get: unit -> current t option
(** [get ()] return the active cursor, or None if there is no mouse.
   You must not apply [free] with returned cursor from this.
   In this library, can not do it from OCaml via type check.
*)

(** state of the mouse *)
module State : sig
  type t
  val point: t -> Sdlcaml_structures.Point.t
  val states: t -> Sdlcaml_flags.Sdl_mousebutton.t list
end

val get_global_state: unit -> State.t
(** [get_global_state ()] get the current state of the mouse in relation to the desktop *)

val get_focus: unit -> Sdl_types.Window.t option
(** [get_focus ()] get the window which currently has mouse focus.
   Return null if focused window not exists
*)

val get_state: unit -> State.t
(** [get_state ()] get the current state of the mouse in relation to the focus window *)

val get_relative_mode: unit -> bool
(** [get_relative_mode ()] query whether relative mouse mode is enabled *)

val set_relative_mode: bool -> unit Sdl_types.Result.t
(** [set_relative_mode enabled] set relative mouse mode to [enabled] *)

val get_relative_state: unit -> State.t
(** [get_relative_state ()] retrieve the relative state of the mouse *)

val set: 'a t -> unit
(** [set cursor] set the active cursor as [cursor] *)

val show: unit -> show_state Sdl_types.Result.t
(** [show ()] show the cursor. *)

val hide: unit -> show_state Sdl_types.Result.t
(** [hide ()] hide the cursor *)

val is_showing: unit -> show_state Sdl_types.Result.t
(** [is_showing ()] query the current state whether or not the cursor is shown *)

val warp_global: Sdlcaml_structures.Point.t -> unit Sdl_types.Result.t
(** [warp_global point] move the mouse to the given position in global screen space *)

val warp_in_window: Sdlcaml_structures.Point.t -> unit Sdl_types.Result.t
(** [warp_in_window point] move the mouse to the given position within the window what is current mouse focus*)
