open Ctypes

type t = {
  x : int;
  y : int;
}
let t : t structure typ = structure "SDL_Point"

let x = field t "x" int
let y = field t "y" int

let of_ocaml p =
  let ret = make t in
  setf ret x p.x;
  setf ret y p.y;
  ret

let to_ocaml p = {x = getf p x;y = getf p y}

let () = seal t
