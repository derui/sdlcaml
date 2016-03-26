open Ctypes
type t = {
  data: int array;
}

let t : t structure typ = structure "SDL_JoystickGUID"

let data = field t "data" (ptr uint8_t)

let to_ocaml guid =
  let data = getf guid data in
  let data = CArray.from_ptr data 16 |> CArray.to_list |> List.map Unsigned.UInt8.to_int |> Array.of_list in
  {data}

let of_ocaml guid =
  let ret = make t in
  let raw_data = Array.map Unsigned.UInt8.of_int guid.data |> Array.to_list |> CArray.of_list uint8_t in
  setf ret data (CArray.start raw_data);
  ret

let () = seal t
