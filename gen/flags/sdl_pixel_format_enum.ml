module Pixel_type = struct
  type t = SDL_PIXELTYPE_UNKNOWN
         | SDL_PIXELTYPE_INDEX1
         | SDL_PIXELTYPE_INDEX4
         | SDL_PIXELTYPE_INDEX8
         | SDL_PIXELTYPE_PACKED8
         | SDL_PIXELTYPE_PACKED16
         | SDL_PIXELTYPE_PACKED32
         | SDL_PIXELTYPE_ARRAYU8
         | SDL_PIXELTYPE_ARRAYU16
         | SDL_PIXELTYPE_ARRAYU32
         | SDL_PIXELTYPE_ARRAYF16
         | SDL_PIXELTYPE_ARRAYF32

  let to_int = function
    | SDL_PIXELTYPE_UNKNOWN -> 0l
    | SDL_PIXELTYPE_INDEX1 -> 1l
    | SDL_PIXELTYPE_INDEX4 -> 2l
    | SDL_PIXELTYPE_INDEX8 -> 3l
    | SDL_PIXELTYPE_PACKED8 -> 4l
    | SDL_PIXELTYPE_PACKED16 -> 5l
    | SDL_PIXELTYPE_PACKED32 -> 6l
    | SDL_PIXELTYPE_ARRAYU8 -> 7l
    | SDL_PIXELTYPE_ARRAYU16 -> 8l
    | SDL_PIXELTYPE_ARRAYU32 -> 9l
    | SDL_PIXELTYPE_ARRAYF16 -> 10l
    | SDL_PIXELTYPE_ARRAYF32 -> 11l
end

module Packed_order = struct
  type t = SDL_PACKEDORDER_NONE
         | SDL_PACKEDORDER_XRGB
         | SDL_PACKEDORDER_RGBX
         | SDL_PACKEDORDER_ARGB
         | SDL_PACKEDORDER_RGBA
         | SDL_PACKEDORDER_XBGR
         | SDL_PACKEDORDER_BGRX
         | SDL_PACKEDORDER_ABGR
         | SDL_PACKEDORDER_BGRA
         | SDL_BITMAPORDER_NONE
         | SDL_BITMAPORDER_4321
         | SDL_BITMAPORDER_1234

  let to_int = function
    | SDL_PACKEDORDER_NONE -> 0l
    | SDL_PACKEDORDER_XRGB -> 1l
    | SDL_PACKEDORDER_RGBX -> 2l
    | SDL_PACKEDORDER_ARGB -> 3l
    | SDL_PACKEDORDER_RGBA -> 4l
    | SDL_PACKEDORDER_XBGR -> 5l
    | SDL_PACKEDORDER_BGRX -> 6l
    | SDL_PACKEDORDER_ABGR -> 7l
    | SDL_PACKEDORDER_BGRA -> 8l
    | SDL_BITMAPORDER_NONE -> 0l
    | SDL_BITMAPORDER_4321 -> 1l
    | SDL_BITMAPORDER_1234 -> 2l
end

module Array_order = struct
  type t = SDL_ARRAYORDER_NONE
         | SDL_ARRAYORDER_RGB
         | SDL_ARRAYORDER_RGBA
         | SDL_ARRAYORDER_ARGB
         | SDL_ARRAYORDER_BGR
         | SDL_ARRAYORDER_BGRA
         | SDL_ARRAYORDER_ABG
  let to_int = function
    | SDL_ARRAYORDER_NONE -> 0l
    | SDL_ARRAYORDER_RGB -> 1l
    | SDL_ARRAYORDER_RGBA -> 2l
    | SDL_ARRAYORDER_ARGB -> 3l
    | SDL_ARRAYORDER_BGR -> 4l
    | SDL_ARRAYORDER_BGRA -> 5l
    | SDL_ARRAYORDER_ABG -> 6l
end

module Packed_layout = struct
  type t = SDL_PACKEDLAYOUT_NONE
         | SDL_PACKEDLAYOUT_332
         | SDL_PACKEDLAYOUT_4444
         | SDL_PACKEDLAYOUT_1555
         | SDL_PACKEDLAYOUT_5551
         | SDL_PACKEDLAYOUT_565
         | SDL_PACKEDLAYOUT_8888
         | SDL_PACKEDLAYOUT_2101010
         | SDL_PACKEDLAYOUT_1010102

  let to_int = function
    | SDL_PACKEDLAYOUT_NONE -> 0l
    | SDL_PACKEDLAYOUT_332 -> 1l
    | SDL_PACKEDLAYOUT_4444 -> 2l
    | SDL_PACKEDLAYOUT_1555 -> 3l
    | SDL_PACKEDLAYOUT_5551 -> 4l
    | SDL_PACKEDLAYOUT_565 -> 5l
    | SDL_PACKEDLAYOUT_8888 -> 6l
    | SDL_PACKEDLAYOUT_2101010 -> 7l
    | SDL_PACKEDLAYOUT_1010102 -> 8l

end

let define_fourcc a b c d =
  let (|-|) = Int32.logor
  and (<-<) = Int32.shift_left in
  let a = Int32.of_int (a lor 0xff)
  and b = Int32.of_int (b lor 0xff)
  and c = Int32.of_int (c lor 0xff)
  and d = Int32.of_int (d lor 0xff) in
  (a <-< 0) |-| (b <-< 8) |-| (c <-< 16) |-| (d <-< 24)

let define_pixelformat pixel_type order layout bits bytes =
  let mlb = Int32.shift_left 1l 28 in
  let pixel_type = Int32.shift_left (Pixel_type.to_int pixel_type) 24 in
  let order = Int32.shift_left (Packed_order.to_int order) 20 in
  let layout = Int32.shift_left (Packed_layout.to_int layout) 16 in
  let bits = Int32.shift_left bits 8 in
  let bytes = Int32.shift_left bytes 0 in
  let (|-|) = Int32.logor in
  mlb |-| pixel_type |-| order |-| layout |-| bits |-| bytes

type t =
    SDL_PIXELFORMAT_YVYU
  | SDL_PIXELFORMAT_UYVY
  | SDL_PIXELFORMAT_YUY2
  | SDL_PIXELFORMAT_IYUV
  | SDL_PIXELFORMAT_YV12
  | SDL_PIXELFORMAT_ARGB2101010
  | SDL_PIXELFORMAT_BGRA8888
  | SDL_PIXELFORMAT_ABGR8888
  | SDL_PIXELFORMAT_RGBA8888
  | SDL_PIXELFORMAT_ARGB8888
  | SDL_PIXELFORMAT_BGRX8888
  | SDL_PIXELFORMAT_BGR888
  | SDL_PIXELFORMAT_RGBX8888
  | SDL_PIXELFORMAT_RGB888
  | SDL_PIXELFORMAT_BGR24
  | SDL_PIXELFORMAT_RGB24
  | SDL_PIXELFORMAT_BGR565
  | SDL_PIXELFORMAT_RGB565
  | SDL_PIXELFORMAT_BGRA5551
  | SDL_PIXELFORMAT_RGBA5551
  | SDL_PIXELFORMAT_BGRA4444
  | SDL_PIXELFORMAT_RGBA4444
  | SDL_PIXELFORMAT_ARGB4444
  | SDL_PIXELFORMAT_ARGB1555
  | SDL_PIXELFORMAT_ABGR1555
  | SDL_PIXELFORMAT_BGR555
  | SDL_PIXELFORMAT_RGB555
  | SDL_PIXELFORMAT_RGB444
  | SDL_PIXELFORMAT_RGB332
  | SDL_PIXELFORMAT_INDEX8
  | SDL_PIXELFORMAT_INDEX4MSB
  | SDL_PIXELFORMAT_INDEX4LSB
  | SDL_PIXELFORMAT_INDEX1MSB
  | SDL_PIXELFORMAT_INDEX1LSB
  | SDL_PIXELFORMAT_UNKNOWN

let pixel_format_map = [
  (SDL_PIXELFORMAT_UNKNOWN ,0l);
  (SDL_PIXELFORMAT_INDEX1LSB ,define_pixelformat Pixel_type.SDL_PIXELTYPE_INDEX1 Packed_order.SDL_BITMAPORDER_4321 Packed_layout.SDL_PACKEDLAYOUT_NONE 1l 0l);
  (SDL_PIXELFORMAT_INDEX1MSB ,define_pixelformat Pixel_type.SDL_PIXELTYPE_INDEX1 Packed_order.SDL_BITMAPORDER_1234 Packed_layout.SDL_PACKEDLAYOUT_NONE 1l 0l);
  (SDL_PIXELFORMAT_INDEX4LSB ,define_pixelformat Pixel_type.SDL_PIXELTYPE_INDEX4 Packed_order.SDL_BITMAPORDER_4321 Packed_layout.SDL_PACKEDLAYOUT_NONE 4l 0l);
  (SDL_PIXELFORMAT_INDEX4MSB ,define_pixelformat Pixel_type.SDL_PIXELTYPE_INDEX4 Packed_order.SDL_BITMAPORDER_1234 Packed_layout.SDL_PACKEDLAYOUT_NONE 4l 0l);
  (SDL_PIXELFORMAT_INDEX8 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_INDEX8 Packed_order.SDL_BITMAPORDER_NONE Packed_layout.SDL_PACKEDLAYOUT_NONE 8l 1l);
  (SDL_PIXELFORMAT_RGB332 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED8 Packed_order.SDL_PACKEDORDER_XRGB Packed_layout.SDL_PACKEDLAYOUT_332 8l 1l);
  (SDL_PIXELFORMAT_RGB444 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_XRGB Packed_layout.SDL_PACKEDLAYOUT_4444 12l 2l);
  (SDL_PIXELFORMAT_RGB565 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_XRGB Packed_layout.SDL_PACKEDLAYOUT_1555 15l 2l);
  (SDL_PIXELFORMAT_BGR555 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_XBGR Packed_layout.SDL_PACKEDLAYOUT_1555 15l 2l);

  (SDL_PIXELFORMAT_ARGB4444 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_ARGB Packed_layout.SDL_PACKEDLAYOUT_4444 16l 2l);
  (SDL_PIXELFORMAT_RGBA4444 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_RGBA Packed_layout.SDL_PACKEDLAYOUT_4444 16l 2l);
  (SDL_PIXELFORMAT_BGRA4444 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_BGRA Packed_layout.SDL_PACKEDLAYOUT_4444 16l 2l);

  (SDL_PIXELFORMAT_ARGB1555 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_ARGB Packed_layout.SDL_PACKEDLAYOUT_1555 16l 2l);

  (SDL_PIXELFORMAT_RGBA5551 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_RGBA Packed_layout.SDL_PACKEDLAYOUT_5551 16l 2l);

  (SDL_PIXELFORMAT_ABGR1555 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_ABGR Packed_layout.SDL_PACKEDLAYOUT_1555 16l 2l);

  (SDL_PIXELFORMAT_BGRA5551 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_BGRA Packed_layout.SDL_PACKEDLAYOUT_5551 16l 2l);

  (SDL_PIXELFORMAT_RGB565 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_XRGB Packed_layout.SDL_PACKEDLAYOUT_565 16l 2l);

  (SDL_PIXELFORMAT_BGR565 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED16 Packed_order.SDL_PACKEDORDER_XBGR Packed_layout.SDL_PACKEDLAYOUT_565 16l 2l);

  (SDL_PIXELFORMAT_RGB24 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_ARRAYU8 Packed_order.SDL_PACKEDORDER_RGBX Packed_layout.SDL_PACKEDLAYOUT_NONE 24l 3l);

  (SDL_PIXELFORMAT_BGR24 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_ARRAYU8 Packed_order.SDL_PACKEDORDER_BGRX Packed_layout.SDL_PACKEDLAYOUT_NONE 24l 3l);

  (SDL_PIXELFORMAT_RGB888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_XRGB Packed_layout.SDL_PACKEDLAYOUT_8888 24l 4l);

  (SDL_PIXELFORMAT_RGBX8888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_RGBX Packed_layout.SDL_PACKEDLAYOUT_8888 24l 4l);

  (SDL_PIXELFORMAT_BGR888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_XBGR Packed_layout.SDL_PACKEDLAYOUT_8888 24l 4l);

  (SDL_PIXELFORMAT_BGRX8888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_BGRX Packed_layout.SDL_PACKEDLAYOUT_8888 24l 4l);

  (SDL_PIXELFORMAT_ARGB8888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_ARGB Packed_layout.SDL_PACKEDLAYOUT_8888 32l 4l);

  (SDL_PIXELFORMAT_RGBA8888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_RGBA Packed_layout.SDL_PACKEDLAYOUT_8888 32l 4l);

  (SDL_PIXELFORMAT_ABGR8888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_ABGR Packed_layout.SDL_PACKEDLAYOUT_8888 32l 4l);

  (SDL_PIXELFORMAT_BGRA8888 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_BGRA Packed_layout.SDL_PACKEDLAYOUT_8888 32l 4l);

  (SDL_PIXELFORMAT_ARGB2101010 ,define_pixelformat Pixel_type.SDL_PIXELTYPE_PACKED32 Packed_order.SDL_PACKEDORDER_ARGB Packed_layout.SDL_PACKEDLAYOUT_2101010 32l 4l);

  (SDL_PIXELFORMAT_YV12 ,define_fourcc (int_of_char 'Y') (int_of_char 'V') (int_of_char '1') (int_of_char '2'));
  (SDL_PIXELFORMAT_IYUV ,define_fourcc (int_of_char 'I') (int_of_char 'Y') (int_of_char 'U') (int_of_char 'V'));
  (SDL_PIXELFORMAT_YUY2 ,define_fourcc (int_of_char 'Y') (int_of_char 'U') (int_of_char 'Y') (int_of_char '2'));
  (SDL_PIXELFORMAT_UYVY ,define_fourcc (int_of_char 'U') (int_of_char 'Y') (int_of_char 'Y') (int_of_char 'Y'));
  (SDL_PIXELFORMAT_YVYU ,define_fourcc (int_of_char 'Y') (int_of_char 'V') (int_of_char 'Y') (int_of_char 'U'));
]

let to_int32 fmt =
  snd (List.find (fun (typ, _) -> typ = fmt) pixel_format_map)

let of_int32 target =
  fst (List.find (fun (_, v) -> v = target) pixel_format_map)
