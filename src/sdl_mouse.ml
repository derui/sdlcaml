open Sdlcaml_structures
open Sdlcaml_flags
open Ctypes
open Foreign
open Core.Std

type system
type original
type current

type 'a t = Sdl_types.Cursor.t
let t = Sdl_types.Cursor.t
(** The type of Mouse instance *)

type show_state = [`SHOWN | `HIDDEN]


(* state of the mouse *)
module State = struct
  type t = {
    point: Point.t;
    states: Sdl_mousebutton.t list;
  }
  let point {point;_} = point
  let states {states;_} = states
end

module Inner = struct
  let capture_mouse = foreign "SDL_CaptureMouse" (int @-> returning int)
  let create_system_cursor = foreign "SDL_CreateSystemCursor" (int @-> returning t)
  let free_cursor = foreign "SDL_FreeCursor" (t @-> returning void)
  let get_cursor = foreign "SDL_GetCursor" (void @-> returning t)
  let get_global_mouse_state = foreign "SDL_GetGlobalMouseState" (
    ptr int @-> ptr int @-> returning uint32_t)
  let get_mouse_focus = foreign "SDL_GetMouseFocus" (void @-> returning Sdl_types.Window.t)
  let get_mouse_state = foreign "SDL_GetMouseState" (
    ptr int @-> ptr int @-> returning uint32_t)
  let get_relative_mouse_mode = foreign "SDL_GetRelativeMouseMode" (void @-> returning int)
  let get_relative_mouse_state = foreign "SDL_GetRelativeMouseState" (
    ptr int @-> ptr int @-> returning uint32_t)
  let set_cursor = foreign "SDL_SetCursor" (t @-> returning void)
  let set_relative_mouse_mode = foreign "SDL_SetRelativeMouseMode" (int @-> returning int)
  let show_cursor = foreign "SDL_ShowCursor" (int @-> returning int)
  let warp_mouse_global = foreign "SDL_WarpMouseGlobal" (int @-> int @-> returning int)
  let warp_mouse_in_window = foreign "SDL_WarpMouseInWindow" (int @-> int @-> returning int)
end

let catch = Sdl_util.catch

let capture flg = 
  let flg = Sdl_helper.bool_to_int true in
  let ret = Inner.capture_mouse flg in
  catch (fun () -> ret = 0) ignore

let enable_capture () = capture true
let disable_capture () = capture false

let create_system_cursor cursor =
  let module R = Sdl_types.Resource in 
  let flg = Sdl_system_cursor.to_int cursor in
  let ret = Inner.create_system_cursor flg in
  R.make (fun c -> protectx ~finally:Inner.free_cursor ~f:c ret)

let get () =
  let current = Inner.get_cursor () in
  if to_voidp current = null then None else Some current

let fetch_state_from_sdl f =
  let ary = CArray.make int 2 in
  let to_addr i = CArray.start ary +@ i in 
  let states = f (to_addr 0) (to_addr 1) in
  {
    State.point = {Point.x = CArray.get ary 0; y = CArray.get ary 1};
    states = Unsigned.UInt32.(Sdl_mousebutton.of_int_list (to_int states));
  }

let get_global_state () =
  fetch_state_from_sdl Inner.get_global_mouse_state

let get_focus () =
  let win = Inner.get_mouse_focus () in
  if to_voidp win = null then None else Some win

let get_state () = fetch_state_from_sdl Inner.get_mouse_state

let get_relative_mode () = Inner.get_relative_mouse_mode () |> Sdl_helper.int_to_bool
let set_relative_mode b =
  let ret = Sdl_helper.bool_to_int b |> Inner.set_relative_mouse_mode in
  catch (fun () -> ret = 0) ignore

let get_relative_state () = fetch_state_from_sdl Inner.get_relative_mouse_state

let set cursor = Inner.set_cursor cursor

let toggle state = 
  let ret = Inner.show_cursor state in
  catch (fun () -> ret >= 0) (fun () ->
    match ret with
    | 0 -> `HIDDEN
    | 1 -> `SHOWN
    | _ -> failwith "Unknown cursor status to show"
  )

let show () = toggle 1
let hide () = toggle 0
let is_showing () = toggle (-1) (* Send query only. *)

let warp_with f = fun p ->
  let ret = f p.Point.x p.Point.y in
  catch (fun () -> ret = 0) ignore

let warp_global = warp_with Inner.warp_mouse_global
let warp_in_window = warp_with Inner.warp_mouse_in_window
