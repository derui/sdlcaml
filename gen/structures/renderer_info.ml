open Ctypes

type t = {
  name : string;
  flags :Sdlcaml_flags.Sdl_renderer_flags.t list;
  num_texture_formats : int;
  texture_formats : Sdlcaml_flags.Sdl_pixel_format_enum.t list;
  max_texture_width : int;
  max_texture_height : int;
}

let t : t structure typ = structure "SDL_RendererInfo"

let name = field t "name" string
let flags = field t "flags" uint32_t
let num_texture_formats = field t "num_texture_formats" uint32_t
let texture_formats = field t "texture_formats" (array 16 uint32_t)
let max_texture_width = field t "max_texture_width" int
let max_texture_height = field t "max_texture_height" int

let flags_to_int32 flags =
  let open Sdlcaml_flags in
  List.fold_left (fun memo flag -> Int32.logor memo (Sdl_renderer_flags.to_int flag |> Int32.of_int))
    0l flags

let int32_to_flags flag =
  let open Sdlcaml_flags in
  let module F = Sdl_renderer_flags in
  let flag = Unsigned.UInt32.to_int32 flag in
  let contains target = let target = F.to_int target |> Int32.of_int in
    Int32.logand target flag = target in
  List.fold_left (fun memo target -> if contains target then target :: memo else memo)
    [] F.list

let formats_to_array formats =
  let open Sdlcaml_flags in
  let formats = List.map Sdl_pixel_format_enum.to_int32 formats |>  Array.of_list in
  let ary = Array.sub formats 0 16 in
  Array.to_list ary |> List.map Unsigned.UInt32.of_int32 |> CArray.of_list uint32_t

let array_to_formats ary =
  let open Sdlcaml_flags in
  CArray.to_list ary |> List.map Unsigned.UInt32.to_int32 |> List.map Sdl_pixel_format_enum.of_int32 

let of_ocaml s =
  let ret = make t in
  setf ret name s.name;
  setf ret flags (flags_to_int32 s.flags |> Unsigned.UInt32.of_int32);
  setf ret num_texture_formats (Int32.of_int s.num_texture_formats |> Unsigned.UInt32.of_int32);
  setf ret texture_formats (formats_to_array s.texture_formats);
  setf ret max_texture_width s.max_texture_width;
  setf ret max_texture_height s.max_texture_height;
  ret

let to_ocaml s =
  {name = getf s name;
   flags = getf s flags |> int32_to_flags; 
   num_texture_formats = getf s num_texture_formats |> Unsigned.UInt32.to_int32 |> Int32.to_int;
   texture_formats = getf s texture_formats |> array_to_formats;
   max_texture_width = getf s max_texture_width;
   max_texture_height = getf s max_texture_height;
  }

let () = seal t
