open Ctypes
type t = {
  ncolors: int;
  colors: Color.t ptr;
}

let t : t structure typ = structure "SDL_Palette"

let ncolors = field t "ncolors" int
let colors = field t "colors" (ptr Color.t)

let () = seal t
