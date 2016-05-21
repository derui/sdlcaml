open Sdlcaml_structures
open Ctypes
open Foreign

type ('a, 'b) bigarray = ('a, 'b, Bigarray.c_layout) Bigarray.Array1.t
type t = Sdl_types.Surface.t
let t = Sdl_types.Surface.t

exception Sdl_surface_exception of string

module Inner = struct
  let blit_scaled = foreign "SDL_UpperBlitScaled" (t @-> ptr Rect.t @-> t @-> ptr Rect.t @-> returning int)
  let blit_surface = foreign "SDL_UpperBlit" (t @-> ptr Rect.t @-> t @-> ptr Rect.t @-> returning int)
  let convert_surface = foreign "SDL_ConvertSurface"
    (t @-> ptr Pixel_format.t @-> uint32_t @-> returning (t))
  let convert_surface_format =
    foreign "SDL_ConvertSurfaceFormat" (t @-> uint32_t @-> uint32_t @-> returning t)
  let create_rgb_surface =
    foreign "SDL_CreateRGBSurface" (uint32_t @-> int @-> int @-> int @->
                                    uint32_t @-> uint32_t @-> uint32_t @-> uint32_t @->
                                    returning (t))
  let fill_rect = foreign "SDL_FillRect" (t @-> ptr Rect.t @-> uint32_t @-> returning int)
  let fill_rects = foreign "SDL_FillRects" (t @-> ptr Rect.t @-> int @-> uint32_t @-> returning int)
  let free_surface = foreign "SDL_FreeSurface" (t @-> returning void)
  let get_clip_rect = foreign "SDL_GetClipRect" (t @-> ptr Rect.t @-> returning void)
  let get_color_key = foreign "SDL_GetColorKey" (t @-> ptr uint32_t @-> returning int)
  let get_surface_alpha_mod = foreign "SDL_GetSurfaceAlphaMod" (t @-> ptr uint8_t @-> returning int)
  let get_surface_blend_mode = foreign "SDL_GetSurfaceBlendMode" (t @-> ptr uint32_t @-> returning int)
  let get_surface_color_mod = foreign "SDL_GetSurfaceColorMod" (t @->
                                                                ptr uint8_t @->
                                                                ptr uint8_t @->
                                                                ptr uint8_t @-> returning int)
  let lock_surface = foreign "SDL_LockSurface" (t @-> returning int)
  let lower_blit = foreign "SDL_LowerBlit" (t @-> ptr Rect.t @-> t @-> ptr Rect.t @-> returning int)
  let lower_blit_scaled = foreign "SDL_LowerBlitScaled" (t @-> ptr Rect.t @-> t @-> ptr Rect.t @-> returning int)
  let set_clip_rect = foreign "SDL_SetClipRect" (t @-> ptr Rect.t @-> returning int)
  let set_color_key = foreign "SDL_SetColorKey" (t @-> int @-> uint32_t @-> returning int)
  let set_surface_alpha_mod = foreign "SDL_SetSurfaceAlphaMod" (t @-> uint8_t @-> returning int)
  let set_surface_blend_mode = foreign "SDL_SetSurfaceBlendMode" (t @-> uint32_t @-> returning int)
  let set_surface_color_mod = foreign "SDL_SetSurfaceColorMod" (t @->
                                                                uint8_t @-> uint8_t @-> uint8_t @->
                                                                returning int)
  let set_surface_rle = foreign "SDL_SetSurfaceRLE" (t @-> int @-> returning int)
  let unlock_surface = foreign "SDL_UnlockSurface" (t @-> returning void)
end

let catch = Sdl_util.catch

let blit_scaled ~src ?srcrect ~dst ?dstrect () =
  let null_rect = from_voidp Rect.t null in
  let srcrect = match srcrect with None -> null_rect | Some r -> Rect.of_ocaml r |> addr
  and dstrect = match dstrect with None -> null_rect | Some r -> Rect.of_ocaml r |> addr in
  let ret = Inner.blit_scaled src srcrect dst dstrect in
  catch (fun _ -> ret = 0) ignore

let blit_surface ~src ?srcrect ~dst ?dstrect () =
  let null_rect = from_voidp Rect.t null in
  let srcrect = match srcrect with None -> null_rect | Some r -> Rect.of_ocaml r |> addr
  and dstrect = match dstrect with None -> null_rect | Some r -> Rect.of_ocaml r |> addr in
  let ret = Inner.blit_surface src srcrect dst dstrect in
  catch (fun _ -> ret = 0) ignore

let convert ~src ~format () =
  let ret = Inner.convert_surface src format (Unsigned.UInt32.of_int32 0l) in
  catch (fun () -> to_voidp ret <> null) (fun () -> ret)

let convert_format ~src ~fmt =
  let open Sdlcaml_flags in
  let module U = Unsigned.UInt32 in
  let format = Sdl_pixel_format_enum.to_int32 fmt in
  let surface = Inner.convert_surface_format src (U.of_int32 format) (U.of_int32 0l) in
  catch (fun _ -> to_voidp surface <> null) (fun _ -> surface)

let fill_rect ~dst ?rect ~color () =
  let rect = match rect with
    | Some r -> Rect.of_ocaml r |> addr
    | None -> from_voidp Rect.t null in
  let ret = Inner.fill_rect dst rect (Unsigned.UInt32.of_int32 color) in
  catch (fun _ -> ret = 0) ignore

let fill_rects ~dst ~rects ~color =
  let module U = Unsigned.UInt32 in
  let rects = List.map Rect.of_ocaml rects |> CArray.of_list Rect.t in
  let ret = Inner.fill_rects dst (CArray.start rects) (CArray.length rects) (U.of_int32 color) in
  catch (fun _ -> ret = 0) ignore

let create_argb_surface ~width ~height =
  let module U = Unsigned.UInt32 in
  let zero = U.of_int32 0l in
  let surface = Inner.create_rgb_surface zero width height 32 zero zero zero zero in
  catch (fun () -> to_voidp surface <> null) (fun () -> surface)

let free t = Inner.free_surface t |> Sdl_types.Result.return
let lock t =
  let ret = Inner.lock_surface t in
  catch (fun _ -> ret = 0) ignore

let unlock t = Inner.unlock_surface t |> Sdl_types.Result.return

let enable_rle t =
  let ret = Inner.set_surface_rle t 1 in
  catch (fun _ -> ret = 0) ignore

let disable_rle t =
  let ret = Inner.set_surface_rle t 0 in
  catch (fun _ -> ret = 0) ignore

(* Implement get/set_surface_color_mod *)
let get_color_mod surface =
  let module A = CArray in
  let red = CArray.make uint8_t 1
  and green = CArray.make uint8_t 1
  and blue = CArray.make uint8_t 1 in
  let ret = Inner.get_surface_color_mod surface (A.start red) (A.start green) (A.start blue) in
  catch (fun _ -> ret = 0) (fun _ ->
    let module U = Unsigned.UInt8 in
    let to_int_list ary = A.to_list ary |> List.map U.to_int |> List.hd in
    let red = to_int_list red
    and green = to_int_list green
    and blue = to_int_list blue in
    {Color.r = red;b = blue; g = green; a = 255}
  )

let set_color_mod ~surface ~color:{Color.r;g;b;_} =
  let ret = Inner.set_surface_color_mod surface (Unsigned.UInt8.of_int r)
    (Unsigned.UInt8.of_int g) (Unsigned.UInt8.of_int b) in
  catch (fun _ -> ret = 0) ignore

(* Implement get/set_surface_blend_mode *)
let get_blend_mode surface =
  let open Sdlcaml_flags in
  let module A = CArray in
  let mode = A.make uint32_t 1 in
  let ret = Inner.get_surface_blend_mode surface (A.start mode) in
  catch (fun _ -> ret = 0) (fun _ ->
    let module U = Unsigned.UInt32 in
    A.get mode 0 |> U.to_int32 |> Int32.to_int |> Sdl_blendmode.of_int
  )

let set_blend_mode ~surface ~mode =
  let open Sdlcaml_flags in
  let module U = Unsigned.UInt32 in
  let mode = Sdl_blendmode.to_int mode |> Int32.of_int |> U.of_int32 in
  let ret = Inner.set_surface_blend_mode surface mode in
  catch (fun _ -> ret = 0) ignore


(* Implement get/set_surface_alpha_mod *)
let get_alpha_mod surface =
  let module A = CArray in
  let alpha = A.make uint8_t 1 in
  let ret = Inner.get_surface_alpha_mod surface (A.start alpha) in
  catch (fun _ -> ret = 0) (fun _ ->
    let module U = Unsigned.UInt8 in
    U.to_int (A.get alpha 0)
  )

let set_alpha_mod ~surface ~alpha =
  let module U = Unsigned.UInt8 in
  let ret = Inner.set_surface_alpha_mod surface (U.of_int alpha) in
  catch (fun _ -> ret = 0) ignore

(* Implement get/set_surface_color_key *)
let get_color_key surface =
  let module A = CArray in
  let color_key = A.make uint32_t 1 in
  let ret = Inner.get_color_key surface (A.start color_key) in
  catch (fun _ -> ret >= -1) (fun _ ->
    let module U = Unsigned.UInt32 in
    let format = getf (!@ surface) Sdl_types.Surface.format in
    if ret = 0 then
      let key = Sdl_pixels.get_rgb ~pixel:(A.get color_key 0 |> U.to_int32) ~format in
      Some (key)
    else None
  )

let set_color_key ~surface ~key =
  let module U = Unsigned.UInt32 in
  let format = getf (!@ surface) Sdl_types.Surface.format in
  let key = Sdl_pixels.map_rgb format key in
  let ret = Inner.set_color_key surface 1 (U.of_int32 key) in
  catch (fun _ -> ret = 0) ignore

(* Implement get/set_clip_rect*)
let get_clip_rect surface =
  let rect = make Rect.t in
  Inner.get_clip_rect surface (addr rect) |> ignore;
  Rect.to_ocaml rect |> Sdl_types.Result.return 

let set_clip_rect ~surface ~rect =
  let rect = Rect.of_ocaml rect in
  let ret = Inner.set_clip_rect surface (addr rect) |> Sdl_helper.int_to_bool in
  catch (fun _ -> ret) ignore

let rect surface =
  let module S = Sdl_types.Surface in
  Sdl_types.Result.return {
    Rect.x = 0;
    y = 0;
    w = !@(surface |-> Sdl_types.Surface.w);
    h = !@(surface |-> Sdl_types.Surface.h);
  }

let pixel_format_kind surface =
  let module S = Sdl_types.Surface in
  let module F = Sdlcaml_structures.Pixel_format in
  let format = !@(surface |-> S.format) in
  Sdl_types.Result.(match !@(format |-> F.bytes_per_pixel) |> Unsigned.UInt32.to_int32 with
  | 1l -> return `Int8
  | 2l -> return `Int16
  | n when n < 5l -> return `Int32
  | _ -> fail "Unknown bytes of pixels of surface"
  )

let pixels surface kind =
  let module S = Sdl_types.Surface in
  let module F = Sdlcaml_structures.Pixel_format in
  let count = !@(surface |-> S.w) * !@(surface |-> S.h) in
  let pixels = !@(surface |-> S.pixels) in
  let t = typ_of_bigarray_kind kind in 
  bigarray_of_ptr array1 count kind (from_voidp t pixels) |> Sdl_types.Result.return

let () =
  Callback.register_exception "Sdl_surface_exception" (Sdl_surface_exception "any string")
