open Core.Std
open Sdlcaml.Std
open Flags

let with_sdl f =
  Init.init [Sdl_init_flags.SDL_INIT_TIMER];
  protect ~f:(Fn.compose ignore f) ~finally:Init.quit

let%spec "SDL Timer module can get the count per second of the high resolution counter" =
  with_sdl (fun () ->
    let counter = Timer.get_performance_counter () in
    let counter2 = Timer.get_performance_counter () in
    (counter < counter2) [@eq true]
  )

let%spec "SDL Timer module can get the second between two counter" =
  with_sdl (fun () ->
    let counter = Timer.get_performance_counter () in
    let counter2 = Timer.get_performance_counter () in
    let freq = Timer.get_performance_frequency () |> Int64.to_float in
    let second = Int64.(counter2 - counter |> to_float) /. freq in
    (second >= 0.0) [@true "must greater than 0"]
  )

let%spec "SDL Timer module can get the number of milliseconds and delay current thread" =
  with_sdl (fun () ->
    let start = Timer.get_ticks () in
    Timer.delay 100l;
    let now = Timer.get_ticks () in
    (Int32.(now - start) >= 100l) [@true "must greater than 100l"]
  )

let%spec "SDL Timer module provide function to profile a function" =
  with_sdl (fun () ->
    let time = Timer.profile ~count:10 ~f:(fun () -> Timer.delay 10l) in
    Float.(time >= 0.1) [@true "must greater than 100"]
  )
