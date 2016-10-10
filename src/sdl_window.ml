open Sdlcaml_structures
open Ctypes
open Foreign

exception Sdl_window_exception of string

(** A type of the window that was created via {Sdl_window.create}. *)
type id = int32
type t = Sdl_types.Window.t

let t = Sdl_types.Window.t

type creation = [ `FULLSCREEN
                | `FULLSCREEN_DESKTOP
                | `OPENGL
                | `HIDDEN
                | `BORDERLESS
                | `RESIZABLE
                | `MINIMIZED
                | `MAXIMIZED
                | `INPUT_GRABBED
                | `ALLOW_HIGHDPI
                ]

let rec creation_to_int = function
  | `FULLSCREEN -> 0x1
  | `FULLSCREEN_DESKTOP -> 0x1000 lor (creation_to_int `FULLSCREEN)
  | `OPENGL -> 0x2
  | `HIDDEN -> 0x8
  | `BORDERLESS -> 0x10
  | `RESIZABLE -> 0x20
  | `MINIMIZED -> 0x40
  | `MAXIMIZED -> 0x80
  | `INPUT_GRABBED -> 0x100
  | `ALLOW_HIGHDPI -> 0x2000
  | _ -> invalid_arg "Sdl_window.creation"

module Inner = struct
  let create = foreign "SDL_CreateWindow" (string @-> int @-> int @-> int @-> int @-> int @-> returning t)
  let destroy = foreign "SDL_DestroyWindow" (t @-> returning void)
  let get_brightness = foreign "SDL_GetWindowBrightness" (t @-> returning float)
  let get_display_index = foreign "SDL_GetWindowDisplayIndex" (t @-> returning int)
  let get_display_mode = foreign "SDL_GetWindowDisplayMode" (t @-> ptr Display_mode.t @-> returning int)
  let get_window_flags = foreign "SDL_GetWindowFlags" (t @-> returning uint32_t)
  let get_from_id = foreign "SDL_GetWindowFromID" (uint32_t @-> returning t)
  let get_gamma_ramp =
    foreign "SDL_GetWindowGammaRamp" (t @-> ptr uint16_t @-> ptr uint16_t @-> ptr uint16_t @-> returning int)
  let get_grab = foreign "SDL_GetWindowGrab" (t @-> returning int)
  let get_id = foreign "SDL_GetWindowID" (t @-> returning uint32_t)
  let get_maximum_size = foreign "SDL_GetWindowMaximumSize" (t @-> ptr int @-> ptr int @-> returning void)
  let get_minimum_size = foreign "SDL_GetWindowMinimumSize" (t @-> ptr int @-> ptr int @-> returning void)
  let get_pixel_format = foreign "SDL_GetWindowPixelFormat" (t @-> returning uint32_t)
  let get_position = foreign "SDL_GetWindowPosition" (t @-> ptr int @-> ptr int @-> returning void)
  let get_size = foreign "SDL_GetWindowSize" (t @-> ptr int @-> ptr int @-> returning void)
  let get_surface = foreign "SDL_GetWindowSurface" (t @-> returning Sdl_types.Surface.t)
  let get_title = foreign "SDL_GetWindowTitle" (t @-> returning string)
  let get_window_wm_info = foreign "SDL_GetWindowWMInfo" (t @-> ptr Sys_wm_info.t @-> returning int)
  let hide = foreign "SDL_HideWindow" (t @-> returning void)
  let show = foreign "SDL_ShowWindow" (t @-> returning void)
  let maximize = foreign "SDL_MaximizeWindow" (t @-> returning void)
  let minimize = foreign "SDL_MinimizeWindow" (t @-> returning void)
  let to_raise = foreign "SDL_RaiseWindow" (t @-> returning void)
  let restore = foreign "SDL_RestoreWindow" (t @-> returning void)
  let set_bordered = foreign "SDL_SetWindowBordered" (t @-> int @-> returning void)
  let set_brightness = foreign "SDL_SetWindowBrightness" (t @-> float @-> returning void)
  let set_display_mode = foreign "SDL_SetWindowDisplayMode" (t @-> ptr Display_mode.t @-> returning int)
  let set_fullscreen = foreign "SDL_SetWindowFullscreen" (t @-> uint32_t @-> returning int)
  let set_gamma_ramp = foreign "SDL_SetWindowGammaRamp" (t @-> ptr uint16_t @-> ptr uint16_t @->
                                                         ptr uint16_t @-> returning int)
  let grab = foreign "SDL_SetWindowGrab" (t @-> int @-> returning void)
  let set_icon = foreign "SDL_SetWindowIcon" (t @-> Sdl_types.Surface.t @-> returning void)
  let set_maximum_size = foreign "SDL_SetWindowMaximumSize" (t @-> int @-> int @-> returning void)
  let set_minimum_size = foreign "SDL_SetWindowMinimumSize" (t @-> int @-> int @-> returning void)
  let set_position = foreign "SDL_SetWindowPosition" (t @-> int @-> int @-> returning void)
  let set_size = foreign "SDL_SetWindowSize" (t @-> int @-> int @-> returning void)
  let set_title = foreign "SDL_SetWindowTitle" (t @-> string @-> returning void)
  let update_surface = foreign "SDL_UpdateWindowSurface" (t @-> returning void)
  let update_surface_rects = foreign "SDL_UpdateWindowSurfaceRects"
      (t @-> ptr Rect.t @->  int @-> returning int)
end

let catch pred success = Sdl_util.catch_exn (fun s -> Sdl_window_exception s) pred success

let destroy w = Inner.destroy w |> ignore

let create ~title ~x ~y ~w ~h ~flags =
  let open Core.Std in
  let module R = Sdl_types.Resource in 
  let flags = List.fold_left flags ~f:(fun flags flg ->
      flags lor (creation_to_int flg)) ~init:0 in
  let window = Inner.create title x y w h flags in

  catch (fun _ -> to_voidp window <> null) (fun _ ->
    R.make (fun c -> protectx ~finally:destroy ~f:c window)
  )

let get_brightness w = Inner.get_brightness w
let get_display_index w = Inner.get_display_index w

let get_display_mode window =
  let display_mode = make Display_mode.t in
  let ret = Inner.get_display_mode window (addr display_mode) in
  catch (fun () -> ret = 0) (fun () -> Display_mode.to_ocaml display_mode)

let get_window_flags window =
  let module F = Sdlcaml_flags.Sdl_window_flags in
  let flags = Inner.get_window_flags window in
  List.fold_left (fun ret flag ->
      let open Unsigned.UInt32.Infix in
      let raw_flag = F.to_int flag |> Int32.of_int |> Unsigned.UInt32.of_int32 in
      if flags land raw_flag = raw_flag then
        flag :: ret
      else
        ret
    ) [] F.flags

let get_from_id id =
  let w = Inner.get_from_id (Unsigned.UInt32.of_int32 id) in
  catch (fun _ -> to_voidp w <> null) (fun _ -> w)

let get_gamma_ramp w =
  let module U = Unsigned.UInt16 in 
  let module A = CArray in 
  let red = CArray.make uint16_t 1
  and green = CArray.make uint16_t 1
  and blue = CArray.make uint16_t 1 in
  let ret = Inner.get_gamma_ramp w (A.start red) (A.start green) (A.start blue) in
  catch (fun _ -> ret = 0)
    (fun _ ->
       let to_int_list ary = A.to_list ary |> List.map U.to_int |> A.of_list int in
       let red = to_int_list red
       and green = to_int_list green
       and blue = to_int_list blue in
       {Gamma_ramp.red = red; green; blue}
    )

let get_grab w =
  let grabbed = Inner.get_grab w in
  Sdl_helper.int_to_bool grabbed

let get_id w = Inner.get_id w |> Unsigned.UInt32.to_int32

let get_maximum_size w =
  let module A = CArray in
  let width = A.make int 1
  and height = A.make int 1 in
  Inner.get_maximum_size w (A.start width) (A.start height) |> ignore;
  {Size.width = A.get width 0; height = A.get height 0}

let get_minimum_size w =
  let module A = CArray in
  let width = A.make int 1
  and height = A.make int 1 in
  Inner.get_minimum_size w (A.start width) (A.start height) |> ignore;
  {Size.width = A.get width 0; height = A.get height 0}

let get_pixel_format w =
  let flag = Inner.get_pixel_format w in
  let flag = Unsigned.UInt32.to_int32 flag in
  Sdlcaml_flags.Sdl_pixel_format_enum.of_int32 flag

let get_position w =
  let module A = CArray in
  let x = A.make int 1
  and y = A.make int 1 in
  Inner.get_position w (A.start x) (A.start y) |> ignore;
  {Point.x = A.get x 0; y = A.get y 0}

let get_size w =
  let module A = CArray in
  let width = A.make int 1
  and height = A.make int 1 in
  Inner.get_size w (A.start width) (A.start height) |> ignore;
  {Size.width = A.get width 0; height = A.get height 0}

let get_surface window =
  let surface = Inner.get_surface window in
  catch (fun _ -> to_voidp surface <> null) (fun _ -> surface)

let get_title = Inner.get_title

let get_window_wm_info w =
  let syswm = make Sys_wm_info.t in
  let ret = Inner.get_window_wm_info w (addr syswm) in
  catch (fun _ -> Sdl_helper.int_to_bool ret)
    (fun _ -> Sys_wm_info.to_ocaml syswm)

let hide = Inner.hide
let show = Inner.show

let maximize = Inner.maximize 
let minimize = Inner.minimize 
let to_raise = Inner.to_raise 
let restore = Inner.restore 

let set_bordered w bordered = Inner.set_bordered w (Sdl_helper.bool_to_int bordered)

let set_brightness w brightness = Inner.set_brightness w brightness

let set_display_mode window display_mode =
  let display_mode = Display_mode.of_ocaml display_mode in
  let ret = Inner.set_display_mode window (addr display_mode) in
  catch (fun _ -> ret = 0) ignore

let set_fullscreen w =
  let open Sdlcaml_flags in
  let flag = Sdl_window_flags.to_int `FULLSCREEN in
  let ret = Inner.set_fullscreen w (Unsigned.UInt32.of_int flag) in
  catch (fun _ -> ret = 0) ignore

let set_fullscreen_desktop w =
  let open Sdlcaml_flags in
  let flag = Sdl_window_flags.to_int `FULLSCREEN_DESKTOP in
  let ret = Inner.set_fullscreen w (Unsigned.UInt32.of_int flag) in
  catch (fun _ -> ret = 0) ignore

let set_gamma_ramp w ramp =
  let open Sdl_types in
  let to_int16_array ary = CArray.to_list ary |> List.map Unsigned.UInt16.of_int |> CArray.of_list uint16_t in
  let red = to_int16_array ramp.Gamma_ramp.red
  and green = to_int16_array ramp.Gamma_ramp.green
  and blue = to_int16_array ramp.Gamma_ramp.blue in
  let ret = Inner.set_gamma_ramp w (CArray.start red) (CArray.start green) (CArray.start blue) in
  catch (fun _ -> ret = 0) ignore

let grab_input w = Inner.grab w (Sdl_helper.bool_to_int true)
let release_input w = Inner.grab w (Sdl_helper.bool_to_int false)

let set_icon = Inner.set_icon

let set_maximum_size w s = Inner.set_maximum_size w s.Size.width s.Size.height
let set_minimum_size w s = Inner.set_minimum_size w s.Size.width s.Size.height
let set_position w p = Inner.set_position w p.Point.x p.Point.y
let set_size w s = Inner.set_size w s.Size.width s.Size.height

let set_title = Inner.set_title

let update_surface = Inner.update_surface

let update_surface_rects w rects =
  let rects = List.map Rect.of_ocaml rects in
  let rects = CArray.of_list Rect.t rects in
  let ret = Inner.update_surface_rects w (CArray.start rects) (CArray.length rects) in
  catch (fun _ -> ret = 0) ignore

let () =
  Callback.register_exception "Sdl_window_exception" (Sdl_window_exception "any string")
