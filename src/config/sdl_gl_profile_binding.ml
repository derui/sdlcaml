let () =
  Printf.printf "  {0, %d}\n" (List.length Sdl_gl_profile_binding.flags);
  List.iter (fun  flag ->
    Printf.printf "  ,{Val_int(MLTAG_%s), %s}\n" flag flag;
  ) flags
