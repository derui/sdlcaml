(**
   Define a module to provide log operations that is wrapper about SDL_Log

   @author derui
   @since 0.2
*)

open Sdlcaml_flags
open Ctypes
open Foreign

type 'a log_fmt = ('a, unit, string, unit -> unit) format4 -> 'a
type log_fun = Sdl_log_category.t -> Sdl_log_priority.t -> string -> unit

module Inner = struct
  let log = foreign "SDL_Log" (string @-> returning void)
  let log_critical = foreign "SDL_LogCritical" (int @-> string @-> returning void)
  let log_debug = foreign "SDL_LogDebug" (int @-> string @-> returning void)
  let log_error = foreign "SDL_LogError" (int @-> string @-> returning void)
  let log_info = foreign "SDL_LogInfo" (int @-> string @-> returning void)
  let log_verbose = foreign "SDL_LogVerbose" (int @-> string @-> returning void)
  let log_warn = foreign "SDL_LogWarn" (int @-> string @-> returning void)
  let get_priority = foreign "SDL_LogGetPriority" (int @-> returning int)
  let reset_priorities = foreign "SDL_LogResetPriorities" (void @-> returning void)
  let set_all_priority = foreign "SDL_LogSetAllPriority" (int @-> returning void)
  let set_priority = foreign "SDL_LogSetPriority" (int @-> int @-> returning void)
  let output_function = ptr void @-> int @-> int @-> string @-> returning void
  let set_output_function = foreign "SDL_LogSetOutputFunction" (
    funptr output_function @-> ptr void @-> returning void
  )
end

let log fmt = Printf.kprintf (fun s () -> Inner.log s) fmt
let log_by_priority category func fmt =
  let category = Sdl_log_category.to_int category in
  Printf.kprintf (fun s () -> func category s) fmt

let log_critical category fmt = log_by_priority category Inner.log_critical fmt
let log_debug category fmt = log_by_priority category Inner.log_debug fmt
let log_error category fmt = log_by_priority category Inner.log_error fmt
let log_info category fmt = log_by_priority category Inner.log_info fmt
let log_verbose category fmt = log_by_priority category Inner.log_verbose fmt
let log_warn category fmt = log_by_priority category Inner.log_warn fmt

let get_priority category =
  let prio = Inner.get_priority (Sdl_log_category.to_int category) in
  Sdl_log_priority.of_int prio

let reset_priorities () = ignore (Inner.reset_priorities ())
let set_all_priority priority =
  ignore (Inner.set_all_priority (Sdl_log_priority.to_int priority))
let set_priority ~category ~priority () =
  ignore (Inner.set_priority (Sdl_log_category.to_int category) (Sdl_log_priority.to_int priority))

let set_output_function f =
  let output_function _ cat pri mes =
    let cat = Sdl_log_category.of_int cat
    and pri = Sdl_log_priority.of_int pri in
    f cat pri mes
  in
  Inner.set_output_function output_function null
