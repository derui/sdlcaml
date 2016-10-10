(**
 * This module provide lowlevel SDL bindings for SDL WM. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

open Ctypes

(** A type of the window that was created via {Sdl_window.create}. *)
type id = int32
type t = Sdl_types.Window.t

exception Sdl_window_exception of string

val create : title:string -> x:int -> y:int -> w:int -> h:int
  -> flags:[> Sdlcaml_flags.Sdl_window_flags.t] list -> (t, 'b) Sdl_types.Resource.t
(** [create ~title ~x ~y ~w ~h ~flags] create a widnow with the
    specified position, dimensions, and flags.

    @param title title of a window created
    @param x a position of x of a window created
    @param y a position of y of a window created
    @param w a width of a window created
    @param h a height of a window created
    @param flags Some flags to specify the window behavioies.
    @return the window that was created. If creation is fail, return None; call {Common.get_error} for more information.
*)

val get_brightness : t -> float
(** Get brightness of the window *)

val get_display_index : t -> int
(** Get display index of the window *)

val get_display_mode : t -> Sdlcaml_structures.Display_mode.t
(** Get display mode of the window *)

val get_window_flags : t -> Sdlcaml_flags.Sdl_window_flags.t list
(** Get window flags of the window *)

val get_from_id : id -> t
(** Get the window from window id *)

val get_gamma_ramp : t -> Sdlcaml_structures.Gamma_ramp.t

val get_grab : t -> bool
(** Get a window's input grab mode *)

val get_id : t -> id
(** Get the numeric ID of a window *)

val get_maximum_size : t -> Sdlcaml_structures.Size.t
(** Get maximum size of a window *)

val get_minimum_size : t -> Sdlcaml_structures.Size.t
(** Get minimum size of a window *)

val get_pixel_format : t -> Sdlcaml_flags.Sdl_pixel_format_enum.t


val get_position : t -> Sdlcaml_structures.Point.t
(** Get the position of a window *)

val get_size : t -> Sdlcaml_structures.Size.t
(** Get the size of a window *)

val get_surface : t -> Sdl_types.Surface.t
(** Get the SDL surface associated with the window *)

val get_title : t -> string
(** Get the title of a window *)

val get_window_wm_info : t -> Sdlcaml_structures.Sys_wm_info.t
(** Get driver specific information about a window *)

val hide : t -> unit
val show : t -> unit

val maximize : t -> unit
val minimize : t -> unit
val to_raise : t -> unit
val restore: t -> unit

val set_bordered : t -> bool -> unit
(** Set window bordered parameter *)

val set_brightness : t -> float -> unit
(** Set window brightness *)

val set_display_mode : t -> Sdlcaml_structures.Display_mode.t -> unit
(** Set window display mode *)

val set_fullscreen : t -> unit
(** Set to fullscreen of window display *)

val set_fullscreen_desktop : t -> unit
(** Set to fullscreen for desktop of window display *)

val set_gamma_ramp : t -> Sdlcaml_structures.Gamma_ramp.t -> unit
(** Set the gamma ramp for a window *)

val grab_input : t -> unit
(** Set a window's input grab mode to grab input *)

val release_input : t -> unit
(** Set a window's input grab mode to release input *)

val set_icon : t -> Sdl_surface.t -> unit
(** Set the icon for a window *)

val set_maximum_size : t -> Sdlcaml_structures.Size.t -> unit
(** Set the maximum size of a window's client area *)

val set_minimum_size : t -> Sdlcaml_structures.Size.t -> unit
(** Set the minimum size of a window's client area *)

val set_position : t -> Sdlcaml_structures.Point.t -> unit
(** Set the position of a window *)

val set_size : t -> Sdlcaml_structures.Size.t -> unit
(** Set the size of a window *)

val set_title : t -> string -> unit
(** Set the title of a window *)

val update_surface : t -> unit
(** Copy the window surface to the screen *)

val update_surface_rects : t -> Sdlcaml_structures.Rect.t list -> unit
(** Copy areas of the window surface to the screen *)
