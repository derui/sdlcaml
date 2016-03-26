(* Provide SDL_DOLLAR* mapping of variant to use in OCaml useful. *)
type t = [`RECORD | `GESTURE]

let to_int32 = function
  | `RECORD -> Sdl_event_type.SDL_DOLLARRECORD |> Sdl_event_type.to_int32
  | `GESTURE -> Sdl_event_type.SDL_DOLLARGESTURE |> Sdl_event_type.to_int32

let of_int32 t =
  let record = Sdl_event_type.SDL_DOLLARRECORD |> Sdl_event_type.to_int32
  and gesture = Sdl_event_type.SDL_DOLLARGESTURE |> Sdl_event_type.to_int32 in
  
  match t with
  | s when s = record -> `RECORD
  | s when s = gesture -> `GESTURE
  | _ -> failwith "No variant match given value"
