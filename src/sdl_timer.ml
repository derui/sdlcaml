open Core.Std
open Ctypes
open Foreign

module Inner = struct
  let get_performance_counter = foreign "SDL_GetPerformanceCounter" (void @-> returning uint64_t)
  let get_performance_frequency = foreign "SDL_GetPerformanceFrequency" (void @-> returning uint64_t)
  let get_ticks = foreign "SDL_GetTicks" (void @-> returning uint32_t)
  let delay = foreign "SDL_Delay" (uint32_t @-> returning void)
end

let get_performance_counter () = Inner.get_performance_counter () |> Unsigned.UInt64.to_int64
let get_performance_frequency () = Inner.get_performance_frequency () |> Unsigned.UInt64.to_int64

let get_ticks () = Inner.get_ticks () |> Unsigned.UInt32.to_int32
let delay ms = Inner.delay (Unsigned.UInt32.of_int32 ms)

let profile ~count ~f =
  if count < 0 then -1.0
  else
    let times = List.range 0 count in
    let start = get_performance_counter () in
    List.iter ~f:(fun _ -> f () |> ignore) times;
    let now = get_performance_counter () in
    let freq = get_performance_frequency () |> Int64.to_float in
    Int64.(now - start |> to_float) /. freq
