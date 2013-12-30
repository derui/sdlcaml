(**
   Define a module to provide log operations that is wrapper about SDL_Log

   @author derui
   @since 0.2
*)
open Ctypes
open Foreign

type 'a log_fmt = ('a, unit, string, unit -> unit) format4 -> 'a

type log_fun = Sdlcaml_flags.Sdl_log_category.t -> Sdlcaml_flags.Sdl_log_priority.t -> string -> unit
(* A type of function used to output function *)

val log : 'a log_fmt
(** [log ~category ~priority "format" ...] log a message with SDL_LOG_CATEGORY_APPLICATION and SDL_LOG_PRIORITY_INFO *)

val log_critical : [< Sdlcaml_flags.Sdl_log_category.t] -> 'a log_fmt
(** [log_critical priority "format" ...] log a message with SDL_Critial *)

val log_debug : [< Sdlcaml_flags.Sdl_log_category.t] -> 'a log_fmt
(** [log_debug priority "format" ...] log a message with SDL_Critial *)

val log_error : [< Sdlcaml_flags.Sdl_log_category.t] -> 'a log_fmt
(** [log_error priority "format" ... ] log a message with SDL_Critial *)

val log_info : [<Sdlcaml_flags.Sdl_log_category.t] -> 'a log_fmt
(** [log_info priority "format" ... ] log a message with SDL_Critial *)

val log_verbose :[< Sdlcaml_flags.Sdl_log_category.t]-> 'a log_fmt
(** [log_verbose priority "format" ... ] log a message with SDL_Critial *)

val log_warn : [< Sdlcaml_flags.Sdl_log_category.t] -> 'a log_fmt
(** [log_warn priority "format" ... ] log a message with SDL_Critial *)

val reset_priorities : unit -> unit
(** [reset_priorities ()] reset all priorities to default *)

val set_all_priority : [< Sdlcaml_flags.Sdl_log_priority.t] -> unit
(** [set_all_priority priority] set all priority of all log categories *)

val set_priority : category:[< Sdlcaml_flags.Sdl_log_category.t] -> priority:[< Sdlcaml_flags.Sdl_log_priority.t] -> unit -> unit
(** [set_priority ~category ~priority ()] set the priority of a particular log category *)

val get_priority : [<Sdlcaml_flags.Sdl_log_category.t] -> [>Sdlcaml_flags.Sdl_log_priority.t]
(** [get_priority category] get the priority of the specified category. *)

val set_output_function: log_fun -> unit
(* [set_output_function f] replace the default logOutput function with one of your own *)
