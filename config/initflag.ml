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

external variant_hash : string -> int = "variant_hash"

let _ =
  let print_hash variant_name = 
    let hash = variant_hash variant_name in
    Printf.printf "#define MLTAG_%s (%d)\n" variant_name hash
  in
  List.iter print_hash variants
