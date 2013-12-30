open Ctypes
open Foreign

type t

let t : t structure typ = structure "SDL_RWops"

let size_callback = ptr t @-> returning int64_t
let seek_callback = ptr t @-> int64_t @-> int @-> returning int64_t
let read_callback = ptr t @-> ptr void @-> size_t @-> size_t @-> returning size_t
let write_callback = ptr t @-> ptr void @-> size_t @-> size_t @-> returning size_t
let close_callback = ptr t @-> returning int

let (|-) fld ty = field t fld ty
let size = "size" |- funptr size_callback
let seek = "seek" |- funptr seek_callback
let read = "read" |- funptr read_callback
let write = "write" |- funptr write_callback
let close = "close" |- funptr close_callback
let stream_type = "type" |- uint32_t

let () = seal t
