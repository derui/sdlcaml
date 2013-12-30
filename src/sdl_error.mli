(**
   Define module to provide error handling operations.

   @author derui
   @since 0.2
*)

val clear : unit -> unit
(** [Sdl_error.clear ()] Clear any previous error message *)

val get : unit -> string
(** [Sdl_error.get ()] Retrieve a message about the last error that occurred  *)
