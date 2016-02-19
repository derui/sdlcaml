(**
   This module provide lowlevel SDL bindings for SDL Renderer.

   @author derui
   @since 0.2
 *)

open Ctypes
open Sdlcaml_structures

type t = Sdl_types.Renderer.t

exception Sdl_renderer_exception of string

val get_target : t -> Sdl_types.Texture.t Sdl_types.Result.t
(** Get the current render target *)

val create : window:Sdl_types.Window.t -> ?index:int -> flags:Sdlcaml_flags.Sdl_renderer_flags.t list -> unit -> t Sdl_types.Result.t
(**
   Create the renderer for the window given.

   @param window the window to attach renderer was created.
   @param index the index of renderer to create
   @param flags the list of flags for renderer.
   @return the renderer created with parameters.
*)

val create_software : Sdl_types.Surface.t -> t Sdl_types.Result.t
(** create a 2D software rendering context for a surface *)

val destroy : t -> unit Sdl_types.Result.t
(** Destroy the renderer. *)

val get_num_render_drivers : unit -> int
(** Get the number of 2D rendering drivers *)

val get_draw_blend_mode: t -> Sdlcaml_flags.Sdl_blendmode.t Sdl_types.Result.t
(** Get the blend mode used for drawing operations *)

val get_draw_color: t -> Sdlcaml_structures.Color.t Sdl_types.Result.t
(** Get the color used for drawing operations *)

val get_driver_info : int -> Sdlcaml_structures.Renderer_info.t Sdl_types.Result.t
(** Get information about a specific 2D rendering driver for the current display *)

val get : Sdl_types.Window.t -> t Sdl_types.Result.t
(** Get the renderer associated with a window *)

val get_renderer_info :t -> Sdlcaml_structures.Renderer_info.t Sdl_types.Result.t
(** Get information about the renderer *)

val get_output_size :t -> Sdlcaml_structures.Size.t Sdl_types.Result.t
(** Get output size of the renderer *)

val clear : t -> unit Sdl_types.Result.t
(** Clear the renderer *)

val copy : renderer:t -> texture:Sdl_types.Texture.t -> ?src:Sdlcaml_structures.Rect.t ->
  ?dst:Sdlcaml_structures.Rect.t -> unit -> unit Sdl_types.Result.t
(** Copy a portion of the texture to the current rendering target *)

val draw_line: renderer:t -> startp:Point.t -> endp:Point.t -> unit Sdl_types.Result.t
(** Draw a line from start to end to the current rendering target *)

val draw_lines: renderer:t -> points:Point.t list -> unit Sdl_types.Result.t
(** Draw lines from first point of the list to last point of it to the current rendering target *)

val draw_point: renderer:t -> point:Point.t -> unit Sdl_types.Result.t
(** Draw a point on the current rendering target *)

val draw_points: renderer:t -> points:Point.t list -> unit Sdl_types.Result.t
(** Draw points on the current rendering target *)

val draw_rect: renderer:t -> rect:Rect.t -> unit Sdl_types.Result.t
(** Draw a rectangle on the current rendering target *)

val draw_rects: renderer:t -> rects:Rect.t list -> unit Sdl_types.Result.t
(** Draw rectangles on the current rendering target *)

val get_clip_rect: t -> Rect.t
(** Get the clip rectangle for the current target *)

val get_logical_size : t -> Size.t
(** Get device independent resolution for rendering *)

val get_scale: t -> float * float
(** Get the drawing scale for the current target *)

val get_viewport: t -> Rect.t
(** Get the drawing area for the current target *)

val is_clip_enabled: t -> bool
(** Get whether clipping is enabled on the given renderer *)

val present: t -> unit
(** Update the screen with rendering performed *)


val set_clip_rect: renderer:t -> rect:Rect.t -> unit Sdl_types.Result.t
(** Set the clip rectangle for rendering on the specified target *)

val set_logical_size: renderer:t -> size:Size.t -> unit Sdl_types.Result.t
(** Set a device independent resolution for rendering *)

val set_scale: renderer:t -> scale:float * float -> unit Sdl_types.Result.t
(** Set the drawing scale for rendering *)

val set_viewport: renderer:t -> rect:Rect.t -> unit Sdl_types.Result.t
(** Set the drawing area for rendering *)

val is_target_supported: t -> bool
(** Determine whether a window support the use of render targets *)

val set_draw_blend_mode: t -> Sdlcaml_flags.Sdl_blendmode.t -> unit Sdl_types.Result.t
(** Set the blend mode to the renderer *)

val set_draw_color: t-> Sdlcaml_structures.Color.t -> unit Sdl_types.Result.t
(** Set the color used for drawing operations *)

val set_target: renderer:t -> texture:Sdl_types.Texture.t -> unit Sdl_types.Result.t
(** Set a texture as the current rendering target *)
