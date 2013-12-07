let flags = Sdl_blendmode.flags
let () =
  Printf.printf "  {0, %d}\n" (List.length flags);
  List.iter (fun  flag ->
    Printf.printf "  ,{Val_int(MLTAG_%s), %s}\n" flag flag;
  ) flags
