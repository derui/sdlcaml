(**
   This program is a part of Sdlcaml package.
   This program provide to make module for OCaml and include files for C source file.
   Files made by this program are used to convert between type and index of type,
   and as module including some module contained some types.

   @author derui
   @since 0.1
*)

let (|>) f g = g f
let (<|) f g = f g

type output_type =
  | Module of string * string list
  | Alone of string

let output_module_name = "enums.ml"

let xml_file = ref ""
let major_version = ref 0
let minor_version = ref 0
let modules = ref []
let sections = ref []

let arg_parse () =
  let specs =
    [("-major", Arg.Int (fun s -> major_version := s), "Major version of the OpenGL");
     ("-minor", Arg.Int (fun s -> minor_version := s), "Minor version of the OpenGL");
    ] in
  let usega = "usega: enums <xml file> -major <major version> -minor <minor version" in
  Arg.parse specs (fun s -> xml_file := s) usega

let child elements name =
  let is_name x = (Xml.tag x) = name in
  List.filter is_name (Xml.children elements)

let extract_modules xml =
  let mods = child xml "modules" in
  let extract x =
    List.iter (fun x ->
        match Xml.tag x with
        | "module" -> let name = Xml.attrib x "name" in
          let types = List.concat <| Xml.map (fun x -> Xml.map Xml.pcdata x) x in
          modules := Module (name, types) :: !modules
        | "alone-type" ->
          let name = Xml.fold (fun s x -> s ^ Xml.to_string x) "" x in
          modules := Alone name :: !modules
        | _ -> ())
      (Xml.children x)
  in
  List.iter extract mods

let extract_sections xml =
  let sects = child xml "section" in
  let extract x =
    let name = Xml.attrib x "name" in
    let pnames = List.concat <| Xml.map (fun x ->
        let version = Xml.attrib x "version" in
        Xml.map (fun x -> (Xml.pcdata x, version)) x) x in
    if List.mem_assoc name !sections then
      failwith (Printf.sprintf "%s already exists." name)
    else
      let reg = Str.regexp "GL_VERSION_\\([0-9]\\)_\\([0-9]\\)" in
      let pnames = List.filter (fun (_, version) ->
          if Str.string_match reg version 0 then
            if !major_version = 0 && !minor_version = 0 then
              true
            else if !major_version > int_of_string (Str.matched_group 1 version) then
              true
            else if !major_version = int_of_string (Str.matched_group 1 version) then
              !minor_version >= int_of_string (Str.matched_group 2 version)
            else
              false
          else false) pnames in
      sections := (name, List.map fst pnames) :: !sections in
  List.iter extract sects

let construct_includes () =
  let construct (name, pnames) =
    let file = open_out (name ^ ".inc") in
    let per_line output p = output_string output (Printf.sprintf "%s,\n" p) in
    begin
      output_string file (Printf.sprintf "static unsigned int %s[] = {\n" name);
      List.iter (per_line file) pnames;
      output_string file "};\n";
      close_out file;
    end
  in
  List.iter construct !sections

let common_construct name func =
  let file = open_out name in
  List.iter (func file) !modules;
  close_out file

let construct_modules () =
  let per_type file t =
    try
      let pnames = List.assoc t !sections in begin
        (* only type name if it has no variants *)
        if List.length pnames <> 0 then begin
          output_string file (Printf.sprintf "type %s = \n" t);
          List.iter (fun p -> output_string file (Printf.sprintf "| %s \n" p)) pnames;
        end else
          output_string file (Printf.sprintf "type %s\n" t)
      end
    with Not_found -> Printf.printf "not found type : %s\n" t in
  let construct file = function
    | Module (name, types) ->
      begin
        output_string file (Printf.sprintf "module %s : sig\n" name);
        List.iter (per_type file) types;
        output_string file "end = struct\n";
        List.iter (per_type file) types;
        output_string file "end\n"
      end;
    | Alone name -> per_type file name
  in

  common_construct output_module_name construct

let () =
  arg_parse ();
  let xml = Xml.parse_file !xml_file in
  try
    extract_modules xml;
    extract_sections xml;

    construct_includes ();
    construct_modules ();
  with Xml.Not_element s -> failwith (Printf.sprintf "%s do not have element is %s " !xml_file (Xml.to_string s))
