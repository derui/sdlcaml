open Ctypes

type _t
type t = _t structure ptr
let t : _t structure typ = structure "SDL_PixelFormat"

let format = field t "format" uint32_t
let palette = field t "palette" (ptr Sdl_structure_palette.t)
let bits_per_pixel = field t "BitsPerPixel" uint32_t
let bytes_per_pixel = field t "BytesPerPixel" uint32_t
let r_mask = field t "Rmask" uint32_t
let g_mask = field t "Gmask" uint32_t
let b_mask = field t "Bmask" uint32_t
let a_mask = field t "Amask" uint32_t
let _ = field t "Rloss" uint8_t
let _ = field t "Gloss" uint8_t
let _ = field t "Bloss" uint8_t
let _ = field t "Aloss" uint8_t
let _ = field t "Rshift" uint8_t
let _ = field t "Gshift" uint8_t
let _ = field t "Bshift" uint8_t
let _ = field t "Ashift" uint8_t
let _ = field t "refcount" int
let _ = field t "next" (ptr t)

(* Pixel_format does not define any conversion function such as of_ocaml and to_ocaml.
   Because allocation of SDL_PixelFormat structure is always used to SDL_AllocFormat,
   must not create it by hand.
*)

let () = seal t
