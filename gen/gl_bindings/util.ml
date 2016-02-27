open Core.Std
  
let children elements name =
  let f = function
    | Xml.Element (tag, _, _) -> tag = name
    | _ -> false
  in
  List.filter ~f (Xml.children elements)

let child elements name =
  children elements name |> List.hd

let child_exn elements name =
  children elements name |> List.hd_exn

let text_content e =
  let rec fetch_pc_data = function
    | Xml.Element (_, _, el) -> List.map el ~f:fetch_pc_data |> List.join
    | Xml.PCData s -> [s]
  in
  Xml.map fetch_pc_data e |> List.join
