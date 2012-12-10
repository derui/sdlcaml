(** Providing SDL Image extention binding. This module is used with
    {!Sdl_video} module.

    @author derui
    @since 0.1
*)

exception Sdl_image_exception of string

(** To be used to SDL_image initialization are mapped bitmask *)
type imageinit =
  | INIT_JPG
  | INIT_PNG
  | INIT_TIF

(** Types for image as a surface *)
type image_type =
  | BMP
  | CUR
  | GIF
  | ICO
  | JPG
  | LBM
  | PCX
  | PNG
  | PNM
  | TGA
  | TIF
  | XCF
  | XPM
  | XV

(** Return status SDL_image is linked.

    @return true if SDL_image linked, false if did not linked.
*)
external is_linked: unit -> bool = "sdlcaml_image_is_linked"

(** Get current version of SDL_image, Linked library and runtime it.

    @return returning tuple as (major, minor, patch)
*)
external linked_version: unit -> int * int * int = "sdlcaml_image_linked_version"
external compile_version: unit -> int * int * int = "sdlcaml_image_version"

(** Initialize by loading support as indicated by the flags.
    see details {{:http://jcatki.no-ip.org:8080/SDL_image/SDL_image_frame.html}
    manual pages of SDL_image}

    @param flags image format to support by loading a library now
    @return Right if all library loading successful. When failed some library return Left with
    error string.
*)
external init: imageinit list -> (unit, string) Extlib.Std.Either.t = "sdlcaml_image_init"

(** This function cleans up all dinamically loaded library handles.
    You only need to call this function once.
*)
external quit: unit -> unit = "sdlcaml_image_quit"

(** Load file for use as an image in a new surface.
    You have to call {!Sdl_video.free_surface} with returned from this function
    end of using or program.

    see details {{:http://jcatki.no-ip.org:8080/SDL_image/SDL_image_frame.html}
    manual pages of SDL_image}

    @param file image file name to load  a surface from
    @return image as a new surface.
    @exception Sdl_image_exception raise if image can not load
*)
external load: string -> Sdl_video.surface option = "sdlcaml_image_load"

(** Load file for use as an image in a new surface.
    Compared to {!load}, this function have to specify type for image to load.

    @param file image file name to load a surface from
    @param type type for image file to load
    @return image as a new surface
    @exception Sdl_image_exception raise if image can not load or type is not equivalence.
*)
external load_typed: string -> image_type -> Sdl_video.surface option = "sdlcaml_image_load_typed"

(** The image is tested to see if it is readable as each format.
    When TGA format is given, always return false from this function.

    @param file image file name to test to see if it is readable
    @param type type of image that you want to test to be readable
    @return true if given file is readable
*)
external is_type: string -> image_type -> bool = "sdlcaml_image_is_type"

(** The image is tested to see if it is readable as each format.
    These functions are specified {!is_type} to each format, so
    you should use {!is_type} rather than these functions.

    @param file image file name to test to see if it is readable
    @return true if given file is readable
*)
val is_cur: string -> bool
val is_ico: string -> bool
val is_bmp: string -> bool
val is_pnm: string -> bool
val is_xpm: string -> bool
val is_xcf: string -> bool
val is_pcx: string -> bool
val is_gif: string -> bool
val is_jpg: string -> bool
val is_tif: string -> bool
val is_png: string -> bool
val is_lbm: string -> bool
val is_xv: string -> bool
