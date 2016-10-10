open Ctypes

(** The type mapping to SDL_Rect *)
type t = {
  x : int;                      (** x location of the rectangle's upper left corner *)
  y : int;                      (** y location of the rectangle's upper left corner *)
  w : int;                      (** the width of the rectangle *)
  h : int;                      (** the height of the rectangle *)
}

let t : t structure typ = structure "SDL_Rect"
let x = field t "x" int
let y = field t "y" int
let w = field t "w" int
let h = field t "h" int

let of_ocaml r =
  let ret = make t in
  setf ret x r.x;
  setf ret y r.y;
  setf ret w r.w;
  setf ret h r.h;
  ret

let to_ocaml r =
  {x = getf r x;
   y = getf r y;
   w = getf r w;
   h = getf r h;
  }

let empty = {x = 0; y = 0; w = 0; h = 0;}

let () = seal t
