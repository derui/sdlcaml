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

let of_ocaml c =
  let str = make t in
  let module U = Unsigned.UInt8 in
  setf str r (U.of_int c.r);
  setf str g (U.of_int c.g);
  setf str b (U.of_int c.b);
  setf str a (U.of_int c.a);
  str

let () = seal t
