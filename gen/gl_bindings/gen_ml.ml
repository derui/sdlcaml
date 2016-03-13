(* Define generator for .ml of bindings. *)

module C = Command

open Core.Std
module Type_map = Map.Make(String)

let print_types ppf =
  Format.fprintf ppf "@[\
(* #1 types for bindings *)
type ('a, 'b) bigarray = ('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
@]@\n"

let print_ctype_definitions ppf commands =
  let open Core.Std in 
  let module M = Map.Make(String) in
  let params = List.map commands ~f:(fun command -> command.C.params)
  |> List.join |> List.map ~f:Tuple2.get1 in
  let ret_types = List.map commands ~f:(fun command -> command.C.proto) |> List.map ~f:Tuple2.get1 in

  let ctypes = List.join [params;ret_types] |> List.map ~f:Capi.capi_to_ocaml_type_def
  |> List.fold_left ~f:(fun map typ ->
    match typ with
    | `Unknown s -> Printf.fprintf stderr "%s" s; map
    | `Ok s -> M.add map ~key:s.Capi.Ocaml_type.name ~data:s
  ) ~init:M.empty in

  M.data ctypes |> List.iter ~f:(fun typ ->
    let module O = Capi.Ocaml_type in
    match typ.O.ctypes with
    | `Builtin _ -> ()
    | `View (name, read, write, typ) ->
       Format.fprintf ppf "@[let %s = view ~read:%s ~write:%s %s@\n@]" name read write typ
    | `Def (name, def) -> Format.fprintf ppf "@[%s@\n@]" def
    | `Conversion _ -> ()
  )

let print_packages ppf =
  Format.fprintf ppf "@[open Ctypes@\n\
open Foreign@\n
@]"

(* Ctypes foreign bindings generator *)
let generate_foreign ppf command =
  let open Core.Std in 
  let ret_typ, orig_name = command.C.proto in
  let name = Util.convert_gl_to_ocaml_name orig_name in
  match Capi.capi_to_ocaml_type_def ret_typ with
  | `Unknown s -> failwith s
  | `Ok typ -> begin
    let typ_name = Capi.ocaml_type_to_ctype_name typ in
    let params = List.map command.C.params ~f:Tuple2.get1 |> List.map ~f:Capi.capi_to_ocaml_type_def in
    let params = List.fold_left params ~f:(fun lst t ->
      match t with
      | `Unknown s -> failwith s
      | `Ok t -> t :: lst
    ) ~init: [] |> List.map ~f:Capi.ocaml_type_to_ctype_name |> List.rev
      |> String.concat ~sep:" @-> " 
    in

    Format.fprintf ppf "@[let %s = foreign \"%s\" (%s @-> returning %s)@\n@]"
      name orig_name params typ_name
  end

let generate_foreigns ppf commands =
  let open Core.Std in 
  Format.fprintf ppf "@[module Inner = struct@\n";

  List.iter commands ~f:(generate_foreign ppf);

  Format.fprintf ppf "end@\n@]"

let generate_ml ppf commands =
  print_packages ppf;
  print_types ppf;
  generate_foreigns ppf commands
