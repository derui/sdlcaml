open Ctypes
open Foreign

type t = {
  needed: bool;
  src_format: Sdlcaml_flags.Sdl_audio_format.t;
  dst_format: Sdlcaml_flags.Sdl_audio_format.t;
  rate_incr: float;
  buf: Unsigned.UInt8.t carray;
  len: int;
  len_cvt: int;
  len_mult: int;
  len_ratio: float;
}

let t : t structure typ = structure "SDL_AudioCVT"

let filter_callback = ptr t @-> uint16_t @-> returning void

let (|-) fld ty = field t fld ty
let needed = "freq" |- int
let src_format = "src_format" |- uint16_t
let dst_format = "dst_format" |- uint16_t
let rate_incr = "rate_incr" |- double
let buf = "buf" |- ptr uint8_t
let len = "len" |- int
let len_cvt = "len_cvt" |- int
let len_mult = "len_mult" |- int
let len_ratio = "len_ratio" |- double
let filters = "filters" |- (array 10 (funptr filter_callback))
let filter_index = "filter_index" |- int

let to_ocaml t =
  let open Unsigned in
  let module F = Sdlcaml_flags.Sdl_audio_format in
  let len = getf t len
  and len_mult = getf t len_mult in
  {
    needed = if getf t needed <> 1 then false else true;
    src_format = getf t src_format |> UInt16.to_int |> F.of_int;
    dst_format = getf t dst_format |> UInt16.to_int |> F.of_int;
    rate_incr = getf t rate_incr;
    buf = CArray.from_ptr (getf t buf) (len * len_mult);
    len;
    len_cvt = getf t len_cvt;
    len_mult;
    len_ratio = getf t len_ratio;
  }

let of_ocaml cvt =
  let s = make t in
  let module F = Sdlcaml_flags.Sdl_audio_format in
  let (|<-) fld v = setf s fld v in
  needed |<- if cvt.needed then 1 else 0;
  src_format |<- Unsigned.UInt16.(F.to_int cvt.src_format |> of_int);
  dst_format |<- Unsigned.UInt16.(F.to_int cvt.dst_format |> of_int);
  rate_incr |<- cvt.rate_incr;
  buf |<- CArray.start cvt.buf;
  len |<- cvt.len;
  len_cvt |<- cvt.len_cvt;
  len_mult |<- cvt.len_mult;
  len_ratio |<- cvt.len_ratio;
  s

let () = seal t
