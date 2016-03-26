type t = SDL_DISABLE | SDL_QUERY | SDL_ENABLE
let to_int = function
  | SDL_DISABLE -> 0
  | SDL_QUERY -> -1
  | SDL_ENABLE -> 1

let of_int = function
  | 0 -> SDL_DISABLE
  | 1 -> SDL_ENABLE
  | -1 -> SDL_QUERY
  | _ -> failwith "No variant can convert with given value"
