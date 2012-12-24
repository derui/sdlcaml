(* endianness of binary data *)
type endian = Little_endian | Big_endian

(* Exception for invalid byte position when calculate offset *)
exception Binary_pack_invalid_byte_range of int
exception Binary_pack_invalid_short_range of int
exception Binary_pack_invalid_int_position of int
exception Binary_pack_invalid_int64_position of int
exception Binary_pack_invalid_float_position of int

(* Exception for invalid buffer position to write unpacked value. *)
exception Binary_pack_invalid_buffer_position of int

exception Binary_pack_invalid_offset of string
(* helper function to calculate byte offset from byte order *)
let offset ~byte_order  ~len pos =
  if len < pos || pos < 0 then
    raise (Binary_pack_invalid_offset "can not calculate a offset of byte")
  else
    match byte_order with
    | Little_endian -> len - pos - 1
    | Big_endian -> pos


let unpack_unsigned_8 ~buffer ~pos =
  assert(String.length buffer >= pos);
  Char.code buffer.[pos]
;;

let pack_unsigned_8 ~buffer ~pos value =
  assert(String.length buffer >= pos);
  if value > 0xff || value < 0 then
    raise (Binary_pack_invalid_byte_range value)
  else
    buffer.[pos] <- Char.chr value
;;

let unpack_signed_8 ~buffer ~pos =
  assert(String.length buffer >= pos);
  let ch = Char.code buffer.[pos] in
  if ch >= 0x80 then -(0x100 - ch) else ch
;;

let pack_signed_8 ~buffer ~pos value =
  assert(String.length buffer >= pos);
  if value >= 0x80 || value <= -0x81 then
    raise (Binary_pack_invalid_byte_range value)
  else
    buffer.[pos] <- Char.chr (value land 0xff)
;;

let unpack_signed_16 ~byte_order ~buffer ~pos =
  assert(String.length buffer >= pos + 1);
  let n = (Char.code buffer.[pos + offset ~byte_order ~len:2 0] lsl 8) lor
    (Char.code buffer.[pos + offset ~byte_order ~len:2 1]) in
  if n >= 0x8000 then -(0x10000 - n) else n
;;

let pack_signed_16 ~byte_order ~buffer ~pos n =
  assert(String.length buffer >= pos + 1);
  if n > 0x7fff || n < -0x8000 then
    raise (Binary_pack_invalid_short_range n)
  else begin
    buffer.[pos + offset ~byte_order ~len:2 0] <- Char.chr (n lsr 8 land 0xff);
    buffer.[pos + offset ~byte_order ~len:2 1] <- Char.chr (n land 0xff);
  end
;;

exception Binary_pack_invalid_unsigned_short_range of int
let unpack_unsigned_16 = unpack_signed_16

let pack_unsigned_16 ~byte_order ~buffer ~pos n =
  assert(String.length buffer >= pos + 1);
  if n > 0xffff || n < 0 then
    raise (Binary_pack_invalid_unsigned_short_range n)
  else begin
    buffer.[pos + offset ~byte_order ~len:2 0] <- Char.chr (n lsr 8 land 0xff);
    buffer.[pos + offset ~byte_order ~len:2 1] <- Char.chr (n land 0xff);
  end
;;

let unpack_signed_32 ~byte_order ~buffer ~pos =
  assert(String.length buffer >= pos + 3);
  let n0 = Int32.of_int (Char.code buffer.[pos + offset ~byte_order ~len:4 0]) in
  let n1 = Char.code buffer.[pos + offset ~byte_order ~len:4 1] lsl 16 in
  let n2 = Char.code buffer.[pos + offset ~byte_order ~len:4 2] lsl 8 in
  let n3 = Char.code buffer.[pos + offset ~byte_order ~len:4 3] in
  Int32.logor (Int32.shift_left n0 24) (Int32.of_int (n1 lor n2 lor n3))
;;

let unpack_signed_32_int ~byte_order ~buffer ~pos =
  assert(Sys.word_size = 32);
  assert(String.length buffer >= pos + 3);
  let n0 = Char.code buffer.[pos + offset ~byte_order ~len:4 0] lsl 24 in
  let n1 = Char.code buffer.[pos + offset ~byte_order ~len:4 1] lsl 16 in
  let n2 = Char.code buffer.[pos + offset ~byte_order ~len:4 2] lsl 8 in
  let n3 = Char.code buffer.[pos + offset ~byte_order ~len:4 3] in
  n0 lor n1 lor n2 lor n3
;;

let pack_signed_32 ~byte_order ~buffer ~pos n =
  assert(String.length buffer >= pos + 3);
  let mask = Int32.of_int 0xff in
  let n0 = Int32.to_int (Int32.logand mask (Int32.shift_right n 24))
  and n1 = Int32.to_int (Int32.logand mask (Int32.shift_right n 16))
  and n2 = Int32.to_int (Int32.logand mask (Int32.shift_right n 8))
  and n3 = Int32.to_int (Int32.logand mask n) in
  buffer.[pos + offset ~byte_order ~len:4 0] <- Char.chr n0;
  buffer.[pos + offset ~byte_order ~len:4 1] <- Char.chr n1;
  buffer.[pos + offset ~byte_order ~len:4 2] <- Char.chr n2;
  buffer.[pos + offset ~byte_order ~len:4 3] <- Char.chr n3
;;

let pack_signed_32_int ~byte_order ~buffer ~pos n =
  assert(Sys.word_size = 32);
  assert(String.length buffer >= pos + 3);
  buffer.[pos + offset ~byte_order ~len:4 0] <- Char.chr (n lsr 24 land 0xff);
  buffer.[pos + offset ~byte_order ~len:4 1] <- Char.chr (n lsr 16 land 0xff);
  buffer.[pos + offset ~byte_order ~len:4 2] <- Char.chr (n lsr 8 land 0xff);
  buffer.[pos + offset ~byte_order ~len:4 3] <- Char.chr (n land 0xff);
;;

let unpack_signed_64 ~byte_order ~buffer ~pos =
  assert(String.length buffer >= pos + 7);
  let n0 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 0])
  and n1 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 1])
  and n2 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 2])
  and n3 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 3])
  and n4 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 4])
  and n5 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 5])
  and n6 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 6])
  and n7 = Int64.of_int (Char.code buffer.[pos + offset ~byte_order ~len:8 7]) in
  Int64.logor (Int64.shift_left n0 56)
    (Int64.logor (Int64.shift_left n1 48)
       (Int64.logor (Int64.shift_left n2 40)
          (Int64.logor (Int64.shift_left n3 32)
             (Int64.logor (Int64.shift_left n4 24)
                (Int64.logor (Int64.shift_left n5 16)
                   (Int64.logor (Int64.shift_left n6 8) (Int64.shift_left n7 0)))))))
;;

let pack_signed_64 ~byte_order ~buffer ~pos n =
  assert(String.length buffer >= pos + 7);
  let mask = Int64.of_int 0xff in
  let masked len = Int64.logand mask (Int64.shift_right n len) in
  buffer.[pos + offset ~byte_order ~len:8 0] <- Char.chr (Int64.to_int (masked 56));
  buffer.[pos + offset ~byte_order ~len:8 1] <- Char.chr (Int64.to_int (masked 48));
  buffer.[pos + offset ~byte_order ~len:8 2] <- Char.chr (Int64.to_int (masked 40));
  buffer.[pos + offset ~byte_order ~len:8 3] <- Char.chr (Int64.to_int (masked 32));
  buffer.[pos + offset ~byte_order ~len:8 4] <- Char.chr (Int64.to_int (masked 24));
  buffer.[pos + offset ~byte_order ~len:8 5] <- Char.chr (Int64.to_int (masked 16));
  buffer.[pos + offset ~byte_order ~len:8 6] <- Char.chr (Int64.to_int (masked  8));
  buffer.[pos + offset ~byte_order ~len:8 7] <- Char.chr (Int64.to_int (masked  0));
;;

let unpack_float ~byte_order ~buffer ~pos =
  assert(String.length buffer >= pos + 7);
  let n = unpack_signed_64 ~byte_order ~buffer ~pos in
  Int64.float_of_bits n
;;

let pack_float ~byte_order ~buffer ~pos n =
  assert(String.length buffer >= pos + 7 );
  let bits = Int64.bits_of_float n in
  pack_signed_64 ~byte_order ~buffer ~pos bits
;;

external unpack_float_c_layout : endian -> string -> int -> float
  = "unpack_float_c_layout"

external pack_float_c_layout : endian -> string -> int -> float -> unit
  = "pack_float_c_layout"

let unpack_float_c ~byte_order ~buffer ~pos =
  unpack_float_c_layout byte_order buffer pos

let pack_float_c ~byte_order ~buffer ~pos n =
  pack_float_c_layout byte_order buffer pos n
