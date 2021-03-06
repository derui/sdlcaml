type t = [`MOTION | `DOWN | `UP]

let of_int32 t =
  let motion = Sdl_event_type.SDL_FINGERMOTION |> Sdl_event_type.to_int32
  and down = Sdl_event_type.SDL_FINGERDOWN |> Sdl_event_type.to_int32
  and up = Sdl_event_type.SDL_FINGERUP |> Sdl_event_type.to_int32 in
  match t with
  | s when s = motion -> `MOTION
  | s when s = down -> `DOWN
  | s when s = up -> `UP
  | _ -> failwith "No variant match given value"

let to_int32 = function
  | `MOTION -> Sdl_event_type.SDL_FINGERMOTION |> Sdl_event_type.to_int32
  | `DOWN -> Sdl_event_type.SDL_FINGERDOWN |> Sdl_event_type.to_int32
  | `UP -> Sdl_event_type.SDL_FINGERUP |> Sdl_event_type.to_int32
