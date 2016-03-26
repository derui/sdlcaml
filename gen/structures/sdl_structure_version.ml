open Ctypes
open Foreign

type t = {
  major : int;
  minor : int;
  patch : int;
}

let t : t structure typ = structure "SDL_version"

let major = field t "major" int
let minor = field t "minor" int
let patch = field t "patch" int

let to_ocaml str =
  {major = getf str major;
   minor = getf str minor;
   patch = getf str patch;
  }

let () = seal t
