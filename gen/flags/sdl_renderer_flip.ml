type t =
    SDL_FLIP_VERTICAL
  | SDL_FLIP_HORIZONTAL
  | SDL_FLIP_NONE

let to_int = function
  | SDL_FLIP_VERTICAL -> 0x2
  | SDL_FLIP_HORIZONTAL -> 0x1
  | SDL_FLIP_NONE -> 0x0

let of_int = function
  | 0x2 -> SDL_FLIP_VERTICAL
  | 0x1 -> SDL_FLIP_HORIZONTAL
  | 0x0 -> SDL_FLIP_NONE
  | _ -> failwith "No variant to match given value"
