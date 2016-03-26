open Ctypes
type t = {
  ncolors: int;
  colors: Sdl_structure_color.t ptr;
}

let t : t structure typ = structure "SDL_Palette"

let ncolors = field t "ncolors" int
let colors = field t "colors" (ptr Sdl_structure_color.t)

let () = seal t
