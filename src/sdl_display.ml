(**
   This module provide some funcitons to operate for display.

   @author derui
   @since 0.2
*)

(** The display mode *)
type display_mode = {
  format : Sdl_pixel_format_enum;
  width : int;
  height : int;
  refresh_rate : int;
}

(** The rect structure *)
type rect = {
  x : int;
  y : int;
  w : int;
  h : int;
}

exception Sdl_display_exception of string

external disable_screen_saver : unit -> unit = "sdlcaml_display_disable_screen_saver"
(**
   Disable screen saver
*)

external enable_screen_saver : unit -> unit = "sdlcaml_display_disable_screen_saver"
(**
   Enable screen saver
*)

external get_desktop_display_mode : int -> display_mode = "sdlcaml_display_get_desktop_display_mode"
(**
 Get information abount the desktop display mode.

   @param index the display index to get information
   @return the mode of display
*)

external get_current_display_mode : int -> display_mode = "sdlcaml_display_get_current_display_mode"
(**
   Get information about the current display mode.

   @param index the display index to get information
   @return the mode of display
*)

external get_display_bounds : int -> rect = "sdlcaml_display_get_display_bounds"
(** Get the bounds of the window index *)

external get_display_mode : display:int -> mode:int -> unit -> display_mode =
  "sdlcaml_display_get_display_mode"
(** Get information about the display index and display mode. *)

external get_display_name : int -> string
(** Get the name of a display *)

external get_num_display_modes : int -> int = "sdlcaml_display_get_num_display_modes"
(** Get numbers of display modes *)

external get_num_video_displays : unit -> int = "sdlcaml_display_get_num_video_displays"
(** Get numbers of video displays *)

external get_num_video_drivers : unit -> int = "sdlcaml_display_get_num_video_drivers"
(** Get numbers of video drivers *)

external get_video_driver : int -> string = "sdlcaml_display_get_video_driver"
(** Get name of the driver to be index *)
