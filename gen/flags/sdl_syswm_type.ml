type t =
    SDL_SYSWM_UIKIT
  | SDL_SYSWM_COCOA
  | SDL_SYSWM_DIRECTFB
  | SDL_SYSWM_X11
  | SDL_SYSWM_WINDOWS
  | SDL_SYSWM_UNKNOWN

let to_int = function
  | SDL_SYSWM_UIKIT -> 5
  | SDL_SYSWM_COCOA -> 4
  | SDL_SYSWM_DIRECTFB -> 3
  | SDL_SYSWM_X11 -> 2
  | SDL_SYSWM_WINDOWS -> 1
  | SDL_SYSWM_UNKNOWN -> 0

let of_int = function
  | 5 -> SDL_SYSWM_UIKIT
  | 4 -> SDL_SYSWM_COCOA
  | 3 -> SDL_SYSWM_DIRECTFB
  | 2 -> SDL_SYSWM_X11
  | 1 -> SDL_SYSWM_WINDOWS
  | 0 -> SDL_SYSWM_UNKNOWN
  | _ -> failwith "unknown syswm type"
