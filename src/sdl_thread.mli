(**
   Define a module to provide system independent threa management.
   What you build program using this module must add -thread flag for ocamlc/ocamlopt.

   @author derui
   @since 0.2
*)
open Sdlcaml_flags
open Ctypes

type t = Sdl_types.Thread.t
(* The type of thread. *)

type callback = unit ptr -> int
(* The type of thread callback *)

val create: name:string -> f:callback -> t Sdl_types.Result.t
(* [create ~name ~f] create a new thread with [name] and [f].
   This do not provide function passing data into [f].
*)

val detach: t -> unit
(* [detach thread] let a thread clean up on exit with out intervention *)

val get_id: t -> int64
(* [get_id thread] get the thread identifier for the specified [thread] *)

val get_name: t -> string
(* [get_name thread] get the thread name as it was specified in [create] *)

val set_priority: priority:Sdl_thread_priority.t -> unit Sdl_types.Result.t
(* [set_priority t ~priority] set the priority for the current thread. *)

val current_id: unit -> int64
(* [current_id ()] get the thread identifier for the current thread. *)

val wait: t -> int
(* [wait thread] wait for a thread to finish *)

(* A module for thread-local-storage providing from SDL.
   This module is based on [Sdl_types.Result.t], so you can use this with Monadic syntax
*)
module type S = sig
  type t
  type 'a converter = 'a -> unit ptr
  type 'a inv_converter = unit ptr -> 'a

  val create: unit -> t
    (* [create ()] create an identifier that is globally visible to all threads but referes to data that is thread-specific *)

  val set: t -> value:'a -> conv:'a converter -> unit Sdl_types.Result.t
    (* [set t ~value ~conv] set the value associated with a thread local storage for the
       current thread *)

  val get: t -> conv:'a inv_converter -> 'a Sdl_types.Result.t
(* [get t ~conv] get the value associated with a thread local storage for the
   current thread *)

  val get_opt: t -> conv:'a inv_converter -> 'a option
(* [get_opt t ~conv] get the value associated with a thread local storage for the
   current thread *)
end

module Local_storage:S
