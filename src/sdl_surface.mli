(**
   This module provide operation and types for SDL_Surface and relative operations.

   @author derui
   @since 0.2
*)

open Ctypes

type t = Sdl_types.Surface.t

exception Sdl_surface_exception of string
(** A Exception for operations SDL_surface *)

val blit_scaled : src:t -> ?srcrect:Sdlcaml_structures.Rect.t ->
  dst:t -> ?dstrect:Sdlcaml_structures.Rect.t -> unit -> unit Sdl_types.Result.t
(** [blit_scaled ~src ~srcrect ~dst ~destrect] perform a scaled surface copy to a destination surface *)

val blit_surface : src:t -> ?srcrect:Sdlcaml_structures.Rect.t -> dst:t
  -> ?dstrect:Sdlcaml_structures.Rect.t -> unit -> unit Sdl_types.Result.t
(** [blit_surface ~src ~srcrect ~dst ~destrect] perform a fast surface copy to a destination surface.

    {!Remark} if [srcrect] is not passed, this function copy the entire surface to dest.
*)

val convert : src:t -> format:Sdlcaml_structures.Pixel_format.t -> unit -> t Sdl_types.Result.t
(** [convert ~src ~fmt ()] copy an existing surface into a new one that is optimized for blitting to a surfaice
    of a specified pixel format
*)

val convert_format : src:t -> format:Sdlcaml_flags.Sdl_pixel_format_enum.t -> unit -> t Sdl_types.Result.t
(** [convert_format ~src ~fmt ()] copy an existing surface into a new one of a specified pixel format
*)

val fill_rect : dst:t -> ?rect:Sdlcaml_structures.Rect.t -> color:int32 -> unit -> unit Sdl_types.Result.t
(** [fill_rect ~dst ~rect ~color ()] perform a fast fill of a rectangle with a specific color *)

val fill_rects : dst:t -> rects:Sdlcaml_structures.Rect.t list -> color:int32 -> unit Sdl_types.Result.t
(** [fill_rect ~dst ~rects ~color ()] perform a fast fill of a set of rectangles with a specific color *)

val get_clip_rect : t -> Sdlcaml_structures.Rect.t Sdl_types.Result.t
(** [get_clip_rect surface] get the clipping rectangle for a surface *)

val set_clip_rect : surface:t -> rect:Sdlcaml_structures.Rect.t -> unit Sdl_types.Result.t
(** [set_clip_rect ~surface ~rect ()] set the clipping rectangle for a surface *)

val get_color_key : t -> Sdlcaml_structures.Color.t option Sdl_types.Result.t
(** [get_color_key surface] get the color key for a surface *)

val set_color_key : surface:t -> key:Sdlcaml_structures.Color.t -> unit Sdl_types.Result.t
(** [set_color_key ~surface ~key] set the color key for a surface *)

val get_alpha_mod : t -> int Sdl_types.Result.t
(** [get_alpha_mod surface] get the additional alpha value used in blit operations *)

val set_alpha_mod : surface:t -> alpha:int -> unit Sdl_types.Result.t
(** [set_alpha_mod ~surface ~alpha] set the additional alpha value used in blit operations *)

val get_blend_mode : t -> Sdlcaml_flags.Sdl_blendmode.t Sdl_types.Result.t
(** [get_blend_mode surface] get the blend mode used for blit operations *)

val set_blend_mode : surface:t -> mode:Sdlcaml_flags.Sdl_blendmode.t -> unit Sdl_types.Result.t
(** [set_blend_mode ~surface ~mode] set the blend mode used for blit operations *)

val get_color_mod : t -> Sdlcaml_structures.Color.t Sdl_types.Result.t
(** [get_color_mod surface] get the addiotional color value multiplied into blit operations *)

val set_color_mod : surface:t -> color:Sdlcaml_structures.Color.t -> unit Sdl_types.Result.t
(** [set_color_mod ~surface ~color] set the addiotional color value multiplied into blit operations *)

val convert_format : src:t -> fmt:Sdlcaml_flags.Sdl_pixel_format_enum.t -> t Sdl_types.Result.t
(** [convert_surface_format ~src ~fmt] copy an existing surface to a new surface of the specified format *)

val create_argb_surface : width:int -> height:int -> t Sdl_types.Result.t
(** [create_argb_surface ~width ~height] allocate a new ARGB, and depth is 32bit surface.
    Equals to call [create_rgb_surface ~width ~height ~depth:32 ~rmask ~gmask ~bmask ~amask],
    but this function careful thought for endianness of current system.
*)

val free : t -> unit Sdl_types.Result.t
(** [free surface] free allocated memory of the given surface.

    {!Remark} if you create surface via [create_argv_surface] or [creawte_rgb_surface],
    you have to call this function with it.
*)

val lock : t -> unit Sdl_types.Result.t
(** [lock surface] to set up a surface for directly accessing the pixels *)

val unlock : t -> unit Sdl_types.Result.t
(** [unlock surface] to release a surface after directly accessing the pixels *)

val enable_rle : t -> unit Sdl_types.Result.t
(** [enable_rle] to set the RLE acceleration hint for a surface *)

val disable_rle : t -> unit Sdl_types.Result.t
(** [disable_rle] to set disable for the RLE acceleration. *)
