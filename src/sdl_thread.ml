open Ctypes
open Foreign
open Sdlcaml_flags

type t = Sdl_types.Thread.t
let t = Sdl_types.Thread.t

let callback = ptr void @-> returning int
type callback = unit ptr -> int

let destructor = ptr void @-> returning void

module Inner = struct
  let create_thread = foreign "SDL_CreateThread" (funptr ~runtime_lock:false callback @-> string
                                                  @-> ptr void
                                                  @-> returning t)
  let detach_thread = foreign "SDL_DetachThread" (t @-> returning void)
  let get_thread_id = foreign "SDL_GetThreadID" (t @-> returning uint64_t)
  let get_thread_name = foreign "SDL_GetThreadName" (t @-> returning string)
  let set_thread_priority = foreign "SDL_SetThreadPriority" (int @-> returning int)
  let tls_create = foreign "SDL_TLSCreate" (void @-> returning uint32_t)
  let tls_get = foreign "SDL_TLSGet" (uint32_t @-> returning (ptr void))
  let tls_set = foreign "SDL_TLSSet" (uint32_t @-> ptr void @-> funptr destructor @-> returning int)

  let thread_id = foreign "SDL_ThreadID" (void @-> returning uint64_t)
  let wait_thread = foreign "SDL_WaitThread" (t @-> ptr int @-> returning void)
end

let create ~name ~f =
  let ret = Inner.create_thread f name null in
  Sdl_util.catch (fun () -> to_voidp ret <> null) (fun () -> ret)

let detach = Inner.detach_thread

let get_id t =
  Inner.get_thread_id t |> Unsigned.UInt64.to_int64

let get_name = Inner.get_thread_name

let set_priority ~priority =
  let ret = Inner.set_thread_priority Sdl_thread_priority.(to_int priority) in
  Sdl_util.catch (fun () -> ret = 0) ignore

let current_id () = Inner.thread_id () |> Unsigned.UInt64.to_int64

let wait t =
  let buf = CArray.make int 1 in
  Inner.wait_thread t (CArray.start buf);
  CArray.get buf 0

module type S = sig
  type t
  type 'a converter = 'a -> unit ptr
  type 'a inv_converter = unit ptr -> 'a

  val create: unit -> t
  val set: t -> value:'a -> conv:'a converter -> unit Sdl_types.Result.t
  val get: t -> conv:'a inv_converter -> 'a Sdl_types.Result.t
  val get_opt: t -> conv:'a inv_converter -> 'a option
end

module Local_storage:S = struct
  type t = Unsigned.UInt32.t
  type 'a converter = 'a -> unit ptr
  type 'a inv_converter = unit ptr -> 'a

  let create = Inner.tls_create

  let set t ~value ~conv =
    let destructor _ = () in
    let ret = Inner.tls_set t (conv value) destructor in
    Sdl_util.catch (fun () -> ret = 0) ignore

  let get t ~conv =
    let v = Inner.tls_get t in
    Sdl_util.catch (fun () -> v <> null) (fun () -> conv v)

  let get_opt t ~conv =
    let v = Inner.tls_get t in
    if v = null then None else Some (conv v)
end
