(**
 * This module provide utility functions and support types.
 *
 * @author derui
 * @since 0.2
 *)

val catch : (unit -> bool) -> (unit -> 'a) -> 'a Sdl_types.Result.t
(** A utility to handle return code whether Success or Failure as the Result.t type*)

val catch_exn : (string -> exn) -> (unit -> bool) -> (unit -> 'a) -> 'a
(** A utility to handle return code whether throw exception or return some value. *)
