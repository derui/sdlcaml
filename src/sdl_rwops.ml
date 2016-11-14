open Core.Std
open Ctypes
open Foreign
open Sdlcaml_structures

type t = Rw_ops.t structure ptr
let t = ptr Rw_ops.t

module Inner = struct
  let rw_from_file = foreign "SDL_RWFromFile" (string @-> string @-> returning t)
  let read_u8 = foreign "SDL_ReadU8" (t @-> returning uint8_t)
  let read_be16 = foreign "SDL_ReadBE16" (t @-> returning uint16_t)
  let read_be32 = foreign "SDL_ReadBE32" (t @-> returning uint32_t)
  let read_be64 = foreign "SDL_ReadBE64" (t @-> returning uint64_t)
  let read_le16 = foreign "SDL_ReadLE16" (t @-> returning uint16_t)
  let read_le32 = foreign "SDL_ReadLE32" (t @-> returning uint32_t)
  let read_le64 = foreign "SDL_ReadLE64" (t @-> returning uint64_t)

  let write_u8 = foreign "SDL_WriteU8" (t @-> uint8_t @-> returning int)
  let write_be16 = foreign "SDL_WriteBE16" (t @-> uint16_t @-> returning int)
  let write_be32 = foreign "SDL_WriteBE32" (t @-> uint32_t @-> returning int)
  let write_be64 = foreign "SDL_WriteBE64" (t @-> uint64_t @-> returning int)
  let write_le16 = foreign "SDL_WriteLE16" (t @-> uint16_t @-> returning int)
  let write_le32 = foreign "SDL_WriteLE32" (t @-> uint32_t @-> returning int)
  let write_le64 = foreign "SDL_WriteLE64" (t @-> uint64_t @-> returning int)
end

type mode = [`Read | `Write | `Append | `ReadPlus | `WritePlus | `AppendPlus]
type size = [`Byte | `Word | `DWord | `QWord]
type value = [`Byte of int | `Word of int | `DWord of int32 | `QWord of int64]
type endian = [`Big | `Little]

let build_mode_string : bool -> mode -> string = fun binary mode ->
  let base = match mode with
    | `Read -> "r"
    | `Write -> "w"
    | `Append -> "a"
    | `ReadPlus -> "r+"
    | `WritePlus -> "w+"
    | `AppendPlus -> "a+"
  in
  if binary then base ^ "b" else base

let close ops =
  let fn = ops |-> Rw_ops.close in
  (!@fn) ops |> ignore

let read_from_file ?(binary=false) ~file ~mode () =
  let module R = Sdl_types.Resource in 
  let mode = build_mode_string binary mode in
  let rwops = Inner.rw_from_file file mode in
  R.make (fun c -> protectx ~finally:close ~f:c rwops)

let current_position ops =
  let fn = ops |-> Rw_ops.seek in
  let ret = (!@fn) ops 0L 1 in
  Sdl_util.catch (fun () -> ret <> -1L) (fun () -> ret)

let seek ops ~pos ~relative =
  let fn = ops |-> Rw_ops.seek in
  let relative = match relative with
    | `BEG -> 0
    | `CUR -> 1
    | `END -> 2
  in
  let ret = (!@fn) ops pos relative in
  Sdl_util.catch (fun () -> ret <> -1L) (fun () -> ret)

let read ops ~endian ~size =
  let open Unsigned in
  match (endian, size) with
  | (_, `Byte) -> `Byte (Inner.read_u8 ops |> UInt8.to_int)
  | (`Big, `Word) -> `Word (Inner.read_be16 ops |> UInt16.to_int)
  | (`Big, `DWord) -> `DWord (Inner.read_be32 ops |> UInt32.to_int32)
  | (`Big, `QWord) -> `QWord (Inner.read_be64 ops |> UInt64.to_int64)
  | (`Little, `Word) -> `Word (Inner.read_le16 ops |> UInt16.to_int)
  | (`Little, `DWord) -> `DWord (Inner.read_le32 ops |> UInt32.to_int32)
  | (`Little, `QWord) -> `QWord (Inner.read_le64 ops |> UInt64.to_int64)

let write ops ~endian ~value =
  let open Unsigned in
  let ret = match (endian, value) with
    | (_, `Byte v) -> UInt8.(of_int v) |> Inner.write_u8 ops
    | (`Big, `Word v) -> UInt16.(of_int v) |> Inner.write_be16 ops
    | (`Big, `DWord v) -> UInt32.(of_int32 v) |> Inner.write_be32 ops
    | (`Big, `QWord v) -> UInt64.(of_int64 v) |> Inner.write_be64 ops
    | (`Little, `Word v) -> UInt16.(of_int v) |> Inner.write_le16 ops
    | (`Little, `DWord v) -> UInt32.(of_int32 v) |> Inner.write_le32 ops
    | (`Little, `QWord v) -> UInt64.(of_int64 v) |> Inner.write_le64 ops
  in
  Sdl_util.catch (fun () -> ret = 1) ignore
