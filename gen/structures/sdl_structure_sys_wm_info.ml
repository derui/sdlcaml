open Ctypes
open Foreign

type t = {
  version : Sdl_structure_version.t;
  subsystem : Sdlcaml_flags.Sdl_syswm_type.t
}

let t : t structure typ = structure "SDL_SysWMinfo"

let version = field t "version" Sdl_structure_version.t
let subsystem = field t "subsystem" int

let get_subsystem = fun t ->
  let sys = getf t subsystem in
  Sdlcaml_flags.Sdl_syswm_type.of_int sys

let to_ocaml str =
  {version = Sdl_structure_version.to_ocaml (getf str version);
   subsystem = get_subsystem str;
  }

let () = seal t
