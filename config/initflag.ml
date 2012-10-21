let variants = [
  "TIMER";
  "VIDEO";
  "AUDIO";
  "CDROM";
  "JOYSTICK";
  "EVENTTHREAD";
  "NOPARACHUTE";
  "EVERYTHING";
]

external variant_hash : string -> unit = "variant_hash"

let _ =
  let print_hash variant_name =
    Printf.printf "#define MLTAG_%s %!" variant_name;
    variant_hash variant_name;
    Printf.printf "\n%!";
  in
  List.iter print_hash variants
