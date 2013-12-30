open Ctypes
type t = {
  format : Sdlcaml_flags.Sdl_pixel_format_enum.t;
  width : int;
  height : int;
  refresh_rate : int;
}

let t : t structure typ = structure "SDL_DisplayMode"

let format = field t "format" int

let get_format t = 
  let fmt = getf t format in
  Sdlcaml_flags.Sdl_pixel_format_enum.of_int32 (Int32.of_int fmt)

let width = field t "width" int
let height = field t "height" int
let refresh_rate = field t "refresh_rate" int

let to_ocaml str =
  {format = get_format str;
   width = getf str width;
   height = getf str height;
   refresh_rate = getf str refresh_rate;
  }

let of_ocaml r =
  let str = make t in
  let flag = Sdlcaml_flags.Sdl_pixel_format_enum.to_int32 r.format |> Int32.to_int in
  setf str format flag;
  setf str width r.width;
  setf str height r.height;
  setf str refresh_rate r.refresh_rate;
  str

let () = seal t
