(**
   This module provide operation and types for operations for pixel manipulation.

   @author derui
   @since 0.2
*)
open Ctypes

val get_pixel_format_name : Sdlcaml_flags.Sdl_pixel_format_enum.t -> string
(** [!get_pixel_format_name format] to get the human readable name of a pixel format *)

val get_rgb: pixel:int32 -> format:Sdlcaml_structures.Pixel_format.t -> Sdlcaml_structures.Color.t
(** [get_rgb ~pixel ~format] to get RGB values from a pixel in the specified format *)

val map_rgb : format:Sdlcaml_structures.Pixel_format.t -> color:Sdlcaml_structures.Color.t -> int32
(** [!map_rgb ~format ~color] to map RGB triple to an opaque pixel value for a given pixel format *)

val map_rgba : format:Sdlcaml_structures.Pixel_format.t -> color:Sdlcaml_structures.Color.t -> int32
(** [!map_rgba ~format ~color] to map RGB triple to an opaque pixel value for a given pixel format *)
