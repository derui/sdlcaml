open Ctypes
open Foreign
open Sdlcaml_structures
open Sdlcaml_flags

module Inner = struct
  let get_pixel_format_name = foreign "SDL_GetPixelFormatName" (uint32_t @-> returning string)
  let get_rgb = foreign "SDL_GetRGB" (uint32_t @-> ptr Pixel_format.t @->
                                      ptr uint8_t @-> ptr uint8_t @-> ptr uint8_t @->
                                      returning void)
  let map_rgb = foreign "SDL_MapRGB" (ptr Pixel_format.t @->
                                      uint8_t @-> uint8_t @-> uint8_t @-> returning uint32_t)
  let map_rgba = foreign "SDL_MapRGBA" (ptr Pixel_format.t @->
                                        uint8_t @-> uint8_t @-> uint8_t @-> uint8_t @-> returning uint32_t)
end

let get_pixel_format_name format =
  let format = Sdl_pixel_format_enum.to_int32 format in
  Inner.get_pixel_format_name (Unsigned.UInt32.of_int32 format)

let get_rgb ~pixel ~format =
  let module U = Unsigned.UInt8 in
  let module U32 = Unsigned.UInt32 in
  let module A = CArray in
  let ary = CArray.make uint8_t 3 in
  let ptr_of_ary index = A.start ary +@ index in
  let get_as_int index = A.get ary index |> U.to_int in
  Inner.get_rgb (U32.of_int32 pixel) format (ptr_of_ary 0) (ptr_of_ary 1) (ptr_of_ary 2);
  {Color.r = get_as_int 0;g = get_as_int 1;b = get_as_int 2; a = 0}

let map_rgb ~format ~color =
  let module U = Unsigned.UInt8 in
  let module U32 = Unsigned.UInt32 in
  let r = U.of_int color.Color.r
  and g = U.of_int color.Color.g
  and b = U.of_int color.Color.b in
  Inner.map_rgb format r g b |> U32.to_int32

let map_rgba ~format ~color =
  let module U = Unsigned.UInt8 in
  let module U32 = Unsigned.UInt32 in
  let r = U.of_int color.Color.r
  and g = U.of_int color.Color.g
  and b = U.of_int color.Color.b
  and a = U.of_int color.Color.a in
  Inner.map_rgba format r g b a |> U32.to_int32
