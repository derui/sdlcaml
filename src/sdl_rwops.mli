(**
   Define a module to provide handling the general interface for SDL to read and write
   data streams.

   @author derui
   @since 0.2
*)

open Ctypes
open Sdlcaml_structures

type t = Rw_ops.t structure ptr
(* the type of handling structure in this module *)

type mode = [`Read | `Write | `Append | `ReadPlus | `WritePlus | `AppendPlus]

val read_from_file: ?binary:bool -> file:string -> mode:mode -> unit -> t Sdl_types.Result.t
(* [read_from_file ~file ~mode ()] create a new Rw_ops structure for reading and/or writing
   to a named file.
*)

val close: t -> unit Sdl_types.Result.t
(* [close ops] cleans up the stream. *)

val current_position: t -> int64 Sdl_types.Result.t
(* [current_position t] query current stream position of the [t] *)

val seek: t -> pos:int64 -> relative:[< `BEG | `CUR | `END] -> int64 Sdl_types.Result.t
(* [seek t ~pos ~relative] pointer that positions the next read/write operation inthe stream. *)

type size = [`Byte | `Word | `DWord | `QWord]
(* The name of sizes to read from rw_ops. Each names are name of bits size in cpu architecture.  *)
type value = [`Byte of int | `Word of int | `DWord of int32 | `QWord of int64]
(* The name of sizes of bits size in cpu architecture.  *)

type endian = [`Big | `Little]
(* The type of endianness *)

val read: t -> endian:endian -> size:size -> value
(* [read ops ~endian ~size] read [size] bits of specified endianness [endian] data from [ops] and return in
   native format
*)

val write: t -> endian:endian -> value:value -> unit Sdl_types.Result.t
(* [write ops ~endian ~size] write [value] bits as specified endianness [endian]  *)
