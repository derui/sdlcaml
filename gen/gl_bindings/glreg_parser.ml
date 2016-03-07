(**
   This program is a part of Sdlcaml package.
   This program provide to make source file that defines binding interfaces for
   OpenGL commands.

   @author derui
   @since 0.2
*)
open Core.Std

module Type_map = Map.Make(String)
type t = {
  commands: Command.t Type_map.t;
  enums: Enum.t Type_map.t;
}

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

let collect_required_commands xml major minor =
  let feature_version = float_of_string (Printf.sprintf "%d.%d" major minor) in
  let features = filter_feature xml feature_version in 
  let command_map = Type_map.empty in
  List.fold_left features ~f:(fun map feature ->
    extract_feature map feature
  ) ~init:command_map

(* collect commands from <command> tag in xml. *)
let collect_commands commands =
  let command_map = Type_map.empty in
  Type_map.fold commands ~f:(fun ~key ~data map ->
    let command' = Command.parse data in
    Type_map.add map ~key ~data:command'
  ) ~init:command_map

let parse xml ~major ~minor = 
  try
    collect_required_commands xml major minor |> collect_commands
  with _ -> failwith (Printf.sprintf "Error of parse %s" (Xml.to_string xml))
