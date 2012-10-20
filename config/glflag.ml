let variants = [
  "Byte";
  "UByte";
  "Short ";
  "UShort";
  "Int";
  "UInt";
  "Float";
  "Double";
  "UByte2";
  "UByte3";
  "UByte4";
]

external variant_hash : string -> int = "variant_hash"

let _ =
  let print_hash variant_name =
    Printf.printf "#define MLTAG_%s %!" variant_name;
    variant_hash variant_name;
    Printf.printf "\n%!";
  in
  List.iter print_hash variants
