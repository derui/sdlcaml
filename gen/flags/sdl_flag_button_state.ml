
type t = SDL_PRESSED | SDL_RELEASED

let to_int = function
  | SDL_PRESSED -> 1
  | SDL_RELEASED -> 0

let of_int = function
  | 1 -> SDL_PRESSED
  | 0 -> SDL_RELEASED
  | _ -> failwith "Unknown value on Sdl_flag_button_state.t"
