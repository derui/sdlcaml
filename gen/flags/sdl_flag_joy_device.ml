(* Provide SDL_JOYDEVICE* events mapping of variant to use in OCaml useful. *)
type t = [`ADDED |`REMOVED]

let to_int32 = function
  | `ADDED -> Sdl_flag_event_type.SDL_JOYDEVICEADDED |> Sdl_flag_event_type.to_int32
  | `REMOVED -> Sdl_flag_event_type.SDL_JOYDEVICEREMOVED |> Sdl_flag_event_type.to_int32

let of_int32 t =
  let added = Sdl_flag_event_type.SDL_JOYDEVICEADDED |> Sdl_flag_event_type.to_int32
  and removed = Sdl_flag_event_type.SDL_JOYDEVICEREMOVED |> Sdl_flag_event_type.to_int32 in
  match t with 
  | s when s = added -> `ADDED
  | s when s = removed -> `REMOVED
  | _ -> failwith "No variant matching with given value"
