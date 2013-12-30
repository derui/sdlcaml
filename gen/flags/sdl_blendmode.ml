type t =
    SDL_BLENDMODE_MOD
  | SDL_BLENDMODE_ADD
  | SDL_BLENDMODE_BLEND
  | SDL_BLENDMODE_NONE

let to_int = function
  | SDL_BLENDMODE_MOD -> 0x4
  | SDL_BLENDMODE_ADD -> 0x2
  | SDL_BLENDMODE_BLEND -> 0x1
  | SDL_BLENDMODE_NONE -> 0x0

let of_int = function
  | 0x4 -> SDL_BLENDMODE_MOD
  | 0x2 -> SDL_BLENDMODE_ADD
  | 0x1 -> SDL_BLENDMODE_BLEND
  | 0x0 -> SDL_BLENDMODE_NONE
  | _ -> failwith "No blendmode match with given value"
