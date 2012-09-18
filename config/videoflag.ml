let variants = [
  "SDL_SWSURFACE";
  "SDL_HWSURFACE";
  "SDL_ASYNCBLIT";
  "SDL_ANYFORMAT";
  "SDL_HWPALETTE";
  "SDL_DOUBLEBUF";
  "SDL_FULLSCREEN";
  "SDL_OPENGL";
  "SDL_OPENGLBLIT";
  "SDL_RESIZABLE";
  "SDL_HWACCEL";
  "SDL_SRCCOLORKEY";
  "SDL_RLEACCEL";
  "SDL_SRCALPHA";
  "SDL_PREALLOC";
]

external variant_hash : string -> int = "variant_hash"

let _ =
  let print_hash variant_name =
    let hash = variant_hash variant_name in
    Printf.printf "#define MLTAG_%s (%d)\n" variant_name hash
  in
  List.iter print_hash variants
