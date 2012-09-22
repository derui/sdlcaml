(**
 * this module provide lowlevel SDL bindings of {b SDK_timer.h}. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(**
 * Get the number of milliseconds since the SDL Library
 * initialization.
 * @return number of milliseconds
 *)
external get_ticks: unit -> int = "sdlcaml_getticks"

(**
 * Wait a specified number of milliseconds before returning.
 * Noted, this function have same restriction {b SDL_Delay},
 * I mean, this function will wait at least the specified time.
 * most environments of at least {i 10ms}.
 *
 * @param time specified number of milliseconds to wait
 *)
external delay: int -> unit = "sdlcaml_delay"
