(**
   This module provide handling OpenGL supports on SDL2.

   @author derui
   @since 0.2
*)
open Sdlcaml_flags

type t = Sdl_types.GLContext.t
type window = Sdl_types.Window.t

val create_context: window -> t Sdl_types.Result.t
(** [create_context window] create and OpenGL context for use with an OpenGL window,
    and make it current.

    Before using OpenGL bindings that are provided by this library should call this.
*)

val delete_context: t -> unit Sdl_types.Result.t
(** [delete_context context] delete an OpenGL context *)

val get_current: unit -> (t * window) Sdl_types.Result.t
(** [get_current ()] get the currently active OpenGL window and context *)

val use_version: ?core_profile:bool -> major:int -> minor:int -> unit -> unit Sdl_types.Result.t
(** [use_version ?core_profile ~major ~minor] set an OpenGL window attributes specialized
    to managet OpenGL version and profile settings.

    Should be called once after the OpenGL context created by [create_context].
*)

val get_attribute: Sdl_gl_attr.t -> int Sdl_types.Result.t
(** [get_attribute attr] get the actual value for an attribute from the current context *)

val set_attribute: attr:Sdl_gl_attr.t -> value:int -> unit Sdl_types.Result.t
(** [set_attribute ~attr ~value] set an OpenGL window attribute before window creation *)

val reset_attributes: unit -> unit
(** [reset_attributes ()] reset all previously set OpenGL context attributes to their default values. *)

val get_swap_interval: unit -> [> `No | `Buffer] Sdl_types.Result.t
(** [get_swap_interval ()] get the swap interval for the current OpenGL context *)

val set_swap_interval: int -> unit Sdl_types.Result.t
(** [set_swap_interval interval] set the swap interval for the current OpenGL context *)

val swap_window: window -> unit
(** [swap_window window] update a window with OpenGL rendering. *)
