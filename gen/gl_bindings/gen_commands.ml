(**
   This program is a part of Sdlcaml package.
   This program provide to make source file that defines binding interfaces for
   OpenGL commands.

   @author derui
   @since 0.2
*)
open Core.Std

let xml_file = ref ""
let major_version = ref 0
let minor_version = ref 0

module Type_map = Map.Make(String)
module Command = struct
  type param = string * string
  type t = {
    return_value: string option;
    name: string;
    params: param list;
    alias: string option
  }
end

(* mapping ptype tag in gl.xml with OCaml type defined in CTypes.
   This mapping already defined in gl.xml, but there has been written
   as C definition, so cost for me parse and manage there.
*)
let ptype_mapping =
  let map = Type_map.empty in
  let mappings = [
    ("GLenum", "uint32_t");
    ("GLboolean", "uint8_t");
    ("GLbitfield", "uint32_t");
    ("GLvoid", "void");
    ("GLbyte", "int");
    ("GLshort", "int16_t");
    ("GLint", "int32_t");
    ("GLintptr", "ptr int32_t");
    ("GLclampx", "int32_t");
    ("GLubyte", "uint8_t");
    ("GLushort", "uint16_t");
    ("GLuint", "uint32_t");
    ("GLsizei", "int32_t");
    ("GLsizeiptr", "ptr int32_t");
    ("GLfloat", "float");
    ("GLclampf", "float");
    ("GLdouble", "float");
    ("GLclampd", "float");
    ("GLeglImageOES", "ptr void");
    ("GLchar", "int");
    ("GLcharARB", "int");
    ("GLhalfARB", "uint16_t");
    ("GLhalf", "uint16_t");
    ("GLfixed", "int32_t");
    ("GLint64", "int64_t");
    ("GLuint64", "uint64_t");
    ("GLint64EXT", "int64_t");
    ("GLuint64EXT", "uint64_t");
    ("GLsync", "Gl_types.Sync.t");
    ("GLhandleARB", "uint32_t");
    ("void", "void");
  ] in
  List.fold_left mappings ~f:(fun map (key, data) -> Type_map.add map ~key ~data)
    ~init:map

let arg_parse () =
  let specs = [
    ("-major", Arg.Int (fun s -> major_version := s), "Major version of the OpenGL");
    ("-minor", Arg.Int (fun s -> minor_version := s), "Minor version of the OpenGL");
  ] in
  let usega = "usega: gen_commands <xml file> -major <major version> -minor <minor version>" in
  Arg.parse specs (fun s -> xml_file := s) usega

let filter_feature xml version =
  let features = Util.children xml "feature" in
  List.filter features ~f:(fun feature ->
    let version' = Xml.attrib feature "number" |> float_of_string in
    version >= version'
  )

(* extract commands in the feature and merge into a large commands *)
let extract_feature map feature =
  let requirements = Util.children feature "require"
  and removings = Util.children feature "remove" in
  let required_commands = List.map ~f:(Fn.flip Util.children "command") requirements |> List.join in
  let map = List.fold_left required_commands ~f:(fun map command ->
    let name = Xml.attrib command "name" in
    Type_map.add map ~key:name ~data:command
  ) ~init:map in 
  let removed_commands = List.map ~f:(Fn.flip Util.children "command") removings |> List.join in
  List.fold_left removed_commands ~f:(fun map command ->
    let name = Xml.attrib command "name" in
    Type_map.remove map name
  ) ~init:map

let collect_feature_commands xml =
  let feature_version = float_of_string (Printf.sprintf "%d.%d" !major_version !minor_version) in
  let features = filter_feature xml feature_version in 
  let command_map = Type_map.empty in
  List.fold_left features ~f:(fun map feature ->
    extract_feature map feature
  ) ~init:command_map

let parse_param param =
  let parsed = Util.text_content param in
  let (valid_typ, is_ptr) = List.map parsed ~f:(String.split ~on:' ')
    |> List.join
    |> List.filter ~f:(fun s -> s <> "const")
    |> List.fold_left ~f:(fun (current_typ, is_ptr) s ->
      if s = "*" then (current_typ, true)
      else
        match Type_map.find ptype_mapping s with
        | None -> (current_typ, is_ptr)
        | Some s -> (s, is_ptr)
    ) ~init:("", false)
  in
  let typ = if is_ptr then ["ptr"; valid_typ] else [valid_typ] in
  String.concat ~sep:" " typ

(* parse and construct command type from <command> tag *)
let extract_command xml =
  let proto = Util.child_exn xml "proto" in
  let params = Util.children xml "param" in
  let proto_name = Util.child_exn proto "name" |> (fun e -> Util.text_content e) in 
  let proto_ptype = Util.children proto "ptype" in
  let proto_ptype = if List.is_empty proto_ptype then None
    else Some (List.hd_exn proto_ptype |> Util.text_content |> String.concat) in
  let params = List.map params ~f:(fun param ->
    let name = Util.child_exn param "name" |> fun e -> Util.text_content e in
    (parse_param param, String.concat name)
  ) in
  {
    Command.name = String.concat proto_name;
    return_value = proto_ptype;
    params;
    alias = Util.child xml "alias" |> Option.map ~f:(fun xml -> Xml.attrib xml "name")
  }

(* collect commands from <command> tag in xml. *)
let collect_commands xml =
  let commands = Util.children xml "commands" in
  let commands = List.map commands ~f:(Fn.flip Util.children "command") |> List.join in
  let command_map = Type_map.empty in
  List.fold_left commands ~f:(fun map command ->
    let command' = extract_command command in
    Type_map.add map ~key:command'.Command.name ~data:command'
  ) ~init:command_map

let construct_bindings feature commands =
  let gen_param_list =
   Fn.compose List.rev
       (List.fold_left ~f:(fun lst (ptype, name) ->
         Printf.sprintf "%s" ptype :: lst
        ) ~init:[])
    |> Fn.compose (String.concat ~sep:" @-> ")
  in
  let gen_binding = function
    | Some {Command.return_value; name;params;_} ->
       let open Option in
       let return = (return_value >>= fun v -> Type_map.find ptype_mapping v) |> Option.value ~default:"void" in
       let caml_name = String.fold name ~f:(fun lst c ->
         if Char.is_uppercase c then
           if List.is_empty lst then Char.lowercase c :: lst else Char.lowercase c :: '_' :: lst
         else
           c :: lst
       ) ~init:[] |> List.rev |> String.of_char_list
       in
       Printf.sprintf "let %s = foreign \"%s\" (%s @-> returning %s)"
         caml_name name (if List.is_empty params then "void" else gen_param_list params) return
    | None -> ""
  in
  let bindings = Type_map.keys feature
    |> List.map ~f:(Type_map.find commands)
    |> List.filter ~f:Option.is_some
    |> List.map ~f:gen_binding
    |> String.concat ~sep:"\n"
  in
  Printf.sprintf "%s\n" bindings

let () =
  arg_parse ();
  let xml = Xml.parse_file !xml_file in
  try
    collect_feature_commands xml
    |> fun feature_commands -> collect_commands xml
    |> fun commands -> construct_bindings feature_commands commands
    |> fun bindings -> List.iter ["Ctypes";"Foreign"] ~f:(Printf.printf "open %s\n%!")
    |> fun () -> Printf.printf "%s\n%!" bindings

  with Xml.Not_element s -> failwith (Printf.sprintf "%s do not have element is %s" !xml_file (Xml.to_string s))
