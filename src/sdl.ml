(**
 * this module provide lowlevel SDL bindings of {b SDK.h}. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(** variant for SDL subsystems. *)
type subsystem = [
  | `TIMER
  | `VIDEO
  | `AUDIO
  | `CDROM
  | `JOYSTICK
]

exception Sdl_init_exception of string

(** Initializing SDL and SDL Subsystems for SDK version of 1.2
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
external init : ?auto_clean:bool ->
        flags:[< subsystem | `EVENTTHREAD | `NOPARACHUTE | `EVERYTHING] list ->
                unit = "sdlcaml_init"
(**
 * This function is wrapper of {b SDL_Quit}.
 * Quit and finish all SDL systems. if you don't set auto_clean of {!sdl_init}
 * or give false to it, you must call this function in the end of your program.
 *
 * @author derui
 * @since 0.1
 *)
external quit : unit -> unit = "sdlcaml_quit"

(**
 * this return current version of SDL.
 *
 * @return return version to be mapped (major, minor, pachlevel)
 * @author derui
 * @since 0.1
 *)
external version : unit -> int * int * int = "sdlcaml_version"

(**
 * return result of that if each subsystems are initialized.
 *
 * @return result of initialized.
 * @author derui
 * @since 0.1
 *)
external was_init : subsystem list -> bool = "sdlcaml_was_init"

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
external init_subsystem : subsystem -> unit = "sdlcaml_init_subsystem"

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
external quit_subsystem :subsystem -> unit = "sdlcaml_quit_subsystem"
