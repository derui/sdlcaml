let print_mapping flags =
  Printf.printf "  {0, %d}\n" (List.length flags);
  List.iter (fun  flag ->
    Printf.printf "  ,{Val_int(MLTAG_%s), %s}\n" flag flag;
  ) flags

let print_header flags =
  ignore (List.fold_left (fun n flag ->
    Printf.printf "#define MLTAG_%s (%d)\n" flag n;
    succ n
  ) 0 flags)
