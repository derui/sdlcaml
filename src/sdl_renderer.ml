open Core.Std
open Ctypes
open Sdlcaml_structures
open Foreign

type t = Sdl_types.Renderer.t
(** The abstract type of renderer *)
let t = Sdl_types.Renderer.t

exception Sdl_renderer_exception of string

module Inner = struct
  let create_renderer = foreign "SDL_CreateRenderer" (Sdl_types.Window.t @-> int @-> uint32_t @-> returning t)
  let create_software_renderer = foreign "SDL_CreateSoftwareRenderer" (Sdl_types.Surface.t @-> returning t)
  let destroy_renderer = foreign "SDL_DestroyRenderer" (t @-> returning void)
  let get_num_render_drivers = foreign "SDL_GetNumRenderDrivers" (void @-> returning int)
  let get_render_draw_blend_mode = foreign "SDL_GetRenderDrawBlendMode"
      (t @-> ptr uint32_t @-> returning int)
  let get_render_draw_color = foreign "SDL_GetRenderDrawColor" (t @-> ptr uint8_t @-> ptr uint8_t @->
                                                                ptr uint8_t @-> ptr uint8_t @->
                                                                returning int)
  let get_render_driver_info = foreign "SDL_GetRenderDriverInfo" (
      int @-> ptr Renderer_info.t @-> returning int)
  let get_render_target = foreign "SDL_GetRenderTarget" (t @-> returning Sdl_types.Texture.t)
  let get_renderer = foreign "SDL_GetRenderer" (Sdl_types.Window.t @-> returning t)
  let get_renderer_info = foreign "SDL_GetRendererInfo" (t @-> ptr Renderer_info.t @-> returning int)
  let get_renderer_output_size = foreign "SDL_GetRendererOutputSize"
      (t @-> ptr int @-> ptr int @-> returning int)
  let render_clear = foreign "SDL_RenderClear" (t @-> returning int)
  let render_copy = foreign "SDL_RenderCopy" (t @-> Sdl_types.Texture.t @-> ptr Rect.t @->
                                              ptr Rect.t @-> returning int)
  let render_draw_line = foreign "SDL_RenderDrawLine" (t @-> int @-> int @-> int @-> int @->
                                                       returning int)
  let render_draw_lines = foreign "SDL_RenderDrawLines" (t @-> ptr Point.t @-> int @-> returning int)
  let render_draw_point = foreign "SDL_RenderDrawPoint" (t @-> int @-> int @-> returning int)
  let render_draw_points = foreign "SDL_RenderDrawPoints" (t @-> ptr Point.t @-> int @-> returning int)
  let render_draw_rect = foreign "SDL_RenderDrawRect" (t @-> ptr Rect.t @-> returning int)
  let render_draw_rects = foreign "SDL_RenderDrawRects" (t @-> ptr Rect.t @-> int @-> returning int)
  let render_fill_rect = foreign "SDL_RenderFillRect" (t @-> ptr Rect.t @-> returning int)
  let render_fill_rects = foreign "SDL_RenderFillRects" (t @-> ptr Rect.t @-> int @-> returning int)
  let render_get_clip_rect= foreign "SDL_RenderGetClipRect" (t @-> ptr Rect.t @-> returning void)
  let render_get_logical_size = foreign "SDL_RenderGetLogicalSize"
      (t @-> ptr int @-> ptr int @-> returning void)
  let render_get_scale = foreign "SDL_RenderGetScale"
      (t @-> ptr float @-> ptr float @-> returning void)
  let render_get_viewport = foreign "SDL_RenderGetViewport" (t @-> ptr Rect.t @-> returning void)
  let render_is_clip_enabled = foreign "SDL_RenderIsClipEnabled" (t @-> returning int)
  let render_present = foreign "SDL_RenderPresent" (t @-> returning void)
  let render_set_clip_rect = foreign "SDL_RenderSetClipRect" (t @-> ptr Rect.t @-> returning int)
  let render_set_logical_size = foreign "SDL_RenderSetLogicalSize" (t @-> int @-> int @-> returning int)
  let render_set_scale = foreign "SDL_RenderSetScale" (t @-> float @-> float @-> returning int)
  let render_set_viewport = foreign "SDL_RenderSetViewport" (t @-> ptr Rect.t @-> returning int)
  let render_target_supported = foreign "SDL_RenderTargetSupported" (t @-> returning int)
  let set_render_draw_blend_mode = foreign "SDL_SetRenderDrawBlendMode"
      (t @-> uint32_t @-> returning int)
  let set_render_draw_color = foreign "SDL_SetRenderDrawColor" (t @-> uint8_t @-> uint8_t @->
                                                                uint8_t @-> uint8_t @-> returning int)
  let set_render_target = foreign "SDL_SetRenderTarget" (t @-> Sdl_types.Texture.t @-> returning int)
end

let catch = Sdl_util.catch

let get_target renderer =
  let target = Inner.get_render_target renderer in
  catch (fun () -> to_voidp target <> null) (fun () -> target)

let create ~window ?index ~flags () =
  let module R = Sdl_types.Resource in 
  let module U = Unsigned.UInt32 in
  let combine_flags = List.fold_left ~f:(fun memo flag -> Int32.bit_or memo flag) ~init:0l in
  let flags = List.map ~f:Sdlcaml_flags.Sdl_renderer_flags.to_int flags |>
      List.map ~f:Int32.of_int_exn |> combine_flags in
  let index = match index with | None -> -1 | Some (index) -> index in
  let renderer = Inner.create_renderer window index (U.of_int32 flags) in
  R.make (fun c -> protectx ~finally:Inner.destroy_renderer ~f:c renderer)

let create_software surface =
  let module R = Sdl_types.Resource in 
  let renderer = Inner.create_software_renderer surface in
  R.make (fun c -> protectx ~finally:Inner.destroy_renderer ~f:c renderer)

let destroy r =
  Inner.destroy_renderer r;
  Sdl_types.Result.return ()

let get_num_render_drivers = Inner.get_num_render_drivers

let get_draw_blend_mode renderer =
  let module A = CArray in
  let flag = A.make uint32_t 1 in
  let ret = Inner.get_render_draw_blend_mode renderer (A.start flag) in
  catch (fun () -> ret = 0) (fun () ->
    A.get flag 0 |> Unsigned.UInt32.to_int32 |> Int32.to_int_exn
                                |> Sdlcaml_flags.Sdl_blendmode.of_int
  )

let get_draw_color surface =
  let module U = Unsigned.UInt8 in
  let module A = CArray in
  let r = A.make uint8_t 1
  and g = A.make uint8_t 1
  and b = A.make uint8_t 1
  and a = A.make uint8_t 1 in
  let ret = Inner.get_render_draw_color surface (A.start r) (A.start g) (A.start b) (A.start a) in
  catch (fun () -> ret = 0) (fun () ->
      {Color.r = A.get r 0 |> U.to_int;
       g = A.get g 0 |> U.to_int;
       b = A.get b 0 |> U.to_int;
       a = A.get a 0 |> U.to_int;
      }
    )

let get_driver_info num =
  let info = make Renderer_info.t in
  let ret = Inner.get_render_driver_info num (addr info) in
  catch (fun () -> ret = 0) (fun () -> Renderer_info.to_ocaml info)

let get window =
  let ret = Inner.get_renderer window in
  catch (fun () -> to_voidp ret <> null) (fun () -> ret)

let get_renderer_info renderer =
  let info = make Renderer_info.t in
  let ret = Inner.get_renderer_info renderer (addr info) in
  catch (fun () -> ret = 0) (fun () -> Renderer_info.to_ocaml info)

let get_output_size renderer =
  let width = CArray.make int 1
  and height = CArray.make int 1 in
  let ret = Inner.get_renderer_output_size renderer (CArray.start width) (CArray.start height) in
  catch (fun () -> ret = 0) (fun () -> {Size.width = CArray.get width 0;height = CArray.get height 0})

let clear renderer =
  let ret = Inner.render_clear renderer in
  catch (fun () -> ret = 0) ignore

let copy ~renderer ~texture ?src ?dst () =
  let rect_to_ptr r = match r with | None -> from_voidp Rect.t null | Some r -> Rect.of_ocaml r |> addr in
  let src = rect_to_ptr src
  and dst = rect_to_ptr dst in
  let ret = Inner.render_copy renderer texture src dst in
  catch (fun () -> ret = 0) ignore

let draw_line ~renderer ~startp ~endp =
  let module P = Point in
  let ret = Inner.render_draw_line renderer startp.P.x startp.P.y endp.P.x endp.P.y in
  catch (fun () -> ret = 0) ignore

let draw_lines ~renderer ~points =
  let count = List.length points in
  let points = List.map ~f:Point.of_ocaml points |> CArray.of_list Point.t in
  let ret = Inner.render_draw_lines renderer (CArray.start points) count in
  catch (fun () -> ret = 0) ignore

let draw_point ~renderer ~point =
  let module P = Point in
  let ret = Inner.render_draw_point renderer point.P.x point.P.y in
  catch (fun () -> ret = 0) ignore

let draw_points ~renderer ~points =
  let module P = Point in
  let points = List.map ~f:P.of_ocaml points |> CArray.of_list P.t in
  let ret = Inner.render_draw_points renderer (CArray.start points) (CArray.length points) in
  catch (fun () -> ret = 0) ignore

let draw_rect ~renderer ~rect =
  let rect = Rect.of_ocaml rect in
  let ret = Inner.render_draw_rect renderer (addr rect) in
  catch (fun () -> ret = 0) ignore

let draw_rects ~renderer ~rects =
  let rects = List.map ~f:Rect.of_ocaml rects |> CArray.of_list Rect.t in
  let ret = Inner.render_draw_rects renderer (CArray.start rects) (CArray.length rects) in
  catch (fun () -> ret = 0) ignore

let get_clip_rect renderer =
  let rect = make Rect.t in
  Inner.render_get_clip_rect renderer (addr rect);
  Rect.to_ocaml rect

let get_logical_size renderer =
  let module A = CArray in
  let width = CArray.make int 1
  and height = CArray.make int 1 in
  Inner.render_get_logical_size renderer (CArray.start width) (CArray.start height);
  {Size.width = A.get width 0; height = A.get height 0}

let get_scale renderer =
  let module A = CArray in
  let sx = A.make float 1
  and sy = A.make float 1 in
  Inner.render_get_scale renderer (A.start sx) (A.start sy);
  (A.get sx 0, A.get sy 0)

let get_viewport renderer =
  let rect = make Rect.t in
  Inner.render_get_viewport renderer (addr rect);
  Rect.to_ocaml rect

let is_clip_enabled renderer = Inner.render_is_clip_enabled renderer |> Sdl_helper.int_to_bool

let present = Inner.render_present

let set_clip_rect ~renderer ~rect =
  let rect = Rect.of_ocaml rect in
  let ret = Inner.render_set_clip_rect renderer (addr rect) in
  catch (fun () -> ret = 0) ignore

let set_logical_size ~renderer ~size =
  let ret = Inner.render_set_logical_size renderer size.Size.width size.Size.height in
  Sdl_helper.ret_to_result ret ignore

let set_scale ~renderer ~scale =
  let sx, sy = scale in
  Sdl_helper.ret_to_result (Inner.render_set_scale renderer sx sy) ignore

let set_viewport ~renderer ~rect =
  let rect = Rect.of_ocaml rect in
  Sdl_helper.ret_to_result (Inner.render_set_viewport renderer (addr rect)) ignore

let is_target_supported renderer = Inner.render_target_supported renderer |> Sdl_helper.int_to_bool

let set_draw_blend_mode renderer blendmode =
  let open Sdlcaml_flags in
  let flag = Sdl_blendmode.to_int blendmode |> Int32.of_int_exn |> Unsigned.UInt32.of_int32 in
  let ret = Inner.set_render_draw_blend_mode renderer flag in
  catch (fun () -> ret = 0) ignore

let set_draw_color surface {Color.r;g;b;a} =
  let module U = Unsigned.UInt8 in
  let tc = U.of_int in
  let ret = Inner.set_render_draw_color surface (tc r) (tc g) (tc b) (tc a) in
  catch (fun () -> ret = 0) ignore

let set_target ~renderer ~texture =
  Sdl_helper.ret_to_result (Inner.set_render_target renderer texture) ignore

let () =
  Callback.register_exception "Sdl_renderer_exception" (Sdl_renderer_exception "Some error")
