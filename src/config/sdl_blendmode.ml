let flags = [
  "SDL_BLENDMODE_NONE";
  "SDL_BLENDMODE_BLEND";
  "SDL_BLENDMODE_ADD";
  "SDL_BLENDMODE_MOD";
]

let () =
  ignore (List.fold_left (fun n flag ->
    Printf.printf "#define MLTAG_%s (%d)\n" flag n;
    succ n
  ) 0 flags)
