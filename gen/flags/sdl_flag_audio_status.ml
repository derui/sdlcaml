type t =
    SDL_AUDIO_STOPPED
  | SDL_AUDIO_PLAYING
  | SDL_AUDIO_PAUSED

let to_int = function
  | SDL_AUDIO_STOPPED -> 0
  | SDL_AUDIO_PLAYING -> 1
  | SDL_AUDIO_PAUSED -> 2

let of_int = function
  | 0 -> SDL_AUDIO_STOPPED
  | 1 -> SDL_AUDIO_PLAYING
  | 2 -> SDL_AUDIO_PAUSED
  | _ -> failwith "No audio_status match with given value"
