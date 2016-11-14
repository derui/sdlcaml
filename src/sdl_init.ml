(**
 * this module provide lowlevel SDL bindings of {b SDK.h}. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
*)
open Ctypes
open Foreign

exception Sdl_init_exception of string

module Inner = struct
  let init = foreign "SDL_Init" (uint32_t @-> returning int)
  let init_sub_system = foreign "SDL_InitSubSystem" (uint32_t @-> returning int)
  let quit = foreign "SDL_Quit" (void @-> returning void)
  let quit_sub_system = foreign "SDL_QuitSubSystem" (uint32_t @-> returning void)
  let set_main_ready = foreign "SDL_SetMainReady" (void @-> returning void)
  let was_init = foreign "SDL_WasInit" (uint32_t @-> returning uint32_t)
end

let catch = Sdl_util.catch_exn (fun s -> Sdl_init_exception s)

let combine_flags flags = 
  let flags = List.map Sdlcaml_flags.Sdl_init_flags.to_int flags in
  let open Unsigned.UInt32.Infix in
  List.fold_left (fun flag raw -> flag lor (Int32.of_int raw |> Unsigned.UInt32.of_int32))
    (Unsigned.UInt32.of_int32 (Int32.of_int 0)) flags

let split_flag flag =
  let flag_to_int32 flg = Sdlcaml_flags.Sdl_init_flags.to_int flg |> Unsigned.UInt32.of_int in
  let list = List.map flag_to_int32 Sdlcaml_flags.Sdl_init_flags.list in
  let open Unsigned.UInt32.Infix in
  List.fold_left (fun memo target -> if flag land target = target then target :: memo else memo)
    [] list

(** Initializing SDL and SDL Subsystems for SDK version of 2.0
 *  Taking arguments to this function have to {e flags}. if {e auto_clean} isn't
 *  send, you must call {!sdl_quit} in the end of your program.
 *  if SDL initialization failed, raise {!SDL_init_exception} with error infomations
 *  from {b SDL_GetError} and line number at raised it.
 *
 *  @param auto_clean auto_clean setting up auto cleanup with sdl_quit if give
 *  this true. defaults, sdl_init doesn't set up it.
 *  @param flags Targets of initializing systems and mode flags.
 *  @raise SDL_init_exception raise it when initialization failed.
 *  @author derui
 *  @since 0.1
*)
let init flags =
  let flag = combine_flags flags in
  let result = Inner.init flag in
  catch (fun _ -> result = 0) ignore

(**
 * This function is wrapper of {b SDL_Quit}.
 * Quit and finish all SDL systems. if you don't set auto_clean of {!sdl_init}
 * or give false to it, you must call this function in the end of your program.
 *
 * @author derui
 * @since 0.1
*)
let quit = Inner.quit

(**
 * return result of that if each subsystems are initialized.
 *
 * @return result of initialized.
 * @author derui
 * @since 0.1
*)
let was_init flag =
  let flag = Sdlcaml_flags.Sdl_init_flags.to_int flag |> Int32.of_int |> Unsigned.UInt32.of_int32 in
  let result = Inner.was_init flag in
  List.mem flag (split_flag result)

(**
 * Initializing a SDL subsystem.  this function used to after {!sdl_init}
 * without flags that any subsystem initializing.
 * If a subsystem initializing failed, {!SDL_init_exception} raise.
 *
 * @param flag give flags of a target subsystem
 * @raise SDL_init_exception when initializing failed
 * @author derui
 * @since 0.1
*)
let init_sub_system flags =
  let flag = combine_flags flags in
  let result = Inner.init_sub_system flag in
  catch (fun _ -> result = 0) ignore

(**
 * Quit a SDL subsystem. this function have to call after {!sdl_init} or
 * {!sdl_init_subsystem} called.
 * If you call {!sdl_quit}, you doesn't need to call this because {!sdl_quit}
 * shut down all SDL subsystems.
 *
 * @param flag give flags of a target subsystem
 * @author derui
 * @since 0.1
*)
let quit_sub_system flags =
  let flag = combine_flags flags in
  Inner.quit_sub_system flag |> ignore

let () =
  Callback.register_exception "Sdl_init_exception" (Sdl_init_exception "Some error")
