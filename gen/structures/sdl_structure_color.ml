open Ctypes
type t = {
  r:int;
  g:int;
  b:int;
  a:int;
}

let t : t structure typ = structure "SDL_Color"

let r = field t "r" uint8_t
let g = field t "g" uint8_t
let b = field t "b" uint8_t
let a = field t "a" uint8_t

let to_string {r;g;b;a} =
  Printf.sprintf "colors{r = %d;g = %d;b = %d;a = %d}" r g b a

let () = seal t
