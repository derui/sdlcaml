exception Sdl_image_exception of string

type imageinit =
  | INIT_JPG
  | INIT_PNG
  | INIT_TIF

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

external linked_version: unit -> int * int * int = "sdlcaml_image_linked_version"
external compile_version: unit -> int * int * int = "sdlcaml_image_version"

external init: imageinit list -> (unit, string) Extlib.Std.Either.t = "sdlcaml_image_init"

external quit: unit -> unit = "sdlcaml_image_quit"

external load: string -> Sdl_video.surface option = "sdlcaml_image_load"

external load_typed: string -> image_type -> Sdl_video.surface option = "sdlcaml_image_load_typed"

external is_type: string -> image_type -> bool = "sdlcaml_image_is_type"

let is_cur f = is_type f CUR
let is_ico f = is_type f ICO
let is_bmp f = is_type f BMP
let is_pnm f = is_type f PNG
let is_xpm f = is_type f XPM
let is_xcf f = is_type f XCF
let is_pcx f = is_type f PCX
let is_gif f = is_type f GIF
let is_jpg f = is_type f JPG
let is_tif f = is_type f TIF
let is_png f = is_type f PNG
let is_lbm f = is_type f LBM
let is_xv f  = is_type f XV
