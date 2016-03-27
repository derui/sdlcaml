type t = [`ADDED | `REMOVED]

let of_int32 t =
  let added = Sdl_event_type.SDL_AUDIODEVICEADDED |> Sdl_event_type.to_int32
  and removed = Sdl_event_type.SDL_AUDIODEVICEREMOVED |> Sdl_event_type.to_int32 in
  match t with
  | s when s = added -> `ADDED
  | s when s = removed -> `REMOVED
  | _ -> failwith "No variant match given value"

let to_int32 = function
  | `REMOVED -> Sdl_event_type.SDL_AUDIODEVICEREMOVED |> Sdl_event_type.to_int32
  | `ADDED -> Sdl_event_type.SDL_AUDIODEVICEADDED |> Sdl_event_type.to_int32
