type t =
    SDL_MOUSEWHEEL_NORMAL
  | SDL_MOUSEWHEEL_FLIPPED

let of_int = function
  | 0 -> SDL_MOUSEWHEEL_NORMAL
  | 1 -> SDL_MOUSEWHEEL_FLIPPED
  | _ -> failwith "No variant match given value"

let to_int = function
  | SDL_MOUSEWHEEL_FLIPPED -> 1
  | SDL_MOUSEWHEEL_NORMAL -> 0
