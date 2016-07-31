open Core.Std
open Ctypes
open Foreign
open Sdlcaml_flags
module S = Sdlcaml_structures

module Inner = struct

  let has_event = foreign "SDL_HasEvent" (uint32_t @-> returning int)
  let push_event = foreign "SDL_PushEvent" (ptr S.Events.t @-> returning int)
  let event_state = foreign "SDL_EventState" (uint32_t @-> int @-> returning uint8_t)
  let flush_event = foreign "SDL_FlushEvent" (uint32_t @-> returning void)
  let pump_events = foreign "SDL_PumpEvents" (void @-> returning void)
  let poll_event = foreign "SDL_PollEvent" (ptr S.Events.t @-> returning int)
  let wait_event = foreign "SDL_WaitEvent" (ptr S.Events.t @-> returning int)
end

let push e =
  let e = S.Events.of_ocaml e in
  let ret = Inner.push_event (addr e) in
  Sdl_util.catch (fun _ -> Sdl_helper.int_to_bool ret) ignore

let query_state e =
  let event_n = Sdl_event_type.to_int32 e |> Unsigned.UInt32.of_int32 in
  let ret = Inner.event_state event_n (Sdl_state.to_int Sdl_state.SDL_QUERY) in
  Unsigned.UInt8.to_int ret |> Sdl_state.of_int

let enable e =
  let event_n = Sdl_event_type.to_int32 e |> Unsigned.UInt32.of_int32 in
  let ret = Inner.event_state event_n (Sdl_state.to_int Sdl_state.SDL_ENABLE) in
  let state = Unsigned.UInt8.to_int ret |> Sdl_state.of_int in
  state = Sdl_state.SDL_ENABLE

let disable e =
  let event_n = Sdl_event_type.to_int32 e |> Unsigned.UInt32.of_int32 in
  let ret = Inner.event_state event_n (Sdl_state.to_int Sdl_state.SDL_DISABLE) in
  let state = Unsigned.UInt8.to_int ret |> Sdl_state.of_int in
  state = Sdl_state.SDL_ENABLE

let has_event e =
  let ret = Sdl_event_type.to_int32 e |> Unsigned.UInt32.of_int32 |> Inner.has_event in
  Sdl_helper.int_to_bool ret

let has_events events =
  (* Return true if matching events are present at least one *)
  List.map events ~f:has_event |> List.filter ~f:Fn.id |> List.is_empty |> not

let flush types =
  List.map ~f:(Fn.compose Unsigned.UInt32.of_int32 Sdl_event_type.to_int32) types |>
      List.iter ~f:Inner.flush_event

let pump = Inner.pump_events

let polling f =
  let rec loop () =
    let e = make S.Events.t in
    let ret = Inner.poll_event (addr e) in
    let ret = Sdl_helper.int_to_bool ret in
    if ret then loop (S.Events.to_ocaml e |> f) else ()
  in
  Sdl_types.Result.return (loop ())

let waiting f =
  let e = make S.Events.t in
  let ret = Inner.wait_event (addr e) in
  Sdl_util.catch (fun _ -> Sdl_helper.int_to_bool ret) (fun () -> S.Events.to_ocaml e |> f)
