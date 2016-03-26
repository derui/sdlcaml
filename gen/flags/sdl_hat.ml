type t =
    SDL_HAT_RIGHTDOWN
  | SDL_HAT_DOWN
  | SDL_HAT_LEFTDOWN
  | SDL_HAT_RIGHT
  | SDL_HAT_CENTERED
  | SDL_HAT_LEFT
  | SDL_HAT_RIGHTUP
  | SDL_HAT_UP
  | SDL_HAT_LEFTUP


let to_int = function
  | SDL_HAT_CENTERED -> 0x01
  | SDL_HAT_UP -> 0x01
  | SDL_HAT_RIGHT -> 0x02
  | SDL_HAT_DOWN -> 0x04
  | SDL_HAT_LEFT -> 0x08
  | SDL_HAT_RIGHTUP -> 0x02 lor 0x01
  | SDL_HAT_RIGHTDOWN -> 0x02 lor 0x04
  | SDL_HAT_LEFTUP -> 0x08 lor 0x01
  | SDL_HAT_LEFTDOWN -> 0x08 lor 0x04

let of_int = function
  | 0x00 -> SDL_HAT_CENTERED
  | 0x01 -> SDL_HAT_UP
  | 0x02 -> SDL_HAT_RIGHT
  | 0x04 -> SDL_HAT_DOWN
  | 0x08 -> SDL_HAT_LEFT
  | 0x03 -> SDL_HAT_RIGHTUP     (* 0x02 | 0x01 *)
  | 0x06 -> SDL_HAT_RIGHTDOWN (* 0x02 | 0x04 *)
  | 0x09 -> SDL_HAT_LEFTUP (* 0x08 | 0x01 *)
  | 0x0C -> SDL_HAT_LEFTDOWN (* 0x08 | 0x04 *)
  | _ -> failwith "No variant to match given value"
