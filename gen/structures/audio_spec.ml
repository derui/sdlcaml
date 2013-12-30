open Ctypes
open Foreign

type callback = unit ptr -> Unsigned.UInt8.t ptr -> int -> unit
let audio_callback = ptr void @-> ptr uint8_t @-> int @-> returning void

type t = {
  freq: int;
  format: Sdlcaml_flags.Sdl_audio_format.t;
  channels: int;
  silence: int;
  samples: int;
  size: int32;
  callback: callback option;
}

let t : t structure typ = structure "SDL_AudioSpec"

let (|-) fld ty = field t fld ty
let freq = "freq" |- int
let format = "format" |- uint16_t
let channels = "channels" |- uint8_t
let silence = "silence" |- uint8_t
let samples = "samples" |- uint16_t
let _ = "padding" |- uint16_t
let size = "size" |- uint32_t
let callback = "callback" |- funptr_opt audio_callback
let user_data = "userdata" |- ptr void

let to_ocaml t =
  let open Unsigned in
  {
    freq = getf t freq;
    format = getf t format |> UInt16.to_int |> Sdlcaml_flags.Sdl_audio_format.of_int;
    channels = getf t channels |> UInt8.to_int;
    silence = getf t silence |> UInt8.to_int;
    samples = getf t samples |> UInt16.to_int;
    size = getf t size |> UInt32.to_int32;
    callback = getf t callback;
  }

let of_ocaml spec =
  let s = make t in
  let module F = Sdlcaml_flags.Sdl_audio_format in
  let (|<-) fld v = setf s fld v in
  freq |<- spec.freq;
  format |<- Unsigned.UInt16.(F.to_int spec.format |> of_int);
  channels |<- Unsigned.UInt8.(of_int spec.channels);
  silence |<- Unsigned.UInt8.(of_int spec.silence);
  size |<- Unsigned.UInt32.(of_int32 spec.size);
  callback |<- spec.callback;
  s

let () = seal t
