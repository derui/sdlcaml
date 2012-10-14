
(* regexps *)
let reg_newline = ref (Str.regexp "\\(\n\\|\r\n\\|\r\\)$")
let reg_glenum = ref (Str.regexp "^#define +GL_\\([a-zA-Z0-9]+\\)[ \t]+\\([a-zA-Z0-9]+\\).*$")
let reg_split = ref (Str.regexp "_")

(* helper functions *)
let replace_newline = Str.global_replace !reg_newline ""
let split_underscore = Str.split !reg_split
let is_glenum s = Str.string_match !reg_glenum s 0

(* convert eijiro format into sdic format per line *)
let convert_line line =
  let line = replace_newline line in
  if is_glenum line then
    let name = Str.matched_group 1 line
    and value = Str.matched_group 2 line in
    let capitalize s = String.capitalize (String.lowercase s) in
    let splitted = split_underscore name in
    let capitalized = List.map capitalize splitted in
    Printf.printf "  G%s = %s,\n" (String.concat "" capitalized) value
  else
    ()
let convert_glenum _ =
  let rec inner_convert_line _ =
    begin
      (* converted_line don't have newline *)
      convert_line (input_line stdin);
      inner_convert_line ();
    end
  in
  try
    print_endline "enum glenum {";
    inner_convert_line ();
  with End_of_file -> begin
    print_endline "};";
    print_endline "typedef [set] enum glenum glenum_set;";
  end

(* this tool only accept stdin and utf-8 string,
   and newline as Unix(\n).
*)
let _ =
  convert_glenum ()
