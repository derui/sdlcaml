type t =
    (* 8-bit *)
    AUDIO_S8
  | AUDIO_U8
  (* 16-bit *)
  | AUDIO_S16LSB
  | AUDIO_S16MSB
  | AUDIO_U16LSB
  | AUDIO_U16MSB
  (* 32-bit *)
  | AUDIO_S32LSB
  | AUDIO_S32MSB
  (* float *)
  | AUDIO_F32LSB
  | AUDIO_F32MSB

let to_int = function 
  | AUDIO_U8 -> 0x0008
  | AUDIO_S8 -> 0x8008
  | AUDIO_U16LSB -> 0x0010
  | AUDIO_S16LSB -> 0x8010
  | AUDIO_U16MSB -> 0x1010
  | AUDIO_S16MSB -> 0x9010
  | AUDIO_S32LSB -> 0x8020
  | AUDIO_S32MSB -> 0x9020
  | AUDIO_F32LSB -> 0x8120
  | AUDIO_F32MSB -> 0x9120

let of_int = function
  | 0x0008 -> AUDIO_U8
  | 0x8008 -> AUDIO_S8
  | 0x0010 -> AUDIO_U16LSB
  | 0x8010 -> AUDIO_S16LSB
  | 0x1010 -> AUDIO_U16MSB
  | 0x9010 -> AUDIO_S16MSB
  | 0x8020 -> AUDIO_S32LSB
  | 0x9020 -> AUDIO_S32MSB
  | 0x8120 -> AUDIO_F32LSB
  | 0x9120 -> AUDIO_F32MSB
  | _ -> failwith "No have audio_format matching given value"
