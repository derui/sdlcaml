(**
   This program is a part of Sdlcaml package.
   This program provide to make source file that defines modules for OCaml.

   @author derui
   @since 0.2
*)
open Core.Std

let xml_file = ref ""
let major_version = ref 0
let minor_version = ref 0

type group = string * (string list)

module Enum_map = Map.Make(String)
module Enum = struct
  type t = int64

  let merge map enums =
    List.fold_left ~f:(fun map e ->
      let name = Xml.attrib e "name"
      and value = Xml.attrib e "value" |> Int64.of_string in
      Enum_map.add map ~key:name ~data:value
    ) ~init:map enums
end

let arg_parse () =
  let specs = [
    ("-major", Arg.Int (fun s -> major_version := s), "Major version of the OpenGL");
    ("-minor", Arg.Int (fun s -> minor_version := s), "Minor version of the OpenGL");
  ] in
  let usega = "usega: enums <xml file> -major <major version> -minor <minor version>" in
  Arg.parse specs (fun s -> xml_file := s) usega

let children = Util.children

let extract_groups xml =
  let groups = children xml "groups" in
  let groups = List.map ~f:(Fn.flip children "group") groups |> List.join in
  let extract e =
    let name = Xml.attrib e "name" in
    let enums = children e "enum" in
    if List.length enums = 0 then None
    else
      let enums = List.map ~f:(fun x -> Xml.attrib x "name") enums in
      Some (name, enums) in
  List.map ~f:extract groups
             |> List.fold ~f:(fun accum v ->
               match v with
               | Some v -> v :: accum 
               | None -> accum
             ) ~init:[]

let extract_enums xml =
  let enums = children xml "enums" in
  let tbl = Enum_map.empty in 
  List.fold_left ~f:(fun map e ->
    children e "enum" |> Enum.merge map
  ) ~init:tbl enums

let construct_enums groups enums =
  let convert_group_to_module_name name =
    String.fold name ~init:[] ~f:(fun l c ->
      if Char.is_uppercase c then Char.lowercase c :: '_' :: l else Char.lowercase c :: l
    )
             |> List.rev
             |> String.of_char_list
             |> fun s -> String.chop_prefix ~prefix:"_" s
             |> Option.value_map ~default:s ~f:String.capitalize
  in
  let enum_to_let_decl enum =
    let convert_const_to_let name = String.substr_replace_first name ~pattern:"GL" ~with_:"gl" in 
    let matches = List.map enum ~f:(fun (key, data) ->
      Printf.sprintf "let %s = %LdL" (convert_const_to_let key) data
    ) in
    String.concat ~sep:"\n" matches
  in
  let group_to_module (group, group_enums) =
    let enum = List.filter group_enums ~f:(fun name -> Enum_map.existsi enums ~f:(fun ~key ~data -> key = name))
             |> List.map ~f:(fun name -> (name, Enum_map.find_exn enums name))
    in
    let name = convert_group_to_module_name group in
    let let_decls = enum_to_let_decl enum in
    Printf.sprintf "module %s = struct\n%s\nend;;" name let_decls
  in
  List.map groups ~f:group_to_module |> String.concat ~sep:"\n"

let () =
  arg_parse ();
  let xml = Xml.parse_file !xml_file in
  try
    let groups = extract_groups xml in
    let enums = extract_enums xml in
    construct_enums groups enums |> print_string

  with Xml.Not_element s -> failwith (Printf.sprintf "%s do not have element is %s " !xml_file (Xml.to_string s))
