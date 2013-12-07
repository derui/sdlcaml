let flags = [
  "SDL_GL_CONTEXT_PROFILE_CORE";
  "SDL_GL_CONTEXT_PROFILE_COMPATIBILITY";
  "SDL_GL_CONTEXT_PROFILE_ES";
]

let () =
  ignore (List.fold_left (fun n flag ->
    Printf.printf "#define MLTAG_%s (%d)\n" flag n;
    succ n
  ) 0 flags)
