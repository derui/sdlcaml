
module H = Hashtbl.Make(struct
  type t = string
  let equal = (=)
  let hash = Hashtbl.hash
end)

let typedef_hash = H.create 10


let buffer = ref []

(* regexps *)
let reg_newline = ref (Str.regexp "\\(\n\\|\r\n\\|\r\\)$")
let reg_glapi_oneline = ref (Str.regexp "^GLAPI[ \t]+\\([a-zA-Z0-9_ *]+\\)[ \t]+GLAPIENTRY[ \t]+\\(.+?;\\).*$")
let reg_glapi_multiline = ref (Str.regexp "^GLAPI[ \t]+\\([a-zA-Z0-9_ *]+\\)[ \t]+GLAPIENTRY[ \t]+\\(.+?\\)$")
let reg_glapi_semicolon = ref (Str.regexp "^.*;.*$")
let reg_typedef = ref (Str.regexp "^typedef \\([a-zA-Z0-9_* ]+?\\)[ \t]+\\(GL[a-zA-Z0-9]+\\);.*$")

(* helper functions *)
let replace_newline = Str.global_replace !reg_newline ""
let is_glapi_typedef s = Str.string_match !reg_typedef s 0

let is_glapi s = Str.string_match !reg_glapi_oneline s 0
let is_glapi_multi s = Str.string_match !reg_glapi_multiline s 0
let is_glapi_multi_end s = Str.string_match !reg_glapi_semicolon s 0

let convert_line = function
  | [] -> []
  | line::lines ->
    begin
      let line = replace_newline line in
      if is_glapi line then
        let return_type = Str.matched_group 1 line
        and function_decl = Str.matched_group 2 line in
        Printf.printf "  %s %s\n" return_type function_decl;
        lines;

      else if is_glapi_multi line then begin
        let return_type = Str.matched_group 1 line
        and function_decl = Str.matched_group 2 line in
        Printf.printf "  %s %s\n" return_type function_decl;
        let rec print_multi_cont = function
          | [] -> []
          | line::lines ->
            begin
              let line = replace_newline line in
              if is_glapi_multi_end line then begin
                Printf.printf "%s\n" line;
                lines;
              end else begin
                Printf.printf "%s\n" line;
                print_multi_cont lines;
              end;
            end in
        print_multi_cont lines
      end else if is_glapi_typedef line then begin
        Printf.printf "%s\n" line;
        lines;
      end else
          lines
    end


let replace_buffer () =
  let convert k v =
    let reg = Str.regexp (Printf.sprintf "\\b%s\\b" k) in
    buffer := List.map (Str.global_replace reg v) !buffer in
  H.iter convert typedef_hash

let convert_glapi _ =
  let rec inner_convert_line = function
    | [] -> ()
    | lines -> let lines = convert_line lines in
               inner_convert_line lines
  in
  let rec preparing_convert _ =
  (* make typedef hash and all string take into buffer *)
    let line = input_line stdin in
    begin
      buffer := line :: !buffer;
      if is_glapi_typedef line then
        let base_type = Str.matched_group 1 line
        and alias_type = Str.matched_group 2 line in
        if alias_type <> "GLenum" then
          H.add typedef_hash alias_type base_type
        else
          H.add typedef_hash alias_type "glenum"
      else
        ();

      preparing_convert ();
    end in
  try
    preparing_convert ();
  with End_of_file -> begin
        replace_buffer ();

    buffer := List.rev !buffer;
    inner_convert_line !buffer;
  end

let _ =
  convert_glapi ()
