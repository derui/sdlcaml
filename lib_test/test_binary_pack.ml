open Baselib.Std.Binary_pack
open OUnit


let make_buffer len = String.create len


let test_binary_byte_pack_unpack () =
  let buffer = make_buffer 7 in
  pack_unsigned_8 ~buffer ~pos:0 0  ;
  pack_unsigned_8 ~buffer ~pos:1 1  ;
  pack_unsigned_8 ~buffer ~pos:2 2  ;
  pack_unsigned_8 ~buffer ~pos:3 3  ;
  pack_unsigned_8 ~buffer ~pos:4 4  ;
  pack_unsigned_8 ~buffer ~pos:5 100;
  pack_unsigned_8 ~buffer ~pos:6 255;

  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:0) = 0);
  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:1) = 1);
  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:2) = 2);
  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:3) = 3);
  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:4) = 4);
  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:5) = 100);
  "a unsigned byte unpack" @? ((unpack_unsigned_8 ~buffer ~pos:6) = 255);

  let buffer = make_buffer 6 in
  pack_signed_8 ~buffer ~pos:0 (-128);
  pack_signed_8 ~buffer ~pos:1 0;
  pack_signed_8 ~buffer ~pos:2 127;
  pack_signed_8 ~buffer ~pos:3 1;
  pack_signed_8 ~buffer ~pos:4 2;
  pack_signed_8 ~buffer ~pos:5 100;

  "a signed byte unpack" @? ((unpack_signed_8 ~buffer ~pos:0) = -128);
  "a signed byte unpack" @? ((unpack_signed_8 ~buffer ~pos:1) = 0);
  "a signed byte unpack" @? ((unpack_signed_8 ~buffer ~pos:2) = 127);
  "a signed byte unpack" @? ((unpack_signed_8 ~buffer ~pos:3) = 1);
  "a signed byte unpack" @? ((unpack_signed_8 ~buffer ~pos:4) = 2);
  "a signed byte unpack" @? ((unpack_signed_8 ~buffer ~pos:5) = 100);

  assert_raises (Binary_pack_invalid_byte_range (-129)) (fun () -> pack_signed_8 ~buffer ~pos:0 (-129));
  assert_raises (Binary_pack_invalid_byte_range 128) (fun () -> pack_signed_8 ~buffer ~pos:0 128);
  assert_raises (Binary_pack_invalid_byte_range 256) (fun () -> pack_unsigned_8 ~buffer ~pos:0 256);
  assert_raises (Binary_pack_invalid_byte_range (-1)) (fun () -> pack_unsigned_8 ~buffer ~pos:0 (-1));
;;

let test_binary_short_pack_unpack () =
  let buffer = make_buffer 20 in
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:0 0;
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:2 1;
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:4 20;
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:6 300;
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:8 4000;
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:10 0x7fff;
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:12 (-0x8000);
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:14 (-1);
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:16 (-0x7fff);
  pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:18 (-400);

  "a signed short unpack 0" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:0) = 0        );
  "a signed short unpack 1" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:2) = 1        );
  "a signed short unpack 2" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:4) = 20       );
  "a signed short unpack 3" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:6) = 300      );
  "a signed short unpack 4" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:8) = 4000     );
  "a signed short unpack 5" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:10) = 0x7fff   );
  "a signed short unpack 6" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:12) = (-0x8000));
  "a signed short unpack 7" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:14) = (-1)     );
  "a signed short unpack 8" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:16) = (-0x7fff));
  "a signed short unpack 9" @? ((unpack_signed_16 ~byte_order:Little_endian ~buffer ~pos:18) = (-400));

  assert_raises (Binary_pack_invalid_short_range (-0x8001))
    (fun () -> pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:0 (-0x8001));
  assert_raises (Binary_pack_invalid_short_range 0x8000)
    (fun () -> pack_signed_16 ~byte_order:Little_endian ~buffer ~pos:0 0x8000);
;;


let test_binary_int32_pack_unpack () =
  let buffer = make_buffer 40 in
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:0   (Int32.of_int 0);
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:4   (Int32.of_int 1);
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:8   (Int32.of_int 20);
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:12  (Int32.of_int 300);
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:16  (Int32.of_int 4000);
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:20  (Int32.of_int 0x7fffffff);
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:24  (Int32.of_int (-0x80000000));
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:28  (Int32.of_int (-1));
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:32  (Int32.of_int (-0x7fffffff));
  pack_signed_32 ~byte_order:Little_endian ~buffer ~pos:36  (Int32.of_int (-500000));

  let v pos = unpack_signed_32 ~byte_order:Little_endian ~buffer ~pos in
  "a signed int32 unpack 0" @? ((Int32.compare (v  0) (Int32.of_int 0            )) = 0);
  "a signed int32 unpack 1" @? ((Int32.compare (v  4) (Int32.of_int 1            )) = 0);
  "a signed int32 unpack 2" @? ((Int32.compare (v  8) (Int32.of_int 20           )) = 0);
  "a signed int32 unpack 3" @? ((Int32.compare (v 12) (Int32.of_int 300          )) = 0);
  "a signed int32 unpack 4" @? ((Int32.compare (v 16) (Int32.of_int 4000         )) = 0);
  "a signed int32 unpack 5" @? ((Int32.compare (v 20) (Int32.of_int 0x7fffffff   )) = 0);
  "a signed int32 unpack 6" @? ((Int32.compare (v 24) (Int32.of_int (-0x80000000))) = 0);
  "a signed int32 unpack 7" @? ((Int32.compare (v 28) (Int32.of_int (-1)         )) = 0);
  "a signed int32 unpack 8" @? ((Int32.compare (v 32) (Int32.of_int (-0x7fffffff))) = 0);
  "a signed int32 unpack 9" @? ((Int32.compare (v 36) (Int32.of_int (-500000)    )) = 0);
;;

let test_binary_int_pack_unpack () =
  if Sys.word_size = 32 then begin
    let buffer = make_buffer 40 in
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:0   0;
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:4   1;
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:8   20;
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:12  300;
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:16  4000;
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:20  0x3fffffff;
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:24  (-0x40000000);
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:28  (-1);
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:32  (-0x3fffffff);
    pack_signed_32_int ~byte_order:Little_endian ~buffer ~pos:36  (-500000);

    let v pos = unpack_signed_32_int ~byte_order:Little_endian ~buffer ~pos in
    "a signed ocaml int unpack 0" @? ((v  0) = 0            );
    "a signed ocaml int unpack 1" @? ((v  4) = 1            );
    "a signed ocaml int unpack 2" @? ((v  8) = 20           );
    "a signed ocaml int unpack 3" @? ((v 12) = 300          );
    "a signed ocaml int unpack 4" @? ((v 16) = 4000         );
    "a signed ocaml int unpack 5" @? ((v 20) = 0x3fffffff   );
    "a signed ocaml int unpack 6" @? ((v 24) = (-0x40000000));
    "a signed ocaml int unpack 7" @? ((v 28) = (-1)         );
    "a signed ocaml int unpack 8" @? ((v 32) = (-0x3fffffff));
    "a signed ocaml int unpack 9" @? ((v 36) = (-500000)    );
  end
;;


let test_binary_int64_pack_unpack () =
  let buffer = make_buffer 80 in
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos: 0 Int64.zero;
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos: 8 Int64.one;
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos:16 (Int64.shift_left Int64.one 5);
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos:24 (Int64.shift_left Int64.one 10);
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos:32 (Int64.shift_left Int64.one 40);
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos:40 Int64.max_int;
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos:48 Int64.min_int;
  pack_signed_64 ~byte_order:Little_endian ~buffer ~pos:56 (Int64.pred Int64.zero);

  let v pos = unpack_signed_64 ~byte_order:Little_endian ~buffer ~pos in
  "a signed int64 unpack 0" @? (Int64.compare (v  0) Int64.zero                      = 0);
  "a signed int64 unpack 1" @? (Int64.compare (v  8) Int64.one                       = 0);
  "a signed int64 unpack 2" @? (Int64.compare (v 16) (Int64.shift_left Int64.one 5)  = 0);
  "a signed int64 unpack 3" @? (Int64.compare (v 24) (Int64.shift_left Int64.one 10) = 0);
  "a signed int64 unpack 4" @? (Int64.compare (v 32) (Int64.shift_left Int64.one 40) = 0);
  "a signed int64 unpack 5" @? (Int64.compare (v 40) Int64.max_int                   = 0);
  "a signed int64 unpack 6" @? (Int64.compare (v 48) Int64.min_int                   = 0);
  "a signed int64 unpack 7" @? (Int64.compare (v 56) (Int64.pred Int64.zero)         = 0);
;;

let test_binary_float_pack_unpack () =
  let buffer = make_buffer 80 in
  pack_float ~byte_order:Little_endian ~buffer ~pos: 0 1.0;
  pack_float ~byte_order:Little_endian ~buffer ~pos: 8 0.0;
  pack_float ~byte_order:Little_endian ~buffer ~pos:16 100.0;
  pack_float ~byte_order:Little_endian ~buffer ~pos:24 100e10;
  pack_float ~byte_order:Little_endian ~buffer ~pos:32 203e5;
  pack_float ~byte_order:Little_endian ~buffer ~pos:40 nan;
  pack_float ~byte_order:Little_endian ~buffer ~pos:48 max_float;
  pack_float ~byte_order:Little_endian ~buffer ~pos:56 min_float;

  let v pos = unpack_float ~byte_order:Little_endian ~buffer ~pos in
  "a float unpack 0" @? ((v  0) = 1.0        );
  "a float unpack 1" @? ((v  8) = 0.0        );
  "a float unpack 2" @? ((v 16) = 100.0      );
  "a float unpack 3" @? ((v 24) = 100e10     );
  "a float unpack 4" @? ((v 32) = 203e5      );
  "a float unpack 5" @? ((v 40) <> nan        );
  "a float unpack 6" @? ((v 48) = max_float  );
  "a float unpack 7" @? ((v 56) = min_float  );
;;

let test_binary_c_layout_float_pack_unpack () =
  let buffer = make_buffer 40 in
  pack_float_c ~byte_order:Little_endian ~buffer ~pos: 0 1.0;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos: 4 0.0;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos: 8 100.0;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos:12 1e10;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos:16 203e5;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos:20 nan;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos:24 max_float;
  pack_float_c ~byte_order:Little_endian ~buffer ~pos:28 min_float;

  let v pos = unpack_float_c ~byte_order:Little_endian ~buffer ~pos in
  "a float unpack 0" @? ((v  0) = 1.0        );
  "a float unpack 1" @? ((v  4) = 0.0        );
  "a float unpack 2" @? ((v  8) = 100.0      );
  "a float unpack 3" @? ((v 12) = 1e10      );
  "a float unpack 4" @? ((v 16) = 203e5      );
  "a float unpack 5" @? ((v 20) <> nan        );
  "a float unpack 6" @? ((v 24) = infinity  );
  "a float unpack 7" @? ((v 28) = 0.0  );
;;

let suite = "binary pack/unpack specs" >::: [
  "a byte pack/unpack" >:: test_binary_byte_pack_unpack;
  "a short pack/unpack" >:: test_binary_short_pack_unpack;
  "a 32-bit int pack/unpack" >:: test_binary_int32_pack_unpack;
  "a 32-bit ocaml int pack/unpack" >:: test_binary_int_pack_unpack;
  "a 64-bit int pack/unpack" >:: test_binary_int64_pack_unpack;
  "a float pack/unpack" >:: test_binary_float_pack_unpack;
  "a C layout float pack/unpack" >:: test_binary_c_layout_float_pack_unpack;
]

let _ =
  let results = run_test_tt_main suite in
  if List.for_all (fun x -> match x with
  | RSuccess _ -> true
  | _ -> false) results then
    exit 0
  else
    exit 1
