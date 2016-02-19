(**
   Define a module to provide timer operations for SDL_timer as wrapper.
   When using functions definded in this module must initialize SDL with SDL_INIT_TIMER flag at first.

   @author derui
   @since 0.2
*)

val get_performance_counter: unit -> int64
(** [get_performance_counter ()] get the current value of the high resolution counter.
   This function is low level operation, used for profiling. Recommend to use [profile] function
   for user.
*)

val get_performance_frequency: unit -> int64
(** [get_performance_frequency ()] get the count per second of the high resolution counter *)

val get_ticks: unit -> int32
(** [get_ticks ()] get the number of milliseconds since the SDL Library initialization. *)

val delay: int32 -> unit
(** [delay ms] wait a specified number of milliseconds before returning. *)

val profile: count:int -> f:(unit -> 'a) -> float
(** [profile ~count ~f] get the profile to execute [f] the number of [count].
   The value of returned is as nanoseconds, multiply 1000 if wait as milliseconds.

   If [count] less than 0, return always -1L.
*)
