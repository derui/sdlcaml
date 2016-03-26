open Ctypes
open Sdlcaml_flags

type t = {
  version: Version.t;
  subsystem: Sdl_syswm_type.t;
}

let t : t structure typ = structure "SDL_SysWMmsg"

let (-:) label ty = field t label ty
let version = "version" -: Version.t
let subsystem = "subsystem" -: uint32_t
let _ = "dummy" -: int

let () = seal t
