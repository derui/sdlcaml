let flags = [
  "SDL_GL_CONTEXT_DEBUG_FLAG";
  "SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG";
  "SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG";
  "SDL_GL_CONTEXT_RESET_ISOLATION_FLAG";
]

let () =
  ignore (List.fold_left (fun n flag ->
    Printf.printf "#define MLTAG_%s (%d)\n" flag n;
    succ n
  ) 0 flags)
