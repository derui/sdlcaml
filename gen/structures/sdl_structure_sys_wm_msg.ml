open Ctypes
open Sdlcaml_flags

type t = {
  version: Sdl_structure_version.t;
  subsystem: Sdl_syswm_type.t;
}

let t : t structure typ = structure "SDL_SysWMmsg"

let (-:) label ty = field t label ty
let version = "version" -: Sdl_structure_version.t
let subsystem = "subsystem" -: uint32_t
let _ = "dummy" -: int

let () = seal t
